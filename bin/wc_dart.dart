import 'dart:io';

import 'package:args/args.dart';
import 'package:wc_dart/wc_dart.dart' as wc_dart;

void main(List<String> arguments) async {
  final ArgParser parser = ArgParser();

  parser.addFlag('bytes', abbr: 'c');
  parser.addFlag('lines', abbr: 'l');
  parser.addFlag('words', abbr: 'w');
  parser.addFlag('chars', abbr: 'm');

  ArgResults argResults = parser.parse(arguments);

  final List<String> paths = argResults.rest;
  final bool allCommands = !argResults.wasParsed('bytes') && !argResults.wasParsed('lines') && !argResults.wasParsed('chars') && !argResults.wasParsed('words');

  await wc(
    paths,
    countBytes: allCommands ? true : argResults.wasParsed('bytes'),
    countLines: allCommands ? true : argResults.wasParsed('lines'),
    countChars: allCommands ? true : argResults.wasParsed('chars'),
    countWords: allCommands ? true : argResults.wasParsed('words'),
  );
}

String padRight(String value) {
  return '$value ';
}

Future<void> wc(
  List<String> paths, {
  bool countBytes = false,
  bool countLines = false,
  bool countWords = false,
  bool countChars = false,
}) async {
  if (paths.isEmpty) {
    stderr.writeln('Error: no file found.');
  } else {
    for (int index = 0; index < paths.length; index++) {
      final File file = File(paths[index]);

      if (countBytes) {
        final int bytes = await wc_dart.countBytes(file);
        stdout.write(padRight(bytes.toString()));
      }

      if (countLines) {
        final int lines = await wc_dart.countLines(file);
        stdout.write(padRight(lines.toString()));
      }

      if (countWords) {
        final int words = await wc_dart.countWords(file);
        stdout.write(padRight(words.toString()));
      }

      if (countChars) {
        final int chars = await wc_dart.countChars(file);
        stdout.write(padRight(chars.toString()));
      }

      stdout.write(padRight(file.path));
    }
  }
}
