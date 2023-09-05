import 'dart:convert';
import 'dart:io';
import 'package:xmp/xmp.dart';

void main() {
  extractJpeg();
  extractJpg();
  extractPng();
  extractApng();
}

void extractJpeg() {
  var image_name = 'ive';
  var file = File('./example/assets/$image_name.jpeg');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$image_name.txt').writeAsBytesSync(bytes);
  var xmp = XMP.extract(bytes, raw: true);
  File('./example/result/new_$image_name.json').writeAsStringSync(jsonEncode(xmp));
  var result = XMP.extract(bytes, type: ImageType.jpeg);
  File('./example/result/new_${image_name}_extractor.json').writeAsStringSync(jsonEncode(result));
}

void extractJpg() {
  var image_name = 'ive_2';
  var file = File('./example/assets/$image_name.jpg');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$image_name.txt').writeAsBytesSync(bytes);
  var xmp = XMP.extract(bytes, raw: true);
  File('./example/result/new_$image_name.json').writeAsStringSync(jsonEncode(xmp));
  var result = XMP.extract(bytes);
  File('./example/result/new_${image_name}_extractor.json').writeAsStringSync(jsonEncode(result));
}

void extractPng() {
  var image_name = 'iam';
  var file = File('./example/assets/$image_name.png');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$image_name.txt').writeAsBytesSync(bytes);
  var result = XMP.extract(bytes, type: ImageType.png);
  File('./example/result/new_${image_name}_extractor.json').writeAsStringSync(jsonEncode(result));
}

void extractApng() {
  var image_name = 'circle_apng';
  var file = File('./example/assets/$image_name.png');
  var bytes = file.readAsBytesSync();
  File('./example/result/new_$image_name.txt').writeAsBytesSync(bytes);
  var result = XMP.extract(bytes, type: ImageType.apng);
  File('./example/result/new_${image_name}_extractor.json').writeAsStringSync(jsonEncode(result));
}