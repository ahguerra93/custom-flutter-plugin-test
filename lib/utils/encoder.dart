import 'dart:typed_data';
import 'dart:convert';
import 'convert_helper.dart';
class Encoder {
  static String getHexString (String regularString) {
    Uint8List regList = createUint8ListFromString(regularString);
    // print(regList);
    String result = "";
    regList.forEach((listItem){
      result += listItem.toRadixString(16); 
    });
    
    // print(result);

    return result;
  }
  static String fromHextoString (String hexString) {
    String result = "";
    Uint8List numList = new Uint8List(((hexString.length)/2).round());
    print(hexString);
    for (var i = 0; i < hexString.length; i = i+ 2) {
      
      String hexNum = hexString[i] + hexString[i+1];
      print("hex: $numList");  

        numList[(i/2).round()] = int.parse(hexNum, radix: 16);
      
  
      
    }
    
    result = new String.fromCharCodes(numList);
    print(result);
    return result;
  }

}