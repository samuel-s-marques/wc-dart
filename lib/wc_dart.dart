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
  return content.length;
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

String getHelp() {
  return '''
Usage: wc_dart [OPTION]... [FILE]...

Print newline, word, and byte counts for each FILE, and a total line if more than one FILE is specified. A word is a non-zero-length sequence of characteres delimited by white space.

The options below may be used to select which counts are printed, always in the following order: newline, word, character, byte.
    -c, --bytes ${' ' * 5} print the byte counts
    -m, --chars ${' ' * 5} print the character counts
    -l, --lines ${' ' * 5} print the newline counts
    -w, --words ${' ' * 5} print the word counts''';
}
