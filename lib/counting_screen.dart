import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class CountingScreen extends StatefulWidget {
  final int totalSeconds;

  const CountingScreen({super.key, required this.totalSeconds});

  @override
  State<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen> {
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasCompleted = false; // Flag to prevent multiple notifications

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() async {
    if (!_isRunning && _remainingSeconds > 0) {
      setState(() {
        _isRunning = true;
        _hasCompleted = false; // Reset the completion flag
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _stopTimer();
          }
        });

        // Check if timer has completed outside of setState
        if (_remainingSeconds == 0 && !_hasCompleted) {
          // Set the completion flag to prevent multiple triggers
          setState(() {
            _hasCompleted = true;
          });

          // Play sound and vibrate (these are async, so we handle them outside setState)
          _playCompletionSound();
          _vibrateOnCompletion();

          // Show snackbar notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Timer finished! Time to take a break!'),
              backgroundColor: Color(0xFF6C63FF),
              duration: Duration(seconds: 3),
            ),
          );

          // Wait a moment before navigating back
          Future.delayed(Duration(seconds: 3)).then((_) {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      });
    }
  }

  Future<void> _playCompletionSound() async {
    // For now, we'll use a simple approach using the audio player
    // In a real app, you would include actual sound files in your assets
    try {
      // Try to play a completion sound from assets (if available)
      await _audioPlayer.play(AssetSource('sounds/timer_complete.mp3'));
    } catch (e) {
      // If custom sound is not found, we'll skip sound for now
      // You can add sound files later to the sounds directory
      debugPrint(
        'Custom sound not found, skipping sound notification (you can add timer_complete.mp3 to the sounds folder)',
      );
    }
  }

  void _vibrateOnCompletion() {
    // Use a separate method to handle the async operations
    _performVibration();
  }

  Future<void> _performVibration() async {
    try {
      // Check if vibration is supported
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // Check if the device has amplitude control
        bool? hasAmplitude = await Vibration.hasAmplitudeControl();

        if (hasAmplitude == true) {
          // Vibrate with varying intensities for a more noticeable effect
          await Vibration.vibrate(duration: 500);
          await Future.delayed(Duration(milliseconds: 200));
          await Vibration.vibrate(duration: 500);
          await Future.delayed(Duration(milliseconds: 200));
          await Vibration.vibrate(duration: 1000);
        } else {
          // Simple vibration pattern
          await Vibration.vibrate(duration: 1000);
        }
      }
    } catch (e) {
      print('Vibration failed: $e');
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = widget.totalSeconds;
    });
  }

  String _formatTime(int seconds) {
    int hours = (seconds ~/ 3600).toInt();
    int minutes = ((seconds % 3600) ~/ 60).toInt();
    int secs = (seconds % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Modern dark background
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pomodoro Timer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFFFFF),
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Card(
                color: Color(0xFF1E1E1E), // Dark card background
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      CustomPaint(
                        painter: CircularTimerPainter(
                          progress: _remainingSeconds / widget.totalSeconds,
                          color: _getTimerColor(),
                          width: 8,
                        ),
                        child: Container(
                          width: 250,
                          height: 250,
                          child: Center(
                            child: Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Start/Stop Button
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: _isRunning
                                  ? Color(0xFFFF5252)
                                  : Color(
                                      0xFF4CAF50,
                                    ), // Red when running, green when stopped
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _isRunning
                                      ? Color(0xFFFF5252).withOpacity(0.3)
                                      : Color(0xFF4CAF50).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(35),
                                onTap: _isRunning ? _stopTimer : _startTimer,
                                child: Icon(
                                  _isRunning ? Icons.stop : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ),
                          ),
                          // Reset Button
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color(0xFF757575), // Grey
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF757575).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(35),
                                onTap: _resetTimer,
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          // Close Button
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color(0xFF6C63FF), // Purple
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6C63FF).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(35),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _isRunning
                              ? Color(0xFF4CAF50)
                              : Color(0xFFFF5252),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _isRunning ? 'Running...' : 'Paused',
                          style: TextStyle(
                            fontSize: 16,
                            color: _isRunning
                                ? Color(0xFF4CAF50)
                                : Color(0xFFFF5252),
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTimerColor() {
    // Calculate the progress percentage to change the color gradually
    double progress = 1.0 - (_remainingSeconds / widget.totalSeconds);

    // Define a gradient from purple to blue to teal as time decreases
    if (progress < 0.33) {
      // Purple to blue
      return Color.lerp(
        Color(0xFF6C63FF), // Purple
        Color(0xFF4A90E2), // Blue
        progress * 3,
      )!;
    } else if (progress < 0.66) {
      // Blue to teal
      return Color.lerp(
        Color(0xFF4A90E2), // Blue
        Color(0xFF00BFA6), // Teal
        (progress - 0.33) * 3,
      )!;
    } else {
      // Teal to red as time runs out
      return Color.lerp(
        Color(0xFF00BFA6), // Teal
        Color(0xFFFF5252), // Red
        (progress - 0.66) * 3,
      )!;
    }
  }
}

class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double width;

  CircularTimerPainter({
    required this.progress,
    required this.color,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color =
          Color(0xFF252525) // Dark background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round; // Rounded ends

    final startAngle = -pi / 2; // Start from top
    final sweepAngle = 2 * pi * progress; // Calculate sweep based on progress

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
