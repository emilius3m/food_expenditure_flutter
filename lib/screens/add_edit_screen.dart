import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spesa_repository/spesa_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

import 'package:random_string/random_string.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:Spesa/controllers/image_handler.dart';
import 'package:Spesa/screens/textview.dart';
import 'package:exif/exif.dart';

import 'package:Spesa/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/models/models.dart';
typedef OnSaveCallback = Function(String product, String note, String quantity, String fileName, String selectedType);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Item item;

  AddEditScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.item,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller;

  String _product ="";
  String _note;
  String _quantity = "1";

  //
  String base64Image;
  String fileName="";
  var loaded;
  bool isLoading = false;
  //
  File _image;
  String _uploadedFileURL;
  //
  ImageProvider provider;

  bool get isEditing => widget.isEditing;
  Item get item => widget.item;
  var  selectedType;

  @override
  void initState() {
      if (isEditing)
        _controller = TextEditingController(text: item.product);
      else
      _controller = TextEditingController(text: "");
      super.initState();
  }


  Future<File> rotateAndCompressAndSaveImage(File image) async {
      int rotate = 0;
      List<int> imageBytes = await image.readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);

      if (exifData != null &&
          exifData.isNotEmpty &&
          exifData.containsKey("Image Orientation")) {
          IfdTag orientation = exifData["Image Orientation"];
          int orientationValue = orientation.values[0];

          if (orientationValue == 3) {
              rotate = 180;
          }

          if (orientationValue == 6) {
              rotate = -90;
          }

          if (orientationValue == 8) {
              rotate = 90;
          }
      }

      List<int> result = await FlutterImageCompress.compressWithList(imageBytes,
          quality: 100, rotate: 0);

      await image.writeAsBytes(result);

      return image;
  }

  Future<File> fixExifRotation(String imagePath) async {
      final originalFile = File(imagePath);
      List<int> imageBytes = await originalFile.readAsBytes();

      final originalImage = img.decodeImage(imageBytes);

      final height = originalImage.height;
      final width = originalImage.width;

      // Let's check for the image size
      if (height >= width) {
          // I'm interested in portrait photos so
          // I'll just return here
          return originalFile;
      }

      // We'll use the exif package to read exif data
      // This is map of several exif properties
      // Let's check 'Image Orientation'
      final exifData = await readExifFromBytes(imageBytes);

      img.Image fixedImage;

      if (height < width) {
          //logger.logInfo('Rotating image necessary');
          // rotate
          if (exifData['Image Orientation'].printable.contains('Horizontal')) {
              fixedImage = img.copyRotate(originalImage, 90);
          } else if (exifData['Image Orientation'].printable.contains('180')) {
              fixedImage = img.copyRotate(originalImage, -90);
          } else {
              fixedImage = img.copyRotate(originalImage, 0);
          }
      }

      // Here you can select whether you'd like to save it as png
      // or jpg with some compression
      // I choose jpg with 100% quality
      final fixedFile =
      await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

      return fixedFile;
  }

  Future<List<int>> testCompressFile(File file) async {
      print("testCompressFile");
      final result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: 2300,
          minHeight: 1500,
          quality: 30,
          //rotate: 270,
      );
      print(file.lengthSync());
      print(result.length);
      return result;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
      print("testCompressAndGetFile");
      final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 30,
          minWidth: 1024,
          minHeight: 1024,
          //rotate: 90,
      );

      print(file.lengthSync());
      print(result.lengthSync());

      return result;
  }


  void _choose() async {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      print('Picker is called');
      _image = await ImagePicker.pickImage(source: ImageSource.camera);

      _image = await rotateAndCompressAndSaveImage(_image);

      fileName= _image.path.split("/").last;
      print("FILE SIZE BEFORE: " + _image.lengthSync().toString());

      List<int> list = await testCompressFile(_image);


      // ImageProvider provider = MemoryImage(Uint8List.fromList(list));
      this.provider = MemoryImage(Uint8List.fromList(list));

      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = dir.absolute.path + "/"+randomAlpha(1)+fileName;
      _image = await testCompressAndGetFile(_image, targetPath);
      fileName= _image.path.split("/").last;

      //await CompressImage.compress(imageSrc: img.path, desiredQuality: 20); //desiredQuality ranges from 0 to 100
      //print("FILE SIZE  AFTER: " + img.lengthSync().toString());

      //List<int> imageBytes = img.readAsBytesSync();

      base64Image = base64Encode(list);
//    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (_image != null) {
          //file =  Image(Uint8List.fromList(list);
          setState(() {
              this.provider;

          });
      }
      _upload();
  }
