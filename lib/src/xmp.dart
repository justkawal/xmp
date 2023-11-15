part of xmp;

enum ImageType { jpg, jpeg, gif, png, apng }

abstract class MetaData{
  Map<String, dynamic> extract(Uint8List source, {bool raw = false, ImageType type = ImageType.jpg});
  Map<String, dynamic> toMap();
}

class XMP {
  ///
  ///Extracts `XMP Data` from the image
  ///
  ///```
  /// Map result = XMP.extract(bytes);
  /// print(result.toString());
  ///
  ///```
  ///                 or
  ///Extracts `XMP RAW Data` from the image
  ///
  ///```
  /// Map result = XMP.extract(bytes, raw: true);
  /// print(result.toString());
  ///
  ///```
  static Map<String, dynamic> extract(Uint8List source, {bool raw = false, ImageType type = ImageType.jpg}) {
    switch (type) {
      case ImageType.apng:
        return ApngMetaData().extract(source, raw: raw);
      case ImageType.png:
        return PngMetaData().extract(source, raw: raw);
      case ImageType.jpeg:
        return JpegMetaData().extract(source, raw: raw);
      default:
        return _defaultExtract(source, raw: raw);
    }
  }

  static _defaultExtract(Uint8List source, {bool raw = true}) {
    if (source is! Uint8List) {
      throw Exception('Not a Uint8List');
    } else {
      var result = <String, dynamic>{};
      int offsetBegin = _findIndexOf(source, _markerBegin.codeUnits);
      if (offsetBegin != -1) {
        int offsetEnd = _findIndexOf(source, _markerEnd.codeUnits, start: offsetBegin);
        if (offsetEnd != -1) {
          Uint8List xmlBytes =
          source.sublist(offsetBegin, offsetEnd + _markerEnd.length);

          String xmlBuffer = String.fromCharCodes(xmlBytes);

          XmlDocument xml;
          try {
            xml = XmlDocument.parse(xmlBuffer);
          } catch (e) {
            return {'Exception': e.toString()};
          }

          // First rdf:Description
          var rdf_Description = xml.descendants
              .where((node) => node is XmlElement)
              .map((node) => node as XmlElement)
              .toList();
          rdf_Description.forEach((element) {
            _addAttribute(result, element, raw);
          });

          // Other selected known tags
          [_listingTextTags].forEach((headerTag) {
            headerTag.forEach((tag) {
              var tags = xml.findAllElements(tag);
              if (tags.isNotEmpty) {
                tags.forEach((element) {
                  var textList = element.descendants
                      .where((node) =>
                  node is XmlText && !node.text.trim().isEmpty)
                      .toList();
                  textList.forEach((text) {
                    _addAttributeList(
                        raw ? tag : camelToNormal(tag), text.text, result);
                  });
                });
              }
            });
          });
          return result;
        } else {
          return {'Exception': 'XMP marker end not found'};
        }
      } else {
        return {'Exception': 'XMP marker begin not found'};
      }
    }
  }

  static int _findIndexOf(Uint8List data, List<int> pattern, {int start = 0}) {
    int j = 0;
    for (int i = start; i < data.length; i++) {
      if (data[i] == pattern[j]) {
        j++;
        if (j == pattern.length) {
          return i - j + 1;
        }
      } else {
        j = 0;
      }
    }
    return -1;
  }

  static void _addAttribute(
      Map<String, dynamic> result, XmlElement element, bool raw) {
    var attributeList = element.attributes.toList();

    var headerName;

    if (!raw) {
      XmlElement? temporaryElement = element;
      String? temporaryName = temporaryElement.name.toString().toLowerCase();

      while (!_envelopeTags.every((element) => element != temporaryName)) {
        temporaryElement = temporaryElement?.parentElement;
        if (temporaryElement == null) {
          break;
        }
        temporaryName = temporaryElement.name.toString().toLowerCase();
      }
      headerName = (temporaryElement?.name ?? element.name).toString();
      if (headerName == 'null') {
        throw Exception(
            'If you find this exception, then PLEASE take the pain to post the issue with sample on https://github.com/justkawal/xmp.git. \n\n\t\t\t Thanks for improving ```OpEn SouRce CoMmUniTy```');
      }
    }

    attributeList.forEach((attribute) {
      var attr = attribute.name.toString();
      if (!attr.contains('xmlns:') && !attr.contains('xml:')) {
        var endName = attribute.name.toString();
        var value = attribute.value.toString();
        result[(raw
                ? '$endName'
                : '${camelToNormal(headerName)} ${camelToNormal(endName)}')
            .toString()
            .trim()] = value;
      }
    });

    element.children
        .where((child) => child is XmlElement)
        .map((e) => e as XmlElement)
        .forEach((child) {
      if (child is! XmlText) {
        _addAttribute(result, child, raw);
      }
    });
  }

  static String camelToNormal(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    // split on `:`
    if (text.contains(':')) {
      text = text.split(':')[1];
    }
    // capitalize first letter
    text = text.capitalize;

    // fetch from replacement for exceptional cases
    var replace = _replacement[text];
    if (replace != null) {
      return replace;
    }

    return text!.nameCase();
  }

  static void _addAttributeList(
      String key, String text, Map<String, dynamic> result) {
    text = text.trim();
    if (result[key] == null) {
      result[key] = text;
    } else {
      // check if it is list
      if (result[key] is List) {
        result[key].add(text);
      } else {
        var temporaryValue = result[key].toString();
        if (temporaryValue.trim() != text) {
          // remove the key
          result.remove(key);
          // re-initialize the key with new empty data-type
          result[key] = <String>[];
          // add the new list to the key
          result[key].addAll([temporaryValue, text]);
        }
      }
    }
  }
}

