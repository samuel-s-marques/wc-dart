import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' show dirname;

int countBytes(String content) {
  List<int> bytes = utf8.encode(content);
  return bytes.length;
}

int countLines(String content) {
  return '\n'.allMatches(content).length;
}

int countChars(String content) {
  return content.length;
}

int countWords(String content) {
  int count = 0;
  bool isWord = false;

  for (int index = 0; index < content.length; index++) {
    if (content[index].trim().isEmpty) {
      isWord = false;
    } else if (!isWord) {
      count++;
      isWord = true;
    }
  }

  return count;
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
