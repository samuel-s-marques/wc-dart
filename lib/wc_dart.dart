import 'dart:io';
import 'dart:typed_data';

Future<int> countBytes(File file) async {
  final Uint8List bytes = await file.readAsBytes();
  return bytes.length;
}

Future<int> countLines(File file) async {
  final List<String> lines = await file.readAsLines();
  return lines.length;
}

Future<int> countChars(File file) async {
  final String text = await file.readAsString();
  return text.length;
}

Future<int> countWords(File file) async {
  final String text = await file.readAsString();
  return RegExp(r'[\w-]+').allMatches(text).length;
}
