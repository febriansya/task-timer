import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../../../shared/services/audio_service.dart';
import '../../../../core/utils/time_utils.dart';
import '../providers/timer_providers.dart';

/// Enum to track timer state: idle, running, paused, completed
enum TimerState { idle, running, paused, completed }

/// A screen that displays a countdown timer with visual progress indicator
class CountingScreen extends ConsumerStatefulWidget {
  final int totalSeconds;

  const CountingScreen({super.key, required this.totalSeconds});

  @override
  ConsumerState<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends ConsumerState<CountingScreen> {
  // State properties
  late int _remainingSeconds;
  TimerState _timerState = TimerState.idle;
  Timer? _timer;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Timer Logic Methods
  // -------------------------------------------------------------------------

  /// Starts or resumes the timer
  void _startTimer() {
    // Validate if timer can be started
    if (_timerState == TimerState.running || _remainingSeconds <= 0) {
      _showInvalidTimerMessage();
      return;
    }

    // Update state and start timer
    setState(() {
      _timerState = TimerState.running;
      _hasCompleted = false;
    });

    // Create periodic timer that executes every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimerState();
    });
  }

  /// Updates the timer's remaining seconds and checks for completion
  void _updateTimerState() {
    setState(() {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        _timer?.cancel();
        _timer = null;
      }
    });

    // Handle timer completion
    if (_remainingSeconds == 0 && !_hasCompleted) {
      _handleTimerCompletion();
    }
  }

  /// Handles actions when timer completes
  void _handleTimerCompletion() {
    setState(() {
      _hasCompleted = true;
      _timerState = TimerState.completed;
    });

    // Execute completion actions
    _playCompletionSound();
    _vibrateOnCompletion();
    _saveCompletedTimer();
    _showCompletionNotification();
    
    // Navigate back after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  /// Stops the currently running timer
  void _stopTimer() {
    _timer?.cancel();
    if (_timerState == TimerState.running) {
      setState(() {
        _timerState = TimerState.paused;
      });
    }
  }

  /// Resets the timer to initial state
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timerState = TimerState.idle;
      _remainingSeconds = widget.totalSeconds;
    });
  }

  /// Saves completed timer using use case
  void _saveCompletedTimer() async {
    try {
      final startTimerUseCase = ref.read(startTimerUseCaseProvider);
      await startTimerUseCase.execute(
        name: 'Timer ${DateTime.now()}',
        totalSeconds: widget.totalSeconds,
        type: 'countdown',
      );
    } catch (e) {
      debugPrint('Error saving timer: $e');
      // Jangan menampilkan error ke pengguna karena ini bukan prioritas utama
      // Timer tetap selesai meskipun penyimpanan gagal
    }
  }

  // -------------------------------------------------------------------------
  // UI Helper Methods
  // -------------------------------------------------------------------------

  /// Shows an error message when timer cannot be started
  void _showInvalidTimerMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer has no time set. Please set a valid duration.'),
          backgroundColor: Color(0xFFFF9800),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Shows completion notification
  void _showCompletionNotification() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer finished! Time to take a break!'),
          backgroundColor: Color(0xFF6C63FF),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Plays completion sound using AudioService
  void _playCompletionSound() {
    try {
      final audioService = AudioService();
      audioService.playAsset('assets/audio/completed_sound.mp3');
    } catch (e) {
      debugPrint('Audio playback failed: $e');
      // Fallback: show notification if audio doesn't play
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timer completed! (Audio may be disabled)'),
            backgroundColor: Color(0xFF6C63FF),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handles vibration feedback on timer completion
  void _vibrateOnCompletion() async {
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        bool? hasAmplitude = await Vibration.hasAmplitudeControl();
        
        if (hasAmplitude == true) {
          // Complex vibration pattern for better feedback
          await Vibration.vibrate(duration: 500);
          await Future.delayed(const Duration(milliseconds: 200));
          await Vibration.vibrate(duration: 500);
          await Future.delayed(const Duration(milliseconds: 200));
          await Vibration.vibrate(duration: 1000);
        } else {
          // Simple vibration
          await Vibration.vibrate(duration: 1000);
        }
      }
    } catch (e) {
      debugPrint('Vibration failed: $e');
    }
  }

  /// Formats time to display format (HH:MM:SS)
  String _formatTime(int seconds) {
    return TimeUtils.formatTime(seconds);
  }

  /// Gets appropriate action for the main control button based on timer state
  void Function()? _getButtonAction() {
    switch (_timerState) {
      case TimerState.idle:
      case TimerState.paused:
        return _startTimer;
      case TimerState.running:
        return _stopTimer;
      case TimerState.completed:
        return _resetTimer;
    }
  }

  /// Gets appropriate icon for the main control button
  IconData _getButtonIcon() {
    switch (_timerState) {
      case TimerState.idle:
      case TimerState.paused:
        return Icons.play_arrow;
      case TimerState.running:
        return Icons.stop;
      case TimerState.completed:
        return Icons.replay;
    }
  }

  /// Gets appropriate color for the main control button
  Color _getButtonColor() {
    switch (_timerState) {
      case TimerState.idle:
      case TimerState.paused:
        return const Color(0xFF4CAF50); // Green for start/resume
      case TimerState.running:
        return const Color(0xFFFF5252); // Red for stop
      case TimerState.completed:
        return const Color(0xFF6C63FF); // Purple for completed
    }
  }

  /// Gets status text based on timer state
  String _getStatusText() {
    switch (_timerState) {
      case TimerState.idle:
        return 'Not Started';
      case TimerState.running:
        return 'Running...';
      case TimerState.paused:
        return 'Paused';
      case TimerState.completed:
        return 'Finished';
    }
  }

  /// Gets status color based on timer state
  Color _getStatusColor() {
    switch (_timerState) {
      case TimerState.idle:
        return const Color(0xFF757575); // Gray for idle
      case TimerState.running:
        return const Color(0xFF4CAF50); // Green for running
      case TimerState.paused:
        return const Color(0xFFFF9800); // Orange for paused
      case TimerState.completed:
        return const Color(0xFF6C63FF); // Purple for completed
    }
  }

  /// Gets color for the circular timer progress based on remaining time
  Color _getTimerColor() {
    double progress = 1.0 - (_remainingSeconds / widget.totalSeconds);

    if (progress < 0.33) {
      // Purple to blue
      return Color.lerp(
        const Color(0xFF6C63FF), // Purple
        const Color(0xFF4A90E2), // Blue
        progress * 3,
      )!;
    } else if (progress < 0.66) {
      // Blue to teal
      return Color.lerp(
        const Color(0xFF4A90E2), // Blue
        const Color(0xFF00BFA6), // Teal
        (progress - 0.33) * 3,
      )!;
    } else {
      // Teal to red as time runs out
      return Color.lerp(
        const Color(0xFF00BFA6), // Teal
        const Color(0xFFFF5252), // Red
        (progress - 0.66) * 3,
      )!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'Pomodoro Timer',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFFFFFF),
                fontFamily: GoogleFonts.poppins().fontFamily,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 40),
            
            // Timer Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Card(
                color: const Color(0xFF1E1E1E), // Dark card background
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      // Circular Timer
                      CustomPaint(
                        painter: CircularTimerPainter(
                          progress: _remainingSeconds / widget.totalSeconds,
                          color: _getTimerColor(),
                          width: 8,
                        ),
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Center(
                            child: Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFFFFF),
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Start/Pause Button
                          _buildControlButton(
                            color: _getButtonColor(),
                            icon: _getButtonIcon(),
                            onTap: () {
                              final action = _getButtonAction();
                              action?.call();
                            },
                          ),
                          
                          // Reset Button
                          _buildControlButton(
                            color: _timerState == TimerState.completed
                                ? const Color(0xFF6C63FF) // Purple when completed
                                : const Color(0xFF757575), // Grey otherwise
                            icon: _timerState == TimerState.completed
                                ? Icons.replay // Replay icon when completed
                                : Icons.refresh, // Refresh icon otherwise
                            onTap: _resetTimer,
                          ),
                          
                          // Close Button
                          _buildControlButton(
                            color: const Color(0xFF6C63FF), // Purple
                            icon: Icons.close,
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Status Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 248, 248, 248),
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

  /// Helper widget for building control buttons
  Widget _buildControlButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(35),
          onTap: onTap,
          child: Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for circular timer progress
class CircularTimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double width;

  const CircularTimerPainter({
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
      ..color = const Color(0xFF252525) // Dark background color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round; // Rounded ends

    const startAngle = -pi / 2; // Start from top
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
