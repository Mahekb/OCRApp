import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result="";
  File _image;
  final picker = ImagePicker();

  Future<void> createpdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(result),
        ),
      ),
    );

    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  Future<File> imageFile;
  _imagetotextfunc() async{
    final FirebaseVisionImage firebaseVisionImage =FirebaseVisionImage.fromFile(_image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText visionText =await recognizer.processImage(firebaseVisionImage);
    result="";
    setState(() {
      for(TextBlock block in visionText.blocks){
        final String txt = block.text;
        for(TextLine line in block.lines){
          for(TextElement element in line.elements){
            result += element.text+" ";
          }
        }
        result += "\n\n";
      }
    });
  }
  _imgFromCamera() async {
    final image = await picker.getImage( source: ImageSource.camera,);

    setState(() {
      _image = File(image.path);
      _imagetotextfunc();
    });
  }

  _imgFromGallery() async {
    final image = await  picker.getImage(
        source: ImageSource.gallery,
    );

    setState(() {
      _image = File(image.path);
      _imagetotextfunc();
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OCR App"),
      ),
      body: Container(
        child: Column(
          children: [
            //results
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              height: 280,
              width: 250,
              margin: EdgeInsets.only(top:70,left: 15),
              padding: EdgeInsets.only(left: 28,bottom: 5,right: 18),
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: SelectableText(
                    result,
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.justify,
                  ),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                      createpdf();
                  },
                  icon: Icon(Icons.picture_as_pdf, size: 18),
                  label: Text("Download PDF"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () => { _showPicker(context)},
        foregroundColor: Colors.indigo,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.indigo,
    );
  }
}
