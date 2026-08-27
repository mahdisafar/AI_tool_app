import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/datasources/livekit_service.dart';

class VoiceVisualizer extends StatefulWidget {
  final VoiceSessionData sessionData;

  const VoiceVisualizer({super.key, required this.sessionData});

  @override
  State<VoiceVisualizer> createState() => _VoiceVisualizerState();
}

class _VoiceVisualizerState extends State<VoiceVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _particleCount = 40;
  final List<Particle> _particles = [];
  Size _viewportSize = Size.zero;

  
  double _smoothedAudioLevel = 0.0;
  double _currentRadius = 60.0; 

  
  double _speakingMix = 0.0;
  double _disconnectedMix = 0.0;

  
  DateTime _lastSpeakingTime = DateTime.now();

  final List<Color> _colors = [
    const Color(0xFFE3F2FD),
    const Color(0xFF90CAF9),
    const Color(0xFF64B5F6),
    const Color(0xFF42A5F5),
    const Color(0xFF2196F3),
    const Color(0xFF1E88E5),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..repeat()
      ..addListener(_updatePhysics);

    final random = Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          position: Offset.zero,
          velocity: Offset.zero,
          radius: 2.4 + random.nextDouble() * 4.8, 
          color: _colors[random.nextInt(_colors.length)],
          angle: random.nextDouble() * 2 * pi,
          speedFactor: 0.5 + random.nextDouble() * 1.5,
        ),
      );
    }
  }

  void _updatePhysics() {
    if (_viewportSize == Size.zero) return;

    final center = Offset(_viewportSize.width / 2, _viewportSize.height / 2);
    final status = widget.sessionData.status;

    if (status == VoiceStatus.speaking) {
      _lastSpeakingTime = DateTime.now();
    }

    
    _smoothedAudioLevel =
        lerpDouble(_smoothedAudioLevel, widget.sessionData.audioLevel, 0.15)!;

    
    bool isVisuallySpeaking = status == VoiceStatus.speaking ||
        DateTime.now().difference(_lastSpeakingTime).inMilliseconds < 800;

    
    double targetSpeaking = isVisuallySpeaking ? 1.0 : 0.0;
    double speakingLerpSpeed = isVisuallySpeaking ? 0.08 : 0.02;
    _speakingMix = lerpDouble(_speakingMix, targetSpeaking, speakingLerpSpeed)!;

    double targetDisconnected =
        (status == VoiceStatus.disconnected) ? 1.0 : 0.0;
    _disconnectedMix = lerpDouble(_disconnectedMix, targetDisconnected, 0.05)!;

    
    double targetRadius = 48.0;
    double swirlSpeed = 0.01;

    if (status == VoiceStatus.thinking) {
      targetRadius = 84.0; 
      swirlSpeed = 0.03;
    } else if (status == VoiceStatus.listening ||
        status == VoiceStatus.connecting) {
      targetRadius = 60.0; 
      swirlSpeed = 0.015;
    } else if (isVisuallySpeaking) {
      targetRadius = 72.0; 
      swirlSpeed = 0.02;
    }
    _currentRadius = lerpDouble(_currentRadius, targetRadius, 0.05)!;

    setState(() {
      for (int i = 0; i < _particles.length; i++) {
        var p = _particles[i];

        
        p.angle += swirlSpeed * p.speedFactor;
        double noiseX = cos(p.angle * 3) * 8;
        double noiseY = sin(p.angle * 2) * 8;
        Offset circlePos = center +
            Offset(cos(p.angle), sin(p.angle)) * _currentRadius +
            Offset(noiseX, noiseY);

        
        double time = _controller.value * pi * 4;

        double wave1 = sin(p.angle * 5 + time * 3);
        double wave2 = cos(p.angle * 8 - time * 2);
        double wave3 = sin(p.angle * 12 + time);

        double compositeWave = (wave1 + wave2 + wave3) / 3.0;

        
        double amplitude = _smoothedAudioLevel * 96.0; 

        double wavyRadius = _currentRadius + (compositeWave * amplitude);

        Offset wavyCirclePos =
            center + Offset(cos(p.angle), sin(p.angle)) * wavyRadius;

        
        Offset? connectedTarget =
            Offset.lerp(circlePos, wavyCirclePos, _speakingMix);

        
        double floorX = center.dx + (i - _particleCount / 2) * 8;
        double floorY = _viewportSize.height - 20;
        Offset floorPos = Offset(floorX, floorY);

        
        Offset? finalTarget =
            Offset.lerp(connectedTarget, floorPos, _disconnectedMix);

        
        Offset diff = finalTarget! - p.position;
        p.velocity = p.velocity + diff * 0.05;
        p.velocity = p.velocity * 0.85;

        
        if (_disconnectedMix > 0.1) {
          p.velocity = p.velocity + Offset(0, 0.5 * _disconnectedMix);
        }

        p.position = p.position + p.velocity;

        
        if (p.position.dy > _viewportSize.height - 20) {
          p.position = Offset(p.position.dx, _viewportSize.height - 20);
          if (p.velocity.dy > 0) {
            p.velocity = Offset(p.velocity.dx * 0.6, p.velocity.dy * -0.7);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportSize = constraints.biggest;
        final center =
            Offset(_viewportSize.width / 2, _viewportSize.height / 2);

        for (var p in _particles) {
          if (p.position == Offset.zero ||
              p.position.dx > _viewportSize.width ||
              p.position.dy > _viewportSize.height) {
            p.position =
                center + Offset(cos(p.angle), sin(p.angle)) * _currentRadius;
          }
        }

        return ClipRect(
          child: CustomPaint(
            size: Size.infinite,
            painter: _PS5ParticlePainter(
              particles: _particles,
              status: widget.sessionData.status,
              glowIntensity: _smoothedAudioLevel,
            ),
          ),
        );
      },
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  final double radius;
  final Color color;
  double angle;
  final double speedFactor;

  Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.angle,
    required this.speedFactor,
  });
}

class _PS5ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final VoiceStatus status;
  final double glowIntensity;

  _PS5ParticlePainter({
    required this.particles,
    required this.status,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    
    final bgPaint = Paint()
      ..color = const Color(0xFF1E88E5).withOpacity(0.1 + (glowIntensity * 0.2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
    canvas.drawCircle(center, 72, bgPaint); 

    for (var p in particles) {
      final glowPaint = Paint()
        ..color = p.color.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 3);
      canvas.drawCircle(p.position, p.radius * 1.5, glowPaint);

      final corePaint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(p.position, p.radius, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PS5ParticlePainter oldDelegate) => true;
}
