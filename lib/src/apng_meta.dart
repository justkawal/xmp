import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:xmp/xmp.dart';

class ChunkInfo {
  String type;
  Uint8List data;

  ChunkInfo(this.type, this.data);
}

class ApngMetaData extends MetaData {
  final int? numFrames;
  final int? numPlays;
  final String? tEXtKeyword;
  final String? tEXtText;
  final String? zTXtKeyword;
  final String? zTXtText;
  final String? iTXtKeyword;
  final String? iTXtText;

  ApngMetaData({
    this.numFrames,
    this.numPlays,
    this.tEXtKeyword,
    this.tEXtText,
    this.zTXtKeyword,
    this.zTXtText,
    this.iTXtKeyword,
    this.iTXtText,
  });

  ApngMetaData _extract(Uint8List data) {
    List<ChunkInfo> chunks = _parseChunks(data);
    int? numFrames;
    int? numPlays;
    String? tEXtKeyword;
    String? tEXtText;
    String? zTXtKeyword;
    String? zTXtText;
    String? iTXtKeyword;
    String? iTXtText;

    for (ChunkInfo chunk in chunks) {
      if (chunk.type == 'acTL') {
        ByteData byteData = ByteData.sublistView(chunk.data);
        numFrames = byteData.getUint32(0, Endian.big);
        numPlays = byteData.getUint32(4, Endian.big);
      }

      if (chunk.type == 'tEXt') {
        Map<String, dynamic> tEXtData = {};
        _extractTextMetadata(chunk.data, tEXtData);
        tEXtKeyword = tEXtData.keys.first;
        tEXtText = tEXtData.values.first;
      }

      if (chunk.type == 'zTXt') {
        Map<String, dynamic> zTXtData = {};
        _extractCompressedTextMetadata(chunk.data, zTXtData);
        zTXtKeyword = zTXtData.keys.first;
        zTXtText = zTXtData.values.first;
      }

      if (chunk.type == 'iTXt') {
        Map<String, dynamic> iTXtData = {};
        _extractITXtMetadata(chunk.data, iTXtData);
        iTXtKeyword = iTXtData.keys.first;
        iTXtText = iTXtData.values.first;
      }
    }

    return ApngMetaData(
      numFrames: numFrames,
      numPlays: numPlays,
      tEXtKeyword: tEXtKeyword,
      tEXtText: tEXtText,
      zTXtKeyword: zTXtKeyword,
      zTXtText: zTXtText,
      iTXtKeyword: iTXtKeyword,
      iTXtText: iTXtText,
    );
  }

  List<ChunkInfo> _parseChunks(Uint8List data) {
    List<ChunkInfo> chunks = [];
    int cursor = 8;

    while (cursor < data.length) {
      int chunkLength = data.buffer.asByteData().getUint32(cursor, Endian.big);
      cursor += 4;

      String chunkType = String.fromCharCodes(data.sublist(cursor, cursor + 4));
      cursor += 4;

      Uint8List chunkData = data.sublist(cursor, cursor + chunkLength);
      cursor += chunkLength;

      cursor += 4;

      chunks.add(ChunkInfo(chunkType, chunkData));
    }

    return chunks;
  }

  void _extractTextMetadata(Uint8List data, Map<String, dynamic> metadata) {
    List<int> nullPosition = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) {
        nullPosition.add(i);
      }
    }
    if (nullPosition.isNotEmpty) {
      String key = utf8.decode(data.sublist(0, nullPosition.first));
      String value = utf8.decode(data.sublist(nullPosition.first + 1));
      metadata[key] = value;
    }
  }

  void _extractCompressedTextMetadata(
      Uint8List data, Map<String, dynamic> metadata) {
    if (data[0] == 0) {
      List<int> nullPosition = [];
      for (int i = 1; i < data.length; i++) {
        if (data[i] == 0) {
          nullPosition.add(i);
          break;
        }
      }

      if (nullPosition.isNotEmpty) {
        String key = utf8.decode(data.sublist(1, nullPosition.first));
        Uint8List compressedData = data.sublist(nullPosition.first + 1);
        List<int> uncompressedData =
            const ZLibDecoder().decodeBytes(compressedData);
        String value = utf8.decode(uncompressedData);
        metadata[key] = value;
      }
    }
  }

  void _extractITXtMetadata(Uint8List data, Map<String, dynamic> metadata) {
    List<int> nullPositions = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) {
        nullPositions.add(i);
      }
    }

    if (nullPositions.length >= 3) {
      String keyword = utf8.decode(data.sublist(0, nullPositions[0]));
      int compressionFlag = data[nullPositions[0] + 1];
      int compressionMethod = data[nullPositions[0] + 2];
      String languageTag =
          utf8.decode(data.sublist(nullPositions[0] + 3, nullPositions[1]));
      String translatedKeyword =
          utf8.decode(data.sublist(nullPositions[1] + 1, nullPositions[2]));

      Uint8List textData = data.sublist(nullPositions[2] + 1);

      String text;
      if (compressionFlag == 1) {
        List<int> uncompressedData = const ZLibDecoder().decodeBytes(textData);
        text = utf8.decode(uncompressedData);
      } else {
        text = utf8.decode(textData);
      }

      metadata[keyword] = {
        'languageTag': languageTag,
        'translatedKeyword': translatedKeyword,
        'text': text,
        'compressionMethod': compressionMethod,
      };
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'numFrames': numFrames,
      'numPlays': numPlays,
      'tEXtKeyword': tEXtKeyword,
      'tEXtText': tEXtText,
      'zTXtKeyword': zTXtKeyword,
      'zTXtText': zTXtText,
      'iTXtKeyword': iTXtKeyword,
      'iTXtText': iTXtText,
    };
  }

  @override
  Map<String, dynamic> extract(Uint8List source,
      {bool raw = false, ImageType type = ImageType.apng}) {
    return _extract(source).toMap();
  }

  @override
  String toString() {
    return 'MetaData{numFrames: $numFrames, numPlays: $numPlays, tEXtKeyword: $tEXtKeyword, tEXtText: $tEXtText, zTXtKeyword: $zTXtKeyword, zTXtText: $zTXtText, iTXtKeyword: $iTXtKeyword, iTXtText: $iTXtText}';
  }
}
