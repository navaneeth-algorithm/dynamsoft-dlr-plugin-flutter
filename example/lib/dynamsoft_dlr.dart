import 'dart:io';

import 'package:dynamsoftdlr/dynamsoftdlr.dart';

class DynamsoftDLR{
  late String licenseKey;
  Dynamsoftdlr dynamsoftdlr = Dynamsoftdlr();
  Future<bool> init({String? lKey}) async{
    licenseKey = lKey!;
    Map result =  await dynamsoftdlr.initLicense(licenseKey: licenseKey);
    return result["success"];
  }

  Future<String> getText({File? file}) async{
    Map result = await dynamsoftdlr.extractText(file: file);
    if(result["success"]){
      return result["result"];
    }
    return result["error"];
  }
}