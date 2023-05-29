import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:wc_dart/wc_dart.dart' as wc_dart;

void main(List<String> arguments) async {
  final ArgParser parser = ArgParser();

  parser.addFlag('bytes', abbr: 'c', help: 'Print the count of bytes');
  parser.addFlag('lines', abbr: 'l', help: 'Print the count of newlines');
  parser.addFlag('words', abbr: 'w', help: 'Print the count of words');
  parser.addFlag('chars', abbr: 'm', help: 'Print the count of characters');
  parser.addFlag('version', abbr: 'v', negatable: false, help: 'Print the current version of wc-dart');
  parser.addFlag('help', abbr: 'h', negatable: false, help: 'Print the options of wc-dart');

  ArgResults argResults = parser.parse(arguments);
  final List<String> flagNames = ['bytes', 'lines', 'chars', 'words'];
  final bool allCommands = !flagNames.any(argResults.wasParsed);
  Stream<List<int>> input = stdin;
  Utf8Decoder decoder = utf8.decoder;
  String dataString = '';

  if (argResults.wasParsed('version')) {
    stdout.writeln(await wc_dart.getVersion());
  } else if (argResults.wasParsed('help')) {
    stdout.writeln('''
Usage: wc_dart [OPTION]... [FILE]...

Print newline, word, and byte counts for each FILE, and a total line if more than one FILE is specified. A word is a non-zero-length sequence of characteres delimited by white space.
The options below may be used to select which counts are printed, always in the following order: newline, word, character, byte.''');
    stdout.write(parser.usage);
  } else {
    final List<String> paths = argResults.rest;

    if (!stdin.hasTerminal) {
      dataString = await input.transform(decoder).join();

      await wc(
        dataString,
        countBytes: true,
        countLines: true,
        countChars: true,
        countWords: true,
      );

      exit(0);
    }

    if (paths.isEmpty) {
      stderr.writeln('Error: no file found.');
      exitCode = 2;
    }

    try {
      for (int index = 0; index < paths.length; index++) {
        final File file = File(paths[index]);
        final String content = await file.readAsString();

        await wc(
          content,
          countBytes: allCommands || argResults.wasParsed('bytes'),
          countLines: allCommands || argResults.wasParsed('lines'),
          countChars: allCommands || argResults.wasParsed('chars'),
          countWords: allCommands || argResults.wasParsed('words'),
        );

        stdout.writeln(wc_dart.padRight(file.path));
      }
      exit(0);
    } catch (e) {
      stderr.writeln('Error: $e');
      exitCode = 2;
    }
  }
}

Future<void> wc(
  String content, {
  bool countBytes = false,
  bool countLines = false,
  bool countWords = false,
  bool countChars = false,
}) async {
  if (countLines) {
    final int lines = wc_dart.countLines(content);
    stdout.write(wc_dart.padRight(lines.toString()));
  }

  if (countWords) {
    final int words = wc_dart.countWords(content);
    stdout.write(wc_dart.padRight(words.toString()));
  }

  if (countChars) {
    final int chars = wc_dart.countChars(content);
    stdout.write(wc_dart.padRight(chars.toString()));
  }

  if (countBytes) {
    final int bytes = wc_dart.countBytes(content);
    stdout.write(wc_dart.padRight(bytes.toString()));
  }
}
