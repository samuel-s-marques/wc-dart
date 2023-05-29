import 'package:test_process/test_process.dart';
import 'package:test/test.dart';

void main() {
  group('wc-tool with a single file', () {
    test('should count lines correctly', () async {
      final int expectedLines = 2;

      TestProcess process = await TestProcess.start('dart', ['run', 'bin/wc_dart.dart', '-l', 'test/test1.txt']);
      expectLater(await process.stdout.next, equals('$expectedLines test/test1.txt '));
      await process.shouldExit(0);
    });

    test('should count words correctly', () async {
      final int expectedWords = 7;

      TestProcess process = await TestProcess.start('dart', ['run', 'bin/wc_dart.dart', '-w', 'test/test1.txt']);
      expectLater(await process.stdout.next, equals('$expectedWords test/test1.txt '));
      await process.shouldExit(0);
    });

    test('should count chars correctly', () async {
      final int expectedChars = 35;

      TestProcess process = await TestProcess.start('dart', ['run', 'bin/wc_dart.dart', '-m', 'test/test1.txt']);
      expectLater(await process.stdout.next, equals('$expectedChars test/test1.txt '));
      await process.shouldExit(0);
    });

    test('should count bytes correctly', () async {
      final int expectedBytes = 37;

      TestProcess process = await TestProcess.start('dart', ['run', 'bin/wc_dart.dart', '-c', 'test/test1.txt']);
      expectLater(await process.stdout.next, equals('$expectedBytes test/test1.txt '));
      await process.shouldExit(0);
    });

    test('should count lines, words, chars and bytes correctly', () async {
      final int expectedLines = 2;
      final int expectedWords = 7;
      final int expectedChars = 35;
      final int expectedBytes = 37;

      TestProcess process = await TestProcess.start('dart', ['run', 'bin/wc_dart.dart', 'test/test1.txt']);
      expectLater(await process.stdout.next, equals('$expectedLines $expectedWords $expectedChars $expectedBytes test/test1.txt '));
      await process.shouldExit(0);
    });
  });
}
