
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Dynamsoftdlr {
  static const MethodChannel _channel = MethodChannel("dynamsoft.dlr/android");

  /*static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }*/
  Future<Map> initLicense({String? licenseKey}) async {
    Map result = {};
    try {
      result =
      await _channel.invokeMethod("initLicense", {"license": licenseKey!});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future extractText({File? file}) async{
    Map result={};
    try{
      result = await _channel.invokeMethod("extractText",{"filepath":file!.path});
    }catch(e){
      print(e);
    }
    return result;
  }

  Future destroy() async{
    try{
      await _channel.invokeMethod("destroy");
    }catch(e){
      print(e);
    }
  }
}
