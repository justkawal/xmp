import 'dart:typed_data';

import 'package:xmp/xmp.dart';

class PngTextChunk {
  final String keyword;
  final String text;

  PngTextChunk(this.keyword, this.text);
}

class PngMetaData extends MetaData {
  final int? width;
  final int? height;
  final DateTime? lastModified;
  final double? gamma;
  final List<PngTextChunk> textChunks;

  PngMetaData({
    this.width,
    this.height,
    this.lastModified,
    this.gamma,
    this.textChunks = const [],
  });

  PngMetaData._fromBytes(Uint8List bytes)
      : width = _extractWidth(bytes),
        height = _extractHeight(bytes),
        lastModified = _extractLastModified(bytes),
        gamma = _extractGamma(bytes),
        textChunks = _extractTextChunks(bytes);

  static int _findChunk(Uint8List bytes, String chunkType) {
    for (int i = 0; i < bytes.length - 4; i++) {
      if (bytes[i] == chunkType.codeUnitAt(0) &&
          bytes[i + 1] == chunkType.codeUnitAt(1) &&
          bytes[i + 2] == chunkType.codeUnitAt(2) &&
          bytes[i + 3] == chunkType.codeUnitAt(3)) {
        return i;
      }
    }
    return -1;
  }

  static int? _extractWidth(Uint8List bytes) {
    final int idx = _findChunk(bytes, "IHDR");
    if (idx == -1) return null;
    return bytes.buffer.asByteData().getUint32(idx + 4, Endian.big);
  }

  static int? _extractHeight(Uint8List bytes) {
    final int idx = _findChunk(bytes, "IHDR");
    if (idx == -1) return null;
    return bytes.buffer.asByteData().getUint32(idx + 8, Endian.big);
  }

  static DateTime? _extractLastModified(Uint8List bytes) {
    final int idx = _findChunk(bytes, "tIME");
    if (idx == -1) return null;
    final year = bytes.buffer.asByteData().getUint16(idx + 4, Endian.big);
    final month = bytes[idx + 6];
    final day = bytes[idx + 7];
    final hour = bytes[idx + 8];
    final minute = bytes[idx + 9];
    final second = bytes[idx + 10];
    return DateTime(year, month, day, hour, minute, second);
  }

  static double? _extractGamma(Uint8List bytes) {
    final int idx = _findChunk(bytes, "gAMA");
    if (idx == -1) return null;
    return bytes.buffer.asByteData().getUint32(idx + 4, Endian.big) / 100000.0;
  }

  static List<PngTextChunk> _extractTextChunks(Uint8List bytes) {
    const pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];

    // PNG 시그니처 확인
    for (int i = 0; i < pngSignature.length; i++) {
      if (bytes[i] != pngSignature[i]) {
        throw FormatException('Not a PNG file.');
      }
    }

    int cursor = pngSignature.length;
    List<PngTextChunk> textChunks = [];

    while (cursor < bytes.length) {
      cursor = _readNextChunk(bytes, cursor, textChunks);
    }

    return textChunks;
  }

  static int _readNextChunk(Uint8List bytes, int cursor, List<PngTextChunk> textChunks) {
    int chunkLength = bytes.buffer.asByteData().getUint32(cursor, Endian.big);
    cursor += 4;

    String chunkType = String.fromCharCodes(bytes, cursor, cursor + 4);
    cursor += 4;

    // tEXt 청크 확인
    if (chunkType == "tEXt") {
      final textData = bytes.sublist(cursor, cursor + chunkLength);
      final keywordEnd = textData.indexOf(0);  // 첫 번째 null byte 위치
      final keyword = String.fromCharCodes(textData.sublist(0, keywordEnd));
      final text = String.fromCharCodes(textData.sublist(keywordEnd + 1));
      textChunks.add(PngTextChunk(keyword, text));
    }

    cursor += chunkLength + 4;  // 청크 데이터와 CRC를 건너뜁니다.

    return cursor;
  }


  @override
  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'lastModified': lastModified?.toIso8601String(),
      'gamma': gamma,
      'textChunks': textChunks.map((e) => e.keyword + ': ' + e.text).toList(),
    };
  }

  @override
  Map<String, dynamic> extract(Uint8List source, {bool raw = false, ImageType type = ImageType.png}) {
    return PngMetaData._fromBytes(source).toMap();
  }
}

