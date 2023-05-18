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
