import 'dart:io';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String result = '';
  File? image;
  ImagePicker? imagePicker;

  pickImageFromGallery() async{
    XFile? pickedFile = await imagePicker!.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  pickImageFromCamera() async{
    XFile? pickedFile = await imagePicker!.pickImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async{
    final GoogleVisionImage firebaseVisionImage = GoogleVisionImage.fromFile(image!);
    final TextRecognizer recognizer = GoogleVision.instance.textRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    result = '';
    setState(() {
      for(TextBlock block in visionText.blocks){
        final String? txt = block.text;
        for(TextLine line in block.lines){
          for(TextElement element in line.elements){
            result += element.text! + " ";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Column(
          children: [
            const SizedBox(width: 100,),
            Container(
              height: 200,
              width: 250,
              margin: const EdgeInsets.only(top:70 ),
              padding: const EdgeInsets.only(left: 20, bottom: 5, right: 18),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    result, style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/note.jpg'),
                  fit: BoxFit.cover,
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset('assets/pin.png', height: 240, width: 240,),
                      )
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: (){
                        pickImageFromGallery();
                      },
                      onLongPress: (){
                        pickImageFromCamera();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: image != null? Image.file(image!, width: 140, height: 192, fit: BoxFit.fill,): Container(
                          width: 240,
                          height: 200,
                          child: const Icon(Icons.camera_enhance_sharp, size: 100, color: Colors.grey,),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
