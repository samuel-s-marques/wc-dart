import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:wc_dart/wc_dart.dart' as wc_dart;

void main(List<String> arguments) async {
  final ArgParser parser = ArgParser();

  parser.addFlag('bytes', abbr: 'c');
  parser.addFlag('lines', abbr: 'l');
  parser.addFlag('words', abbr: 'w');
  parser.addFlag('chars', abbr: 'm');
  parser.addFlag('version', abbr: 'v');
  parser.addFlag('help', abbr: 'h');

  ArgResults argResults = parser.parse(arguments);
  final List<String> flagNames = ['bytes', 'lines', 'chars', 'words'];
  Stream<List<int>> input = stdin;
  Utf8Decoder decoder = utf8.decoder;
  String dataString = '';
  final bool allCommands = !flagNames.any(argResults.wasParsed);

  if (argResults.wasParsed('version')) {
    stdout.writeln(await wc_dart.getVersion());
  } else if (argResults.wasParsed('help')) {
    stdout.write(wc_dart.getHelp());
  } else {
    final List<String> paths = argResults.rest;

    if (paths.isEmpty && stdin.hasTerminal) {
      stderr.writeln('Error: no file found.');
      exitCode = 2;
    }

    if (!stdin.hasTerminal) {
      input.transform(decoder).listen((String data) {
        dataString += data;
      }, onDone: () {
        wc(
          dataString,
          countBytes: allCommands || argResults.wasParsed('bytes'),
          countLines: allCommands || argResults.wasParsed('lines'),
          countChars: allCommands || argResults.wasParsed('chars'),
          countWords: allCommands || argResults.wasParsed('words'),
        );
      });
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
    } catch (e) {
      stderr.writeln('Error: $e');
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
