import 'dart:convert';
import 'dart:io';
import 'package:xmp/xmp.dart';

const path = '/Users/kawal/Desktop/xmp';

void main() {
  var image_name = '7285';
  var file = File('$path/test_data/$image_name.jpg');
  var bytes = file.readAsBytesSync();
/**
 * var raw_xmp = XMP.extract(bytes, raw: true);
 */
  var xmp = XMP.extract(bytes);
  File('$path/output_result/$image_name.json')
      .writeAsStringSync(jsonEncode(xmp));
}
