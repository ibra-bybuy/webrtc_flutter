import 'package:gallery_saver/gallery_saver.dart' as saver;

class GallerySaver {
  final String path;
  const GallerySaver(this.path);

  Future<bool?> saveImage() async {
    return saver.GallerySaver.saveImage(path);
  }

  Future<bool?> saveVideo() async {
    return saver.GallerySaver.saveVideo(path);
  }
}
