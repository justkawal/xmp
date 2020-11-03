# XMP
  
  <a href="https://flutter.io">  
    <img src="https://img.shields.io/badge/Platform-Flutter-yellow.svg"  
      alt="Platform" />  
  </a> 
   <a href="https://pub.dartlang.org/packages/xmp">  
    <img src="https://img.shields.io/pub/v/xmp.svg"  
      alt="Pub Package" /> 
  </a>
   <a href="https://opensource.org/licenses/MIT">  
    <img src="https://img.shields.io/badge/License-MIT-red.svg"  
      alt="License: MIT" />  
  </a>  
   <a href="https://www.paypal.me/kawal7415">  
    <img src="https://img.shields.io/badge/Donate-PayPal-green.svg"  
      alt="Donate" />  
  </a>
   <a href="https://github.com/justkawal/xmp/issues">  
    <img src="https://img.shields.io/github/issues/justkawal/xmp"  
      alt="Issue" />  
  </a> 
   <a href="https://github.com/justkawal/xmp/network">  
    <img src="https://img.shields.io/github/forks/justkawal/xmp"  
      alt="Forks" />  
  </a> 
   <a href="https://github.com/justkawal/xmp/stargazers">  
    <img src="https://img.shields.io/github/stars/justkawal/xmp"  
      alt="Stars" />  
  </a>
  <br>
  <br>
 
 [xmp](https://www.pub.dev/packages/xmp) module helps to extract xmp data of the images.
 It is purely written in dart, So it can be used on server as well as on client.



# Table of Contents
  - [Installing](#lets-get-started)
  - [Usage](#usage)
    * [Imports](#imports)
    * [Read image file](#read-image-file)
    * [Read image file from Asset Folder](#read-image-from-flutters-asset-folder)
    * [Extract Exif Data](#extract-exif-data)
    * [Saving Exif Content into File](#saving-exif-content-into-file)
  - [Donate (Be the First one)](#donate)

# Lets Get Started

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  xmp:
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```css
$  pub get
```

### 3. Import it

Now in your `Dart` code, you can use: 

````dart
import 'package:xmp/xmp.dart';
````

# Usage

### Imports

````dart
import 'package:xmp/xmp.dart';    
````

### Read Image File

````dart
var file = "path_to_pre_existing_image_file/image.jpg";
var bytes = File(file).readAsBytesSync();
    
````

### Read Image from Flutter's Asset Folder

````dart
import 'package:flutter/services.dart' show ByteData, rootBundle;
    
/* Your blah blah code here */
    
ByteData data = await rootBundle.load("assets/path_to_pre_existing_image_file/image.jpg";);
var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    
````

### Extract Exif Data
    
````dart
var result = XMP.extract(bytes);
saveFile(image, result);
    
````
### Result
````json
{
    "raw": {
        "MicrosoftPhoto:LastKeywordXMP": [
            "tag1",
            "tag2"
        ],
        "MicrosoftPhoto:Rating": "50",
        "xmp:Rating": "3",
        "dc:title": "Title",
        "dc:description": "Title",
        "dc:subject": "tag2"
    },
    "keywords": [
        "tag1",
        "tag2"
    ],
    "rating": 3,
    "title": "Title",
    "description": "Title",
    "subject": "tag2"
}
````

### Saving exif content into File

````dart
void saveFile(String fileName, dynamic exifContent) {
  File('${path}$fileName.json').writeAsStringSync(jsonEncode(exifContent));
}
````

#### Also checkout our other libraries on: 
  - [Libs](https://www.github.com/justkawal/)

### Donate
Ooooops, My laptop is **slow**, but I'm not.
  - [Paypal](https://www.paypal.me/kawal7415)
  - Not having Paypal account ?? [Join Now](https://www.paypal.com/in/flref?refBy=Pzpaa7qp041602067472432) and both of us could earn **`$10`**
