package com.neethasolution.dynamsoftdlr;

import android.util.Log;

import androidx.annotation.NonNull;

import com.dynamsoft.dlr.*;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
/** DynamsoftdlrPlugin */
public class DynamsoftdlrPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private LabelRecognizer mRecognizer;
  private DLRLicenseVerificationListener listener;
  private static final String CHANNEL = "dynamsoft.dlr/android";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "dynamsoft.dlr/android");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    /*if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }*/

    if(call.method.equals("initLicense")){

      String licensekey = call.argument("license");
      //init license
      //DLS2eyJvcmdhbml6YXRpb25JRCI6IjEwMDg5MzExNyJ9
      LabelRecognizer.initLicense(licensekey, (success, error) -> {
        HashMap hashMap = new HashMap();
        if (!success && error != null) {
          error.printStackTrace();


          hashMap.put("success",false);
          hashMap.put("error",error.toString());
          result.success(hashMap);
        }
        try {
          mRecognizer = new LabelRecognizer();
          hashMap.put("success",true);
          result.success(hashMap);
        } catch (LabelRecognizerException e) {
          hashMap.put("success",false);
          hashMap.put("error", e.toString());
        }

      });
    }
    else if(call.method.equals("destroy")){
      mRecognizer.destroy();
    }
    else if(call.method.equals("extractText")){
      HashMap hashMap = new HashMap();

      String filePath = call.argument("filepath");
      Log.i("DYNAMO",filePath);
      try {

        String resultData = "";
        DLRResult dlrResult[] =  mRecognizer.recognizeByFile(filePath,"");
        for (DLRResult dlr:dlrResult
        ) {
          DLRLineResult dlrLineResult[] = dlr.lineResults;
          for (DLRLineResult dlrLine:dlrLineResult
          ) {
            Log.i("DYNAMO",dlrLine.text);
            resultData = resultData+" "+dlrLine.text;
          }
          resultData = resultData+"\n";

        }
        hashMap.put("success",true);
        hashMap.put("result",resultData);
        result.success(hashMap);
      } catch (LabelRecognizerException e) {
        hashMap.put("success",false);
        hashMap.put("error", e.toString());
        result.success(hashMap);
      }
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
