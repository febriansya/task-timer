import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

/// Service untuk mengelola pemutaran audio di aplikasi
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// Memutar file audio dari assets
  Future<void> playAsset(String assetPath) async {
    try {
      // Stop playback if running
      await _player.stop();
      
      // Load the asset file using Flutter's asset mechanism
      await _player.setAsset(assetPath);
      
      // Play the audio
      await _player.play();
    } catch (e) {
      print('Error playing audio asset $assetPath: $e');
      
      // The MissingPluginException suggests the platform channel isn't properly initialized
      // which can happen on some devices or after hot restart
      // Let's try to recreate the player instance
      try {
        await _player.dispose();
        // Create a new player instance
        final newPlayer = AudioPlayer();
        await newPlayer.setAsset(assetPath);
        await newPlayer.play();
        // Don't dispose this player immediately as it's playing
        // We'll dispose it later or let it finish naturally
      } catch (recreateError) {
        print('Recreating player also failed: $recreateError');
        
        // Final fallback - try with hardcoded path
        try {
          await _player.dispose();
          final fallbackPlayer = AudioPlayer();
          await fallbackPlayer.setAsset('assets/audio/completed_sound.mp3');
          await fallbackPlayer.play();
        } catch (fallbackError) {
          print('Fallback also failed: $fallbackError');
          // Could not play audio
        }
      }
    }
  }

  /// Memutar file audio dari URL
  Future<void> playUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('Error playing audio from URL: $e');
    }
  }

  /// Menghentikan pemutaran audio
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  /// Menjeda pemutaran audio
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  /// Melanjutkan pemutaran audio
  Future<void> resume() async {
    try {
      await _player.play(); // just_audio doesn't have a separate resume method
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  /// Mengatur volume pemutaran (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  /// Membongkar resource audio player
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }
}