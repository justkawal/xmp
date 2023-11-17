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
    * [Extract XMP Data](#extract-xmp-data)
    * [Parsed XMP Result](#parsed-xmp-result)
    * [Extract RAW XMP Data](#extract-raw-xmp-data)
    * [Parsed RAW XMP Result](#parsed-raw-xmp-result)
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

### Extract XMP Data
    
````dart
var result = XMP.extract(bytes);
saveFile(image, result);
    
````
### Parsed XMP Result
````json
{
    "XMP Tool Kit": "Adobe XMP Core 5.6-c140 79.160451, 2017/05/06-01:08:21",
    "Marked": "False",
    "Web Statement": "Copyright Info URL Field",
    "Location": "Sublocation Field",
    "Intellectual Genre": "Intellectual Genre Field",
    "Genre": "Genre Field",
    "Release Date": "Release Date Field",
    "Composer": "Composer Field",
    "Engineer": "Engineer Field",
    "....": ".....",
    "....": ".....",
    "....": ".....",
    "................Some More XMP Data.........":".... Blah Blah Blah Values .....",
    "....": ".....",
    "....": ".....",
    "....": ".....",
    "Whites 2012": "+40",
    "Blacks 2012": "-10",
    "Texture": "0",
    "Clarity 2012": "0",
    "Dehaze": "0",
    "Vibrance": "0",
    "Saturation Adjustment Yellow": "0",
    "Saturation Adjustment Green": "0",
    "Saturation Adjustment Aqua": "0",
    "Title": "Title Field",
    "Description": "Caption Field",
    "Creator": "Creator Field",
    "Subject": [
        "4K",
        "Mountains",
        "Sky",
        "Wallpaper"
    ],
    "Rights": "Copyright Field",
    "Usage Terms": "Rights Usage Terms Field",
    "Scene": [
        "Scene Field",
        "IPTC Scene Code Field"
    ],
    "Subject Code": "IPTC Subject Code Field",
    "Supplemental Categories": "Other Category Field",
    "Property Release ID": "Release ID Field",
    "Tone Curve PV 2012": [
        "0, 0",
        "255, 255"
    ],
    "Tone Curve PV 2012 Red": [
        "0, 0",
        "255, 255"
    ],
    "Tone Curve PV 2012 Green": [
        "0, 0",
        "255, 255"
    ],
    "Tone Curve PV 2012 Blue": [
        "0, 0",
        "255, 255"
    ],
    "Hierarchical Subject": [
        "4K",
        "Mountains",
        "Sky",
        "Wallpaper"
    ]
}
````

### Extract RAW XMP Data
    
````dart
var result = XMP.extract(bytes, raw: true);
saveFile(image, result);
    
````
### Parsed RAW XMP Result
````json
{
    "x:xmptk": "Adobe XMP Core 5.6-c140 79.160451, 2017/05/06-01:08:21",
    "dc:format": "image/jpeg",
    "xmpRights:Marked": "False",
    "xmpRights:WebStatement": "Copyright Info URL Field",
    "Iptc4xmpCore:Location": "Sublocation Field",
    "Iptc4xmpCore:IntellectualGenre": "Intellectual Genre Field",
    "Iptc4xmpCore:CountryCode": "BR",
    "photoshop:AuthorsPosition": "Job Title Field",
    "photoshop:Headline": "Headline Field",
    "photoshop:CaptionWriter": "Description Writer Field",
    "photoshop:Category": "Category Field",
    "photoshop:DateCreated": "2020-11-01",
    "photoshop:City": "City Field",
    "xmp:Rating": "5",
    "xmp:MetadataDate": "2020-11-01T16:00:39-03:00",
    "crs:Version": "13.0",
    "crs:ProcessVersion": "11.0",
    "crs:WhiteBalance": "Auto",
    "crs:IncrementalTemperature": "+20",
    "crs:IncrementalTint": "+20",
    "crs:Exposure2012": "0.00",
    "crs:Contrast2012": "0",
    "crs:Highlights2012": "-30",
    "....": ".....",
    "....": ".....",
    "....": ".....",
    "................Some More XMP Data.........":".... Blah Blah Blah Values .....",
    "....": ".....",
    "....": ".....",
    "....": ".....",
    "dc:subject": [
        "4K",
        "Mountains",
        "Sky",
        "Wallpaper"
    ],
    "dc:rights": "Copyright Field",
    "xmpRights:UsageTerms": "Rights Usage Terms Field",
    "Iptc4xmpCore:Scene": "IPTC Scene Code Field",
    "plus:ModelReleaseID": "Release Id Field",
    "plus:PropertyReleaseID": "Release ID Field",
    "crs:ToneCurvePV2012": [
        "0, 0",
        "255, 255"
    ],
    "crs:ToneCurvePV2012Red": [
        "0, 0",
        "255, 255"
    ],
    "crs:ToneCurvePV2012Green": [
        "0, 0",
        "255, 255"
    ],
    "crs:ToneCurvePV2012Blue": [
        "0, 0",
        "255, 255"
    ],
    "lr:hierarchicalSubject": [
        "4K",
        "Mountains",
        "Sky",
        "Wallpaper"
    ]
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

### Donate ❤️
Thanks for donating, Your donation goes towards my tuition fees!!
