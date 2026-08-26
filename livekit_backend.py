import json
import logging
import os
import sys
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse

try:
    import spaces
    _HAS_SPACES = True
except ImportError:
    _HAS_SPACES = False

from dotenv import load_dotenv

from livekit.agents import (
    Agent,
    AgentSession,
    JobContext,
    RoomInputOptions,
    WorkerOptions,
    cli,
)
from livekit.plugins import google
from livekit.api import AccessToken

load_dotenv()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("gemini-livekit-agent")

REQUIRED_ENV_VARS = ["LIVEKIT_URL", "LIVEKIT_API_KEY", "LIVEKIT_API_SECRET", "GEMINI_API_KEY"]

MODEL_NAME = "gemini-2.5-flash-native-audio-preview-12-2025"

SYSTEM_INSTRUCTIONS = (
    "You are a friendly and polite voice assistant. Your DEFAULT language is "
    "Persian (Farsi). You must always reply in Persian using a natural, warm, "
    'and conversational Iranian accent. CRITICAL RULE: Only switch to English '
    'if the user explicitly asks you to "speak in English" or "reply in '
    'English". Once that conversation ends, revert back to Persian.'
)


# ---------------------------------------------------------------------------
# 0. ZeroGPU startup probe
# ---------------------------------------------------------------------------
if _HAS_SPACES:
    @spaces.GPU
    def _zerogpu_startup_probe():
        return None


# ---------------------------------------------------------------------------
# 1. Token generation helper
# ---------------------------------------------------------------------------
def generate_livekit_token(identity: str, room_name: str = "mms") -> str:
    """Generate a LiveKit access token server-side."""
    api_key = os.environ.get("LIVEKIT_API_KEY")
    api_secret = os.environ.get("LIVEKIT_API_SECRET")

    if not api_key or not api_secret:
        raise RuntimeError("LIVEKIT_API_KEY or LIVEKIT_API_SECRET not configured")

    token = AccessToken(api_key, api_secret) \
        .with_identity(identity) \
        .with_name(identity) \
        .with_grants(
            room_join=True,
            room=room_name,
            can_publish=True,
            can_subscribe=True,
        )

    return token.to_jwt()


# ---------------------------------------------------------------------------
# 2. HTTP server (Health check + Token endpoint)
# ---------------------------------------------------------------------------
class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path

        # --- Health Check ---
        if path == "/" or path == "/health":
            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            html = "<h1>\U0001F916 Gemini LiveKit Backend is Running!</h1>"
            self.wfile.write(html.encode("utf-8"))
            return

        # --- Token Endpoint ---
        if path == "/token":
            try:
                # Parse query params (e.g. ?identity=user_1&room=mms)
                from urllib.parse import parse_qs
                params = parse_qs(parsed.query)

                identity = params.get("identity", ["user_1"])[0]
                room_name = params.get("room", ["mms"])[0]

                jwt_token = generate_livekit_token(identity, room_name)

                self.send_response(200)
                self.send_header("Content-type", "application/json; charset=utf-8")
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()

                response = {
                    "token": jwt_token,
                    "livekit_url": os.environ.get("LIVEKIT_URL", ""),
                    "room": room_name,
                    "identity": identity,
                }
                self.wfile.write(json.dumps(response).encode("utf-8"))
                logger.info(f"Token generated for identity={identity}, room={room_name}")

            except Exception as e:
                logger.error(f"Token generation failed: {e}")
                self.send_response(500)
                self.send_header("Content-type", "application/json")
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()
                self.wfile.write(json.dumps({"error": str(e)}).encode("utf-8"))
            return

        # --- 404 ---
        self.send_response(404)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({"error": "Not found"}).encode("utf-8"))

    def do_OPTIONS(self):
        # CORS preflight
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def log_message(self, format, *args):
        return


def start_http_server() -> None:
    server = HTTPServer(("0.0.0.0", 7860), RequestHandler)
    logger.info("HTTP server listening on 0.0.0.0:7860")
    server.serve_forever()


# ---------------------------------------------------------------------------
# 3. LiveKit agent
# ---------------------------------------------------------------------------
class VoiceAssistant(Agent):
    def __init__(self) -> None:
        super().__init__(instructions=SYSTEM_INSTRUCTIONS)


async def entrypoint(ctx: JobContext) -> None:
    await ctx.connect()

    session = AgentSession(
        llm=google.beta.realtime.RealtimeModel(
            model=MODEL_NAME,
            api_key=os.environ.get("GEMINI_API_KEY"),
            instructions=SYSTEM_INSTRUCTIONS,
            voice="Puck",
        ),
    )

    await session.start(
        room=ctx.room,
        agent=VoiceAssistant(),
        room_input_options=RoomInputOptions(),
    )


# ---------------------------------------------------------------------------
# 4. Bootstrap
# ---------------------------------------------------------------------------
def main() -> None:
    missing = [v for v in REQUIRED_ENV_VARS if not os.environ.get(v)]
    if missing:
        logger.warning("Missing environment variables: %s", ", ".join(missing))

    threading.Thread(target=start_http_server, daemon=True).start()

    if len(sys.argv) == 1:
        sys.argv.append("start")

    cli.run_app(WorkerOptions(entrypoint_fnc=entrypoint))


if __name__ == "__main__":
    main()
