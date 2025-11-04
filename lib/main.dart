import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/theme_provider.dart';
import 'set_timer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // This will automatically use light theme in light mode and dark theme in dark mode
      themeMode: ThemeMode.system,
      home: const TimerHomePage(),
    );
  }
}

// Separate your home screen to make it cleaner
class TimerHomePage extends StatelessWidget {
  const TimerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Column(
          mainAxisSize: MainAxisSize.max,

          children: [
            Image.asset('images/bg.png'),
            Text(
              textAlign: TextAlign.center,
              'Time is Money',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                letterSpacing: 15,
                fontFamily: GoogleFonts.inriaSans().fontFamily,
              ),
            ),

            SizedBox(height: 12),
            Text(
              'Never lose track of time',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                letterSpacing: 1.5,
                fontStyle: GoogleFonts.inter().fontStyle,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetTimerScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.inriaSans().fontFamily,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