// file = await ImagePicker.pickImage(source: ImageSource.gallery);

    /*Future _upload() async {

        if (provider == null) return;

        //
        //print("FILE SIZE BEFORE: " + file.lengthSync().toString());
        //await CompressImage.compress(imageSrc: file.path, desiredQuality: 20); //desiredQuality ranges from 0 to 100
        //print("FILE SIZE  AFTER: " + file.lengthSync().toString());

        //setState(() {
        //    file;

        //});

        //

        //String base64Image = base64Encode(file.readAsBytesSync());
        //String fileName =

        http.post(phpEndPoint, body: {
            "image": base64Image,
            "name": fileName,
        }).then((res) {
            print(res.statusCode);
            print(res.body);
            setState(() {
                //file;
                loaded=true;
            });

        }).catchError((err) {
            print(err);
        });
    }*/

    Future _upload() async {
        setState(() {
            isLoading = true;
        });
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(_image.path)}');
        StorageUploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.onComplete;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) {
            setState(() {
                _uploadedFileURL = fileURL;
                isLoading = false;
                loaded=true;
            });
        });
    }


    Future <String> handleTextView() async {

        final textBlocs = await recognizeImage(
            _image, FirebaseVision.instance.textRecognizer(),
            getBlocks: true);

        final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TextView(textBlocks: textBlocs, onSave: (product) {
                    //print (product);

                    //setState(() {
                      //  textproduct=product;
                    //});
                }
                )
            )

        );
        return result;
    }

    @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;


   /* List<String> _accountType = <String>[
        'Savings',
        'Deposit',
        'Checking',
        'Brokerage'
    ];*/

    return Scaffold(
      /*appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Product' : 'Add Product',
        ),
      ),*/
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                //initialValue: isEditing ? widget.item.product : '',
                  //autofocus: !isEditing,
                  style: textTheme.headline5,
                  controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Inserisci il nome dell\'articolo',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))
                ),
                validator: (val) {
                  return val.trim().isEmpty ? 'Aggiungi una descrizione' : null;
                },
                onSaved: (value) => _product = value,
              ),
              /*  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Icon(
                            FontAwesomeIcons.moneyBill,
                            size: 25.0,
                            color: Color(0xff11b719),
                        ),
                        SizedBox(width: 50.0),
                        DropdownButton(
                            items: _accountType
                                .map((value) => DropdownMenuItem(
                                child: Text(
                                    value,
                                    style: TextStyle(color: Color(0xff11b719)),
                                ),
                                value: value,
                            ))
                                .toList(),
                            onChanged: (selectedAccountType) {
                                print('$selectedAccountType');
                                setState(() {
                                    selectedType = selectedAccountType;
                                });
                            },
                            value: selectedType,
                            isExpanded: false,
                            hint: Text(
                                'Choose Account Type',
                                style: TextStyle(color: Color(0xff11b719)),
                            ),
                        )
                    ],
                ),*/
                SizedBox(height: 15.0,),
                TouchSpin(
                    //value: int.parse(_quantity),
                    value: isEditing ? int.parse(widget.item.quantity) : 1,
                    // value: 1,
                    min: 0,
                    max: 100,
                    step: 1,
                    //displayFormat: NumberFormat.currency(locale: 'en_US', symbol: '\$'),
                    textStyle: TextStyle(fontSize: 36),
                    iconSize: 48.0,
                    addIcon: Icon(Icons.add_circle_outline),
                    subtractIcon: Icon(Icons.remove_circle_outline),
                    iconActiveColor: Color(0xFF18D191),
                    iconDisabledColor: Colors.grey,
                    iconPadding: EdgeInsets.all(20),
                    onChanged: (val){
                        print(val);
                        _quantity=val.toString();
                    },
                    enabled: true,
                ),
                SizedBox(height: 15.0,),
                StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("types").snapshots(),
                    builder: (context, snapshot) {
                        if (!snapshot.hasData)
                            const Text("Loading.....");
                        else {
                            List<DropdownMenuItem> typesItems = [];
                            for (int i = 0; i < snapshot.data.documents.length; i++) {
                                DocumentSnapshot snap = snapshot.data.documents[i];
                                typesItems.add(
                                    DropdownMenuItem(
                                        child: Text(
                                            snap.documentID,
                                            style: TextStyle(color: Color(0xFF18D191)),
                                        ),
                                        value: "${snap.documentID}",
                                    ),
                                );
                            }
                            return Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                    Icon(FontAwesomeIcons.shoppingBag,
                                        size: 30.0, color: Color(0xFF18D191)),
                                    SizedBox(width: 100.0,height: 50.0),
                                    DropdownButton(
                                        items: typesItems,
                                        value: selectedType,
                                        onChanged: (typeValue) {
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    ' $typeValue',
                                                    style: TextStyle(color: Color(0xFF18D191)),
                                                ),
                                            );
                                            Scaffold.of(context).showSnackBar(snackBar);
                                            setState(() {
                                                selectedType = typeValue;
                                            });
                                        },
                                        //value: selectedType,
                                        isExpanded: false,
                                        hint: new Text(
                                            "Choose Type",
                                            style: TextStyle(color: Color(0xFF18D191)),
                                        ),
                                    ),
                                ],
                            );

                        }
                        return Container();
                    }
                ),
                TextFormField(
                    initialValue: isEditing ? widget.item.note : '',
                    maxLines: 1,
                    //style: textTheme.subtitle1,
                    decoration: InputDecoration(
                        hintText: 'Aggiungi delle note...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)))
                    ),
                    onSaved: (value) => _note = value,
                ),
                SizedBox(
                    height: 10.0,
                ),
                Column(
                    children: <Widget>[

                        provider == null
                            ? Text('\n')
                            : Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 5.0,
                            ),
                            height: 170.0,
                            child: ClipRect(
                                child: PhotoView(
                                    enableRotation: true,
                                    imageProvider : provider ,
                                    //MemoryImage(base64Decode(base64Image)),
                                    //maxScale: PhotoViewComputedScale.covered * 2.0,
                                    //minScale: PhotoViewComputedScale.contained * 0.8,
                                    initialScale: PhotoViewComputedScale.covered,
                                    //customSize: MediaQuery.of(context).size,
                                    gaplessPlayback: false,
                                    basePosition: Alignment.center,
                                    minScale: PhotoViewComputedScale.contained * 0.8,
                                    maxScale: PhotoViewComputedScale.covered * 1.8,
                                    //initialScale: PhotoViewComputedScale.contained,
                                ),
                            ),
                        )
                    ],
                ),

            ],
          ),
        ),
      ),


        floatingActionButton:  Row(

            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                isEditing ? Row() : FloatingActionButton(
                        backgroundColor: Color(0xFF18D191),
                    mini: false,
                    elevation: 9,
                    heroTag: null,
                    onPressed: _choose,
                    child: Icon(Icons.add_a_photo),
                ),
                SizedBox(
                    width: 10,
                ),
                loaded == null ? Row() : FloatingActionButton(
                    backgroundColor: Color(0xFF18D191),

                    mini: false,
                    elevation: 9,
                    heroTag: null,
                    onPressed: () async {
                        String prod=await handleTextView();
                        setState(() {
                            _product = prod;
                            //print (_product);
                            _controller.text = _product;
                        });
                    },
                    child: Icon(Icons.text_fields),
                ),
                SizedBox(
                    width: 10,
                ),
                FloatingActionButton(
                    tooltip: isEditing ? 'Save changes' : 'Add Product',
                    backgroundColor: Color(0xFF18D191),
                    mini: false,
                    elevation: 9,
                    heroTag: null,
                    onPressed: () {
                        if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _product = _product.replaceAll("\n", " ");
                            _note = _note.replaceAll("\n", " ");
                            //widget.onSave(_product, _note,_quantity,_uploadedFileURL,selectedType);
                            if (!isEditing) {
                                BlocProvider.of<ListBloc>(context).add(
                                    AddItem(Item(_product, note: _note,
                                        quantity: _quantity,
                                        type: selectedType,
                                        imageurl: _uploadedFileURL)),
                                );
                                BlocProvider.of<TabBloc>(context).add(
                                    UpdateTab(AppTab.spesa));

                            } else {
                                BlocProvider.of<ListBloc>(context).add(UpdateItem(item.copyWith(
                                    product:_product,note:_note,quantity:_quantity,imageurl:_uploadedFileURL,type:selectedType
                                )));
                                Navigator.pop(context);
                            }
                        }
                    },

                    child: Icon(isEditing ? Icons.check : Icons.add),
                ),
            ],
        ),
    );
  }
}
