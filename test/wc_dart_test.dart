import 'package:test_process/test_process.dart';
import 'package:test/test.dart';

void main() {
  group('wc-tool', () {
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
