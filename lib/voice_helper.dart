import 'package:flutter/services.dart';

class VoiceHelper {
  static const MethodChannel _ch = MethodChannel('app.voice');

  /// returns recognized text, or null on error
  Future<String?> startListening() async {
    try {
      final res = await _ch.invokeMethod<String>('startListening');
      return res;
    } on PlatformException {
      return null;
    }
  }

  Future<void> stopListening() async {
    try {
      await _ch.invokeMethod('stopListening');
    } catch (_) {}
  }

  Future<void> speak(String text) async {
    try {
      await _ch.invokeMethod('speak', {'text': text});
    } catch (_) {}
  }

  Future<void> stopSpeak() async {
    try {
      await _ch.invokeMethod('stopSpeak');
    } catch (_) {}
  }
}
