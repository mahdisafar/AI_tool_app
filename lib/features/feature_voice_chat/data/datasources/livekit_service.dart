import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../../core/constants/constant.dart';

class VoiceSessionData {
  final VoiceStatus status;
  final AudioTrack? audioTrack;
  final double audioLevel;

  VoiceSessionData({
    required this.status,
    this.audioTrack,
    this.audioLevel = 0.0,
  });
}

enum VoiceStatus { connecting, listening, thinking, speaking, disconnected }

@lazySingleton
class LivekitService {
  Room? _room;
  Room get room {
    _room ??= Room();
    return _room!;
  }

  Future<void> startSession({String? url, String? token}) async {
    await _room?.disconnect();
    await _room?.dispose();
    _room = Room();

    final connectUrl = url ?? Aiapi.livekitUrl;
    final connectToken = token ?? Aiapi.livekitTestToken;

    await room.connect(connectUrl, connectToken);
  }

  Future<void> disconnectMic() async {
    if (_room != null && room.connectionState == ConnectionState.connected) {
      await room.localParticipant?.setMicrophoneEnabled(false);
    }
  }

  Future<void> connectMic() async {
    if (_room != null && room.connectionState == ConnectionState.connected) {
      await room.localParticipant?.setMicrophoneEnabled(true);
    }
  }

  Future<void> endCall() async {
    await _room?.disconnect();
    await _room?.dispose();
    _room = null;
  }

  Stream<VoiceSessionData> observeVoiceSession() {
    final controller = StreamController<VoiceSessionData>.broadcast();
    RemoteParticipant? lastAgent;

    void emitCurrentState() {
      if (controller.isClosed) return;

      if (_room == null ||
          room.connectionState == ConnectionState.disconnected) {
        controller.add(VoiceSessionData(status: VoiceStatus.disconnected));
        return;
      }

      final agent = room.remoteParticipants.values.firstOrNull;

      if (agent != lastAgent) {
        lastAgent?.removeListener(emitCurrentState);
        agent?.addListener(emitCurrentState);
        lastAgent = agent;
      }

      final track = agent?.audioTrackPublications.firstOrNull?.track;
      final AudioTrack? agentAudioTrack = track is AudioTrack ? track : null;

      VoiceStatus status = VoiceStatus.listening;

      if (room.connectionState == ConnectionState.connecting) {
        status = VoiceStatus.connecting;
      } else if (room.connectionState == ConnectionState.disconnected) {
        status = VoiceStatus.disconnected;
      } else if (agent != null) {
        bool isSpeaking = agent.isSpeaking || (agent.audioLevel > 0.05);

        if (isSpeaking) {
          status = VoiceStatus.speaking;
        } else if (agent.attributes['lk.agent.state'] == 'thinking') {
          status = VoiceStatus.thinking;
        } else {
          status = VoiceStatus.listening;
        }
      }

      controller.add(
        VoiceSessionData(
          status: status,
          audioTrack: agentAudioTrack,
          audioLevel: agent?.audioLevel ?? 0.0,
        ),
      );
    }

    if (_room != null) {
      room.addListener(emitCurrentState);
    }

    emitCurrentState();

    controller.onCancel = () {
      _room?.removeListener(emitCurrentState);
      lastAgent?.removeListener(emitCurrentState);
      controller.close();
    };

    return controller.stream;
  }
}
