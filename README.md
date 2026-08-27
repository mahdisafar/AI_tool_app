# AI Tool App

A Flutter application designed for daily AI-powered workflows: message rewriting, task generation, streaming text chat, and real-time voice interactions.



















---

## Key Features

| Feature | Description |
| --- | --- |
| **Clean Message** | Rewrites text into various tones (Formal, Friendly, Polite, etc.) |
| **Make Task** | Extracts task lists from unstructured text and saves them locally |
| **Chat** | Real-time streaming chat with multi-session history management |
| **Live Chat** | Real-time, low-latency voice conversation powered by LiveKit |

---

## 1. Clean Message

Rewrites user messages using the Qwen model via GapGPT. Supports multiple tone presets:
- `FORMAL`
- `FRIENDLY`
- `POLITE`
- `ROMANTIC`
- `APOLOGETIC`

Outputs are stored locally in Hive with options to refresh or delete entries.

<p align="center">
  <video src="https://github.com/user-attachments/assets/38688942-c3ac-44d4-9310-5b49296973dc" width="360" controls playsinline muted></video>
</p>

---

## 2. Make Task

Converts raw text into structured task items (Title + Description) using system prompts. Features swipe-to-delete, input dialogs, expandable FABs, and persistent storage via Hive.

<p align="center">
  <video src="https://github.com/user-attachments/assets/00691dcf-5353-4867-a5b8-be13276413be" width="360" controls playsinline muted></video>
</p>

---

## 3. Streaming Chat

Interactive streaming text chat leveraging Hugging Face (`Qwen/Qwen2.5-7B-Instruct`). Includes multi-chat archive drawer, conversation history, and prepared support for multimodal inputs (`image_url`).

<p align="center">
  <video src="https://github.com/user-attachments/assets/71cdd154-b8c1-4126-9f83-b0bebd021574" width="360" controls playsinline muted></video>
</p>

---

## 4. Live Chat (Voice AI)

Real-time voice conversation powered by LiveKit. Handles backend token generation, dynamic audio visualizers, microphone controls, and real-time status updates (*connecting*, *listening*, *thinking*, *speaking*).

<p align="center">
  <video src="https://github.com/user-attachments/assets/d73b1882-2bb2-4438-888f-e18edc9ba67a" width="360" controls playsinline muted></video>
</p>

---

## Architecture & Tech Stack

Built following **Clean Architecture** principles structured by feature (`data`, `domain`, `presentation`):

* **State Management:** BLoC / Cubit
* **Dependency Injection:** GetIt + Injectable
* **Navigation:** GoRouter
* **Local Storage:** Hive
* **Networking & Realtime:** Dio, `dart_openai`, LiveKit