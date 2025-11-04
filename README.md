# Your Timer - Pomodoro Timer App

A beautiful, modern Pomodoro timer application with sound notifications and vibration alerts. This app helps users manage their time effectively with a visual countdown timer and customizable notifications.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [App Structure](#app-structure)
- [Code Explanation](#code-explanation)
- [Navigation](#navigation)
- [Dependencies](#dependencies)

## Features
- **Modern UI Design**: Dark theme with gradient colors and smooth animations
- **Visual Countdown**: Circular progress indicator that visually shows remaining time
- **Pomodoro Timer**: Set custom timer duration with hours, minutes, and seconds
- **Sound Notifications**: Plays audio when timer completes
- **Vibration Alerts**: Haptic feedback when timer finishes
- **Responsive Controls**: Start, stop, reset, and exit buttons
- **Dynamic Color Changes**: Timer circle changes color based on remaining time

## Installation

1. Clone or download this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

### Dependencies Installation

```bash
flutter pub get
```

## App Structure

```
lib/
├── main.dart        # App entry point
├── set_timer.dart   # Timer setup screen
├── counting_screen.dart # Timer countdown screen
```

## Code Explanation

### [main.dart](lib/main.dart)
The main entry point of the application that initializes the Flutter app and sets the home screen.

### [set_timer.dart](lib/set_timer.dart)
Contains the `SetTimerScreen` class where users can set their desired timer duration.

#### Key Components:
- **[SetTimerScreen](lib/set_timer.dart#L6-L194)**: Main widget for the timer setup screen
- **[_SetTimerScreenState](lib/set_timer.dart#L12-L193)**: State management for the timer setup screen
- **[_buildTimePicker](lib/set_timer.dart#L143-L192)**: Builds dropdown pickers for hours, minutes, and seconds

#### Key Methods:
- **[build](lib/set_timer.dart#L26-L105)**: Renders the UI for the timer setup screen
- **[onChanged callbacks](lib/set_timer.dart#L54-L74)**: Handle changes to timer values
- **[onPressed callback](lib/set_timer.dart#L82-L103)**: Handles the Start Timer button click, navigates to counting screen

### [counting_screen.dart](lib/counting_screen.dart)
Contains the `CountingScreen` class that displays the visual countdown timer with all notification features.

#### Key Components:
- **[CountingScreen](lib/counting_screen.dart#L13-L22)**: Main widget for the countdown timer screen
- **[_CountingScreenState](lib/counting_screen.dart#L24-L266)**: State management for the countdown screen
- **[CircularTimerPainter](lib/counting_screen.dart#L344-L396)**: Custom painter for the circular progress indicator

#### Key Methods:
- **[initState](lib/counting_screen.dart#L32-L35)**: Initializes the timer state
- **[dispose](lib/counting_screen.dart#L37-L40)**: Cleans up timer and audio player resources
- **[_startTimer](lib/counting_screen.dart#L42-L84)**: Starts the countdown timer
- **[_stopTimer](lib/counting_screen.dart#L98-L103)**: Stops the countdown timer
- **[_resetTimer](lib/counting_screen.dart#L105-L111)**: Resets the countdown timer
- **[_playCompletionSound](lib/counting_screen.dart#L86-L94)**: Plays sound when timer completes
- **[_performVibration](lib/counting_screen.dart#L113-L140)**: Performs vibration when timer completes
- **[_formatTime](lib/counting_screen.dart#L268-L273)**: Formats seconds into HH:MM:SS format
- **[build](lib/counting_screen.dart#L144-L266)**: Renders the UI for the countdown screen
- **[_getTimerColor](lib/counting_screen.dart#L276-L306)**: Returns color based on timer progress

#### Key Variables:
- **[_remainingSeconds](lib/counting_screen.dart#L26)**: Stores the remaining seconds for the timer
- **[_isRunning](lib/counting_screen.dart#L27)**: Boolean flag indicating if timer is running
- **[_timer](lib/counting_screen.dart#L28)**: Dart Timer object for countdown functionality
- **[_audioPlayer](lib/counting_screen.dart#L29)**: Audio player for completion sound
- **[_hasCompleted](lib/counting_screen.dart#L30)**: Flag to prevent multiple notifications

## Navigation

### Screen Flow
1. **Start Screen** → [SetTimerScreen](lib/set_timer.dart#L6-L194)
   - User sets desired timer duration
   - Taps "Start Timer" button to begin countdown

2. **Set Timer Screen** → [CountingScreen](lib/counting_screen.dart#L13-L22)
   - Timer starts counting down
   - Visual progress indicator shows remaining time
   - Dynamic color changes based on time left
   - Sound and vibration when timer completes

## Dependencies

This project uses the following dependencies:

- **[flutter](https://pub.dev/packages/flutter)**: Flutter SDK
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)**: Cupertino icons for Flutter
- **[google_fonts](https://pub.dev/packages/google_fonts)**: Google Fonts for Flutter
- **[audioplayers](https://pub.dev/packages/audioplayers)**: Audio player for sound notifications
- **[vibration](https://pub.dev/packages/vibration)**: Vibration API access for haptic feedback

## How the Pomodoro Timer Works

1. **Setup Phase**:
   - User opens the [SetTimerScreen](lib/set_timer.dart#L6-L194)
   - Selects desired time using dropdown pickers for hours, minutes, and seconds
   - Taps the "Start Timer" button to begin the countdown

2. **Countdown Phase**:
   - App navigates to [CountingScreen](lib/counting_screen.dart#L13-L22)
   - Timer begins counting down from the selected time
   - Circular progress indicator visually shows remaining time
   - Timer color changes as time progresses (purple → blue → teal → red)
   - User can pause, reset, or exit the timer

3. **Completion Phase**:
   - When timer reaches zero, [CountingScreen](lib/counting_screen.dart#L13-L22) triggers:
     - Plays completion sound using [audioplayers](https://pub.dev/packages/audioplayers)
     - Vibrates device using [vibration](https://pub.dev/packages/vibration) package
     - Shows completion snackbar notification
     - Automatically navigates back to timer setup after 3 seconds

## Key Features Explained

### Visual Countdown
The [CircularTimerPainter](lib/counting_screen.dart#L344-L396) class creates a circular progress indicator that visually represents the remaining time. The circle:
- Fills with colored progress as time passes
- Changes color based on remaining time (more time = purple, less time = red)
- Provides immediate visual feedback of time progression

### Sound and Vibration Notifications
When the timer completes:
- [\_playCompletionSound](lib/counting_screen.dart#L86-L94) plays a completion sound
- [\_performVibration](lib/counting_screen.dart#L113-L140) creates a multi-pulse vibration pattern
- Ensures user is notified even if not looking at the screen

### Dynamic Color System
The timer's color changes dynamically based on remaining time:
- [\_getTimerColor](lib/counting_screen.dart#L276-L306) calculates color based on progress
- Initially purple (abundant time remaining)
- Gradually shifts to red as time runs out
- Provides intuitive visual warning as time decreases

## UI/UX Design
- **Modern Dark Theme**: Uses dark backgrounds (#121212) for reduced eye strain
- **Gradient Colors**: Purple (#6C63FF) and accent colors for visual appeal
- **Responsive Design**: Adapts to different screen sizes
- **Intuitive Controls**: Large, clearly labeled buttons for easy interaction
- **Visual Feedback**: Status indicator and color changes for user awareness

## File Structure
```
lib/
├── main.dart                    # Application entry point
├── set_timer.dart              # Timer setup screen
│   ├── SetTimerScreen          # Main widget for timer setup
│   └── _SetTimerScreenState    # State management
├── counting_screen.dart        # Countdown timer screen  
│   ├── CountingScreen          # Main countdown widget
│   ├── _CountingScreenState    # State management
│   ├── _startTimer             # Timer start logic
│   ├── _stopTimer              # Timer stop logic
│   ├── _resetTimer             # Timer reset logic
│   ├── _playCompletionSound    # Sound notification
│   ├── _performVibration       # Vibration notification
│   ├── _formatTime             # Time formatting
│   ├── _getTimerColor          # Dynamic color logic
│   └── CircularTimerPainter    # Custom progress circle
```

## Contributing
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.