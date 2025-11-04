import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'counting_screen.dart'; // Import the counting screen

class SetTimerScreen extends StatefulWidget {
  const SetTimerScreen({super.key});

  @override
  State<SetTimerScreen> createState() => _SetTimerScreenState();
}

class _SetTimerScreenState extends State<SetTimerScreen> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

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
              'Set Your Timer',
              style: TextStyle(
                fontSize: 32,
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
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimePicker('HOURS', _hours, (value) {
                            setState(() {
                              _hours = value;
                            });
                          }),
                          _buildTimePicker('MINUTES', _minutes, (value) {
                            setState(() {
                              _minutes = value;
                            });
                          }),
                          _buildTimePicker('SECONDS', _seconds, (value) {
                            setState(() {
                              _seconds = value;
                            });
                          }),
                        ],
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C63FF), // Modern purple color
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            shadowColor: Color(0xFF6C63FF).withOpacity(0.4),
                            elevation: 5,
                          ),
                          onPressed: () {
                            // Start the timer
                            int totalSeconds =
                                _hours * 3600 + _minutes * 60 + _seconds;
                            if (totalSeconds > 0) {
                              // Navigate to counting screen with the set time
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CountingScreen(
                                    totalSeconds: totalSeconds,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please set a valid time'),
                                  backgroundColor: Color(0xFF6C63FF),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Start Timer',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
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

  Widget _buildTimePicker(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFB3B3B3), // Light grey text
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: Color(0xFF252525), // Darker container background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Color(0xFF3A3A3A), // Subtle border
              width: 1,
            ),
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value,
                isExpanded: true,
                padding: EdgeInsets.symmetric(horizontal: 12),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFFFFF), // White text
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                items: List.generate(
                  label == 'HOURS' ? 24 : 60,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(index.toString().padLeft(2, '0')),
                  ),
                ),
                onChanged: (newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
