import 'dart:io';

Future<List<File>> scanFilesWithExtensions({
  required Directory directory,
  required List<String> extensions,
}) async {
  List<File> matchedFiles = [];

  try {
    await for (var entity in directory.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        String extension = entity.path.split('.').last.toLowerCase();
        if (extensions.contains(extension)) {
          matchedFiles.add(entity);
        }
      }
    }
  } catch (e) {
    print('Error scanning directory: $e');
  }

  return matchedFiles;
}