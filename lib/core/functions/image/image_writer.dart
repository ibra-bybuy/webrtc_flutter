import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ImageWriter {
  final Uint8List bytes;
  final String name;
  const ImageWriter(this.bytes, {this.name = "image.png"});

  Future<File> call() async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$name').create();
    file.writeAsBytesSync(bytes);
    return file;
  }
}
