part of xmp;

class XMP {
  ///
  ///Extracts XMP data from the image
  ///
  ///````
  ///// XMP.extract(Uint8List bytes);
  /// Map result = XMP.extract(bytes);
  /// print(result.toString());
  ///
  ///````
  static Map<String, dynamic> extract(Uint8List source) {
    if (source is! Uint8List) {
      throw Exception('Not a Uint8List');
    } else {
      var data = Map<String, dynamic>.from({'raw': {}});
      var buffer = utf8.decode(source, allowMalformed: true);
      int offsetBegin = buffer.indexOf(markerBegin);
      if (offsetBegin != -1) {
        int offsetEnd = buffer.indexOf(markerEnd);
        if (offsetEnd != -1) {
          var xmlBuffer =
              buffer.substring(offsetBegin, offsetEnd + markerEnd.length);
          var xml = XmlDocument.parse(xmlBuffer);

          [knownTags, envelopeTags].forEach((headerTag) {
            headerTag.forEach((tag) {
              var tags = xml.findAllElements(tag);
              if (tags.isNotEmpty) {
                tags.forEach((element) {
                  var textList = element.descendants
                      .where((node) =>
                          node is XmlText && !node.text.trim().isEmpty)
                      .toList();
                  textList.forEach((text) {
                    _parseTag(tag, text.text, data);
                  });
                });
              }
            });
          });
          return data;
        } else {
          return data;
        }
      } else {
        return data;
      }
    }
  }

  static void _parseTag(
      String nodeName, String text, Map<String, dynamic> data) {
    text = text.trim();
    if (text != '') {
      switch (nodeName) {
        case 'MicrosoftPhoto:LastKeywordXMP':
        case 'MicrosoftPhoto:LastKeywordIPTC':
          if (data['raw'] == null || data['raw'][nodeName] == null)
            data['raw'][nodeName] = <String>[text];
          else if (data['raw'][nodeName].indexOf(text) == -1)
            data['raw'][nodeName].add(text);
          if (data['keywords'] == null)
            data['keywords'] = <String>[text];
          else if (data['keywords'].indexOf(text) == -1)
            data['keywords'].add(text);
          break;
        case 'dc:title':
          data['raw'][nodeName] = text;
          data['title'] = text;
          break;
        case 'dc:description':
          data['raw'][nodeName] = text;
          data['description'] = text;
          break;
        case 'xmp:Rating':
          data['raw'][nodeName] = text;
          data['rating'] = int.tryParse(text);
          break;
        case 'MicrosoftPhoto:Rating':
          data['raw'][nodeName] = text;
          data['rating'] = ((int.tryParse(text) ?? 0) + 12 / 25).floor() + 1;
          break;
        case 'Iptc4xmpCore:Location':
          data['raw'][nodeName] = text;
          data['location'] = text;
          break;
        case 'dc:creator':
          data['raw'][nodeName] = text;
          data['creator'] = text;
          break;
        case 'dc:subject':
          data['raw'][nodeName] = text;
          data['subject'] = text;
          break;
        case 'cc:attributionName':
          data['raw'][nodeName] = text;
          data['attribution'] = text;
          break;
        case 'xmpRights:UsageTerms':
        case 'dc:rights':
          data['raw'][nodeName] = text;
          data['terms'] = text;
          break;
      }
    }
  }
}
