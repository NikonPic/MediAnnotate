import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/points_info.dart';
import 'categories.dart';

Future<String?> get _localPath async {
  //final directory = await getApplicationDocumentsDirectory();
  final directory = await (getExternalStorageDirectory());
  return directory?.path;
}

Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName.txt');
}

Future<String> readContent(String fileName) async {
  try {
    final file = await _localFile(fileName);
    // Read the file
    String contents = await file.readAsString();
    // Returning the contents of the file
    return contents;
  } catch (e) {
    // If encountering an error, return
    return '';
  }
}

Future<File> writeContent(String fileName, String data) async {
  final file = await _localFile(fileName);
  // Write the file
  return file.writeAsString(data);
}

/// delete file and content
Future deleteContent(String fileName) async {
  final path = await _localPath;
  final dir = Directory('$path/$fileName.txt');
  try {
    dir.deleteSync(recursive: true);
  } on Exception catch (_) {
    print('File deletion not possible');
  }
}

/// atm only identity function
String formatFileName(String fileName, String name) {
  final List<String> fileNameList = fileName.split('/');
  return '${name}_${fileNameList[1]}_${fileNameList[2]}';
}

/// load the points from disk
Future<List<bool>> getModifiedInfo(String filePath, String username) async {
  List<bool> returnBool = [false, false, false];
  try {
    final String fileName = formatFileName(filePath, username);
    final String savedData = await readContent(fileName);
    final String pointsData = savedData.split('///')[0];
    final List<Offset?> pointsSaved = getPointsFromData(pointsData);
    if (pointsSaved.length > 2) {
      returnBool[0] = true;
    }
    if (savedData.split('///').length > 2) {
      if (classCategoryList[0] != savedData.split('///')[2]) {
        returnBool[1] = true;
      }
    }
    if (savedData.split('///').length > 3) {
      if (classCategoryList2[0] != savedData.split('///')[3]) {
        returnBool[2] = true;
      }
    }
  } on Exception catch (_) {}
  return returnBool;
}
