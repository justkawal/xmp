part of xmp;

const markerBegin = '<x:xmpmeta';
const markerEnd = '</x:xmpmeta>';

const knownTags = [
  'MicrosoftPhoto:LastKeywordXMP',
  'MicrosoftPhoto:LastKeywordIPTC',
  'MicrosoftPhoto:Rating',
  'Iptc4xmpCore:Location',
  'xmp:Rating',
  'dc:title',
  'dc:description',
  'dc:creator',
  'dc:subject',
  'dc:rights',
  'cc:attributionName'
];

const envelopeTags = ['rdf:Bag', 'rdf:Alt', 'rdf:Seq', 'rdf:li'];
