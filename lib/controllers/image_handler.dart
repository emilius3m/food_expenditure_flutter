import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';

Future<dynamic> recognizeImage(File image, TextRecognizer recognizer,
    {bool getBlocks = false}) async {
  //parsed image
  final visionImage = FirebaseVisionImage.fromFile(image);
  //processing parsed image
  final visionText = await recognizer.processImage(visionImage);
  if (getBlocks) return visionText.blocks;
  //reutrn text
  return visionText;
}

