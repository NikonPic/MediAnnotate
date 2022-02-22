import 'dart:convert';
import 'package:flutter/services.dart';
import 'paths.dart';
import 'package:path_provider/path_provider.dart';

Future<List<String>> initImages({ext = true}) async {
  if (ext) {
    final imagePaths = await initNewImages();
    // sort the images
    imagePaths.sort((a, b) => a.toString().compareTo(b.toString()));

    return imagePaths;
  } else {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.png'))
        .toList();

    // sort the images
    imagePaths.sort((a, b) => a.toString().compareTo(b.toString()));

    return imagePaths;
  }
}

Future<List<String>> initNewImages() async {
  // >> To get paths you need these 2 lines
  final directory = await (getExternalStorageDirectory());
  List<String> imagePaths = [];
  await directory?.list(recursive: true, followLinks: false).listen((file) {
    if (file.path.endsWith('.png')) {
      imagePaths.add(file.path);
    }
  }).asFuture();
  return imagePaths;
}

Future<List<String>> initImagesModified(
    String username, int relevant, bool mode) async {
  // >> To get paths you need these 2 lines
  final List<String> imagePaths = await initImages();
  final Stream<String> infoStream =
      boolStreamModified(imagePaths, username, relevant);
  final List<String> sumStream =
      await sumStreamModified(infoStream, mode: mode);
  return sumStream;
}

Stream<String> boolStreamModified(
    List<String> imagePaths, String username, int relevant) async* {
  for (int i = 0; i < imagePaths.length; i++) {
    readContent(imagePaths[i]);
    List<bool> boolInfo = await getModifiedInfo(imagePaths[i], username);
    if (boolInfo[relevant]) {
      yield imagePaths[i];
    } else {
      yield '///$imagePaths[i]';
    }
  }
}

Future<List<String>> sumStreamModified(Stream<String> stream,
    {bool mode = false}) async {
  List<String> sum = [];
  await for (var value in stream) {
    sum.add(value);
  }
  return sum
      .where((String key) => (key.contains('///') == mode))
      .toList()
      .toString()
      .replaceAll('///', '')
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll(' ', '')
      .split(',')
      .toList();
}
