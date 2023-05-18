import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' show dirname, join;

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

String padRight(String value) {
  return '$value ';
}

Future<String> getVersion() async {
  String version = '';
  List<String> dirList = dirname(Platform.script.path).split('/');
  dirList.removeAt(0);
  dirList.removeLast();

  String fixedDir = dirList.join('/').replaceAllMapped(RegExp(r'%20'), (_) => ' ');

  final File pubFile = File('$fixedDir/pubspec.yaml');
  final String text = await pubFile.readAsString();

  return RegExp(r'version:.+').firstMatch(text)?.group(0) ?? version;
}
