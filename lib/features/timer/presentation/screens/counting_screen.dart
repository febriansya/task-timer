import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../../../../core/utils/time_utils.dart';
import '../providers/timer_providers.dart';

// Enum to track timer state: idle, running, paused, completed
enum TimerState { idle, running, paused, completed }

class CountingScreen extends ConsumerStatefulWidget {
  final int totalSeconds;

  const CountingScreen({super.key, required this.totalSeconds});

  @override
  ConsumerState<CountingScreen> createState() => _CountingScreenState();
}

class _CountingScreenState extends ConsumerState<CountingScreen> {
  late int _remainingSeconds;
  TimerState _timerState = TimerState.idle; // Track the timer state
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasCompleted = false; // Flag to prevent multiple notifications

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.totalSeconds;
    print(
      'CountingScreen initState: widget.totalSeconds=${widget.totalSeconds}, _remainingSeconds=$_remainingSeconds, _timerState=$_timerState',
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() async {
    // Debug logging
    print(
      'Start Timer called. Current state: $_timerState, Remaining seconds: $_remainingSeconds, Total seconds (widget): ${widget.totalSeconds}',
    );

    // Only allow starting if not already running
    // For initial start: _timerState should be idle and _remainingSeconds should be widget.totalSeconds (> 0)
    // For resume after pause: _timerState should be paused
    if (_timerState != TimerState.running) {
      // If _remainingSeconds is 0 or less, don't start the timer
      if (_remainingSeconds <= 0) {
        print('Cannot start timer: _remainingSeconds is $_remainingSeconds');
        // If timer has no time left, show a message to the user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Timer has no time set. Please set a valid duration.',
              ),
              backgroundColor: Color(0xFFFF9800),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return; // Exit without starting timer
      }

      print('Starting timer with $_remainingSeconds seconds');
      print('Calling setState to update timer state to running');
      setState(() {
        _timerState = TimerState.running;
        _hasCompleted = false; // Reset the completion flag
        print('State updated in setState: $_timerState');
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            // Timer has completed, cancel timer and set state
            timer.cancel(); // Cancel this specific timer instance
            _timer = null; // Clear the reference
          }
        });

        // Check if timer has completed outside of setState
        if (_remainingSeconds == 0 && !_hasCompleted) {
          // Set the completion flag to prevent multiple triggers
          setState(() {
            _hasCompleted = true;
            _timerState = TimerState.completed;
          });

          // Play sound and vibrate (these are async, so we handle them outside setState)
          _playCompletionSound();
          _vibrateOnCompletion();

          // Use the use case to save the completed timer
          _saveCompletedTimer();

          // Show snackbar notification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
    } else {
      print(
        'Cannot start timer: already running (_timerState is $_timerState)',
      );
    }
  }

  Future<void> _playCompletionSound() async {
    print('Attempting to play completion sound...');
    
    // Reset audio player and prepare for playback
    try {
      // Stop any existing playback first
      await _audioPlayer.stop();
      
      // Set the audio context to ensure it works on all devices
      await _audioPlayer.setReleaseMode(ReleaseMode.stop); // Ensure proper release
      await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer); // Use more compatible mode
      await _audioPlayer.setVolume(1.0); // Set maximum volume
      
      // Attempt to play the completion sound
      await _audioPlayer.play(
        AssetSource('sounds/completed_sound.mp3'),
        volume: 1.0, // Set volume explicitly
      );
      
      print('Audio playback started successfully');
    } catch (e) {
      print('Audio playback failed with mediaPlayer: $e');
      
      // Alternative approach if first attempt fails
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
        await _audioPlayer.setVolume(1.0);
        
        await _audioPlayer.play(
          AssetSource('sounds/completed_sound.mp3'),
          volume: 1.0,
        );
        
        print('Audio playback with low latency mode successful');
      } catch (secondError) {
        print('Audio playback failed with lowLatency: $secondError');
        
        // Ultimate fallback method
        try {
          // Try using audio session to ensure proper audio routing
          await _audioPlayer.stop();
          await _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
          await _audioPlayer.setVolume(1.0);
          
          // Prepare to play and wait a bit before playing
          final player = AudioPlayer();
          await player.setPlayerMode(PlayerMode.mediaPlayer);
          await player.setVolume(1.0);
          await player.play(
            AssetSource('sounds/completed_sound.mp3'),
            volume: 1.0,
          );
          
          // Dispose of the temporary player after a delay
          Future.delayed(Duration(seconds: 2), () => player.dispose());
          
          print('Audio playback with temporary player successful');
        } catch (thirdError) {
          print('All audio playback methods failed: $thirdError');
          
          // Jika semua metode gagal, setidaknya beri tahu pengguna
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Timer completed! (Sound may be disabled)'),
                backgroundColor: Color(0xFF6C63FF),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    }
  }

