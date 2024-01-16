import 'dart:convert';
import 'dart:io';
import 'package:xmp/xmp.dart';

void main() {
  extractJpg();
  extractPng();
  extractApng();
  extractJpeg();
}

void extractJpeg() {
  var imageName = 'ive';
  var file = File('./example/assets/$imageName.jpeg');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$imageName.txt').writeAsBytesSync(bytes);
  try {
    var xmp = XMP.extract(bytes, raw: true);
    File('./example/result/new_$imageName.json')
        .writeAsStringSync(jsonEncode(xmp));
  } catch (e) {
    //print('should throw error: $e');
  }
  var result = XMP.extract(bytes, type: ImageType.jpeg);
  File('./example/result/new_${imageName}_extractor.json')
      .writeAsStringSync(jsonEncode(result));
}

void extractJpg() {
  var imageName = 'ive_2';
  var file = File('./example/assets/$imageName.jpg');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$imageName.txt').writeAsBytesSync(bytes);
  var xmp = XMP.extract(bytes, raw: true);
  File('./example/result/new_$imageName.json')
      .writeAsStringSync(jsonEncode(xmp));
  var result = XMP.extract(bytes);
  File('./example/result/new_${imageName}_extractor.json')
      .writeAsStringSync(jsonEncode(result));
}

void extractPng() {
  var imageName = 'iam';
  var file = File('./example/assets/$imageName.png');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$imageName.txt').writeAsBytesSync(bytes);
  var result = XMP.extract(bytes, type: ImageType.png);
  File('./example/result/new_${imageName}_extractor.json')
      .writeAsStringSync(jsonEncode(result));
}

void extractApng() {
  var imageName = 'circle_apng';
  var file = File('./example/assets/$imageName.png');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$imageName.txt').writeAsBytesSync(bytes);
  var result = XMP.extract(bytes, type: ImageType.apng);
  File('./example/result/new_${imageName}_extractor.json')
      .writeAsStringSync(jsonEncode(result));
}
