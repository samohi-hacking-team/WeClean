import 'dart:io';
import 'package:tflite/tflite.dart';

dynamic tensorflowStuff(File image) async {
  await Tflite.loadModel(
    model: "tensorflow/model.tflite",
    labels: "tensorflow/dict.txt",
    numThreads: 1,
  );

  var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true);
  
  return output;
}