  void _saveCompletedTimer() async {
    // In a real implementation, we would use the use case to save the timer
    // For now, we'll just log it
    final startTimerUseCase = ref.read(startTimerUseCaseProvider);
    try {
      await startTimerUseCase.execute(
        name: 'Timer ${DateTime.now()}',
        totalSeconds: widget.totalSeconds,
        type: 'countdown',
      );
    } catch (e) {
      debugPrint('Error saving timer: $e');
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
    if (_timerState == TimerState.running) {
      setState(() {
        _timerState = TimerState.paused;
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timerState = TimerState.idle;
      _remainingSeconds = widget.totalSeconds;
    });
  }

  String _formatTime(int seconds) {
    return TimeUtils.formatTime(seconds);
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
                              color: _getButtonColor(),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getButtonColor(),
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
                                  print(
                                    'Button tapped! Current state: $_timerState',
                                  );
                                  final action = _getButtonAction();
                                  if (action != null) {
                                    action();
                                  } else {
                                    print(
                                      'No action returned from _getButtonAction',
                                    );
                                  }
                                },
                                child: Icon(
                                  _getButtonIcon(),
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
                              color: _timerState == TimerState.completed
                                  ? Color(0xFF6C63FF) // Purple when completed
                                  : Color(0xFF757575), // Grey otherwise
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (_timerState == TimerState.completed
                                              ? Color(0xFF6C63FF)
                                              : Color(0xFF757575))
                                          .withOpacity(0.3),
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
                                  _timerState == TimerState.completed
                                      ? Icons
                                            .replay // Replay icon when completed
                                      : Icons.refresh, // Refresh icon otherwise
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
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 248, 248, 248),
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

  Color _getStatusColor() {
    switch (_timerState) {
      case TimerState.idle:
        return Color(0xFF757575); // Gray for idle
      case TimerState.running:
        return Color(0xFF4CAF50); // Green for running
      case TimerState.paused:
        return Color(0xFFFF9800); // Orange for paused
      case TimerState.completed:
        return Color(0xFF6C63FF); // Purple for completed
    }
  }

  Color _getButtonColor() {
    switch (_timerState) {
      case TimerState.idle:
      case TimerState.paused:
        return Color(0xFF4CAF50); // Green for start/resume
      case TimerState.running:
        return Color(0xFFFF5252); // Red for stop
      case TimerState.completed:
        return Color(0xFF6C63FF); // Purple for completed
    }
    return Color(0xFF4CAF50); // Default fallback
  }

  IconData _getButtonIcon() {
    switch (_timerState) {
      case TimerState.idle:
      case TimerState.paused:
        return Icons.play_arrow; // Play icon to start or resume
      case TimerState.running:
        return Icons.stop; // Stop icon when running
      case TimerState.completed:
        return Icons.replay; // Replay icon when completed
    }
    return Icons.play_arrow; // Default fallback
  }

  void Function()? _getButtonAction() {
    switch (_timerState) {
      case TimerState.idle:
        print('Button action: returning _startTimer for idle state');
        return _startTimer; // Start timer
      case TimerState.paused:
        print('Button action: returning _startTimer for paused state');
        return _startTimer; // Resume timer
      case TimerState.running:
        print('Button action: returning _stopTimer for running state');
        return _stopTimer; // Pause timer
      case TimerState.completed:
        print('Button action: returning _resetTimer for completed state');
        return _resetTimer; // Reset timer
    }
    print('Button action: returning fallback _startTimer');
    return _startTimer; // Default fallback
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
