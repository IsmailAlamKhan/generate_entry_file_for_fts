import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as p;

void main() => generateEntryFile();

Future<void> generateEntryFile() async {
  final path = ask('Please provide the path to your Entry file');
  _generateEntryFile(path);
}

void _generateEntryFile(String entryPath) {
  if (p.extension(entryPath) != '.yaml') {
    print(red(("Couldn't find the entry_file")));
    return;
  }
  final entryFileName = p.basenameWithoutExtension(entryPath);
  final entryDir = Directory(p.dirname(entryPath));
  final entryFile = File(entryPath);
  var entryFileData = '';
  for (var item in entryDir.listSync(recursive: true)) {
    final name = p.basenameWithoutExtension(item.path);
    if (name != entryFileName &&
        !entryFileData.contains(name) &&
        p.extension(item.path) == '.yaml') {
      if (item is Directory) {
        entryFileData += '$name:\n \$ref: $name/$name.yaml\n';
      } else {
        entryFileData += '$name:\n \$ref: $name.yaml\n';
      }
    }
  }
  if (!entryFile.existsSync()) {
    entryFile.createSync(recursive: true);
  }
  entryFile.writeAsStringSync(entryFileData);
  print('Generated file');
}
