import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:xmp/xmp.dart';

class JpegMetaData extends MetaData {
  String? manufacturer;
  String? model;

  JpegMetaData();

  JpegMetaData._fromExif(Uint8List exifData) {
    _parseExif(exifData);
  }

  void _parseExif(Uint8List data) {
    const int TAG_MANUFACTURER = 0x010F;
    const int TAG_MODEL = 0x0110;

    ByteData byteData = ByteData.sublistView(data);
    int offset = 12; // 12 bytes offset as the TIFF header is fixed

    int tag = byteData.getUint16(offset, Endian.little);
    offset += 2;

    while (offset < data.length) {
      if (tag == TAG_MANUFACTURER) {
        int type = byteData.getUint16(offset + 2, Endian.little);
        int count = byteData.getUint32(offset + 4, Endian.little);
        int valueOffset = byteData.getUint32(offset + 8, Endian.little);

        if (type == 2 && count > 0) { // 2 = ASCII string
          manufacturer = String.fromCharCodes(data, valueOffset, valueOffset + count - 1);
        }
      } else if (tag == TAG_MODEL) {
        int type = byteData.getUint16(offset + 2, Endian.little);
        int count = byteData.getUint32(offset + 4, Endian.little);
        int valueOffset = byteData.getUint32(offset + 8, Endian.little);

        if (type == 2 && count > 0) { // 2 = ASCII string
          model = String.fromCharCodes(data, valueOffset, valueOffset + count - 1);
        }
      }

      offset += 12; // move to the next tag
      tag = byteData.getUint16(offset, Endian.little);
    }
  }

  JpegMetaData _extractMetadata(Uint8List bytes) {
    int cursor = 0;

    while (cursor < bytes.length - 1) {
      if (bytes[cursor] == 0xFF && bytes[cursor + 1] == 0xE1) {
        int length = bytes.buffer.asByteData().getUint16(cursor + 2, Endian.big);
        Uint8List exifData = bytes.sublist(cursor + 10, cursor + 10 + length - 2);
        return JpegMetaData._fromExif(exifData);
      }
      cursor++;
    }

    return JpegMetaData();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'manufacturer': manufacturer,
      'model': model,
    };
  }

  @override
  Map<String, dynamic> extract(Uint8List source, {bool raw = false, ImageType type = ImageType.jpeg}) {
    return _extractMetadata(source).toMap();
  }

  @override
  String toString() {
    return 'JpegMetaData(manufacturer: $manufacturer, model: $model)';
  }
}