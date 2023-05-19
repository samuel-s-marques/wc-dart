import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' show dirname;

int countBytes(String content) {
  final List<int> bytes = content.codeUnits;
  return bytes.length;
}

int countLines(String content) {
  return LineSplitter().convert(content).length;
}

int countChars(String content) {
  int charCount = 0;

  for (int index = 0; index < content.length; index++) {
    if (content[index] != '\n' && content[index] != '\r' && content[index] != '\t') {
      charCount++;
    }
  }

  return charCount;
}

int countWords(String content) {
  return RegExp(r'[\w-]+').allMatches(content).length;
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
