import 'dart:io';

import 'package:dynamsoftdlr_example/dynamsoft_dlr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DynamsoftDLR? dynamsoftDLR;
  Future? initFuture;
  String ? result="";
  File? selectedImage;
  Future initDynamsoft() async{
    bool suc = await dynamsoftDLR!
        .init(lKey: "DLS2eyJvcmdhbml6YXRpb25JRCI6IjEwMDg5MzExNyJ9");
    print(suc);
  }

  bool onProcess=false;

  selectImage() async{
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    File file = File(image!.path);
    setState(() {
      selectedImage =  file;
    });

  }

  startExtract() async{
    setState(() {
      onProcess =true;
    });
    dynamsoftDLR!.getText(file: selectedImage).then((txt){
      setState(() {
        result  = txt;
        onProcess =false;
      });
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dynamsoftDLR = DynamsoftDLR();
    initFuture =initDynamsoft();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Sample DLR"),
        ),
      ),
      body: Container(
        child: FutureBuilder(future: initFuture,builder: (context,snapshot){
          if(snapshot.connectionState!=ConnectionState.done){
            return CircularProgressIndicator();
          }
          return Column(
            children: [
              Row(
                children: [
                  ElevatedButton(onPressed: selectImage, child: Text("Select Image")),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: startExtract, child: Text("Start Extract"))
                ],
              ),
             selectedImage!=null? Container(width:300,height:300,child: Image.file(selectedImage!),):Container(),
              onProcess ?Container(child: Text("Extracting..."),):Container(),
              Text(result!)
            ],
          );
        },),
      ),
    );
  }
}
