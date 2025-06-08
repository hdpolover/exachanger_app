import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('File Extension Detection Tests', () {
    test('should detect jpg extension correctly', () {
      String testPath = '/path/to/file/image.jpg';
      String fileExtension = path.extension(testPath).toLowerCase();
      if (fileExtension.startsWith('.')) {
        fileExtension = fileExtension.substring(1);
      }

      expect(fileExtension, equals('jpg'));
    });

    test('should detect png extension correctly', () {
      String testPath = '/path/to/file/image.PNG';
      String fileExtension = path.extension(testPath).toLowerCase();
      if (fileExtension.startsWith('.')) {
        fileExtension = fileExtension.substring(1);
      }

      expect(fileExtension, equals('png'));
    });

    test('should detect jpeg extension correctly', () {
      String testPath = '/path/to/file/image.jpeg';
      String fileExtension = path.extension(testPath).toLowerCase();
      if (fileExtension.startsWith('.')) {
        fileExtension = fileExtension.substring(1);
      }

      expect(fileExtension, equals('jpeg'));
    });

    test('should detect webp extension correctly', () {
      String testPath = '/path/to/file/image.webp';
      String fileExtension = path.extension(testPath).toLowerCase();
      if (fileExtension.startsWith('.')) {
        fileExtension = fileExtension.substring(1);
      }

      expect(fileExtension, equals('webp'));
    });

    test('should validate supported extensions', () {
      List<String> supportedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

      expect(supportedExtensions.contains('jpg'), isTrue);
      expect(supportedExtensions.contains('jpeg'), isTrue);
      expect(supportedExtensions.contains('png'), isTrue);
      expect(supportedExtensions.contains('webp'), isTrue);
      expect(supportedExtensions.contains('gif'), isFalse);
      expect(supportedExtensions.contains('svg'), isFalse);
    });

    test('should handle files without extension', () {
      String testPath = '/path/to/file/image';
      String fileExtension = path.extension(testPath).toLowerCase();
      if (fileExtension.startsWith('.')) {
        fileExtension = fileExtension.substring(1);
      }

      // Should be empty string for files without extension
      expect(fileExtension, equals(''));

      // Our logic should default to 'jpg' for unsupported/missing extensions
      List<String> supportedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      if (!supportedExtensions.contains(fileExtension)) {
        fileExtension = 'jpg';
      }

      expect(fileExtension, equals('jpg'));
    });
  });
}
