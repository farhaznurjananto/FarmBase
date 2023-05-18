import 'dart:io';
import 'package:farmbase/view/tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import 'package:farmbase/utils.dart';
import 'package:farmbase/model/note_model.dart';
import 'package:farmbase/controller/note_controller.dart';

class NoteCreateScreen extends StatefulWidget {
  final String uid;
  final NoteModel? note;
  const NoteCreateScreen({Key? key, required this.uid, this.note})
      : super(key: key);

  @override
  State<NoteCreateScreen> createState() => _NoteCreateScreenState();
}

class _NoteCreateScreenState extends State<NoteCreateScreen> {
  NoteController noteController = NoteController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  dynamic selected;

  File? _image;
  String? fileName;
  String? imgUrl;
  String? imgUrlOld;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      imgUrlOld = widget.note!.imgUrl;
      imgUrl = widget.note!.imgUrl;
    }
  }

  // late String imgUrl;

  void saveNote() async {
    final directory = await getExternalStorageDirectory();
    if (_image != null) {
      fileName = DateTime.now().millisecondsSinceEpoch.toString();
      imageFile = File('${directory!.path}/$fileName.jpg');
      imgUrl = '/users/${widget.uid}/images/$fileName.jpg';
    }
    if (_formKey.currentState!.validate() && imgUrl != null) {
      await imageFile?.writeAsBytes(await _image!.readAsBytes());
      // final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // final File imageFile = File('${directory!.path}/$fileName.jpg');
      // final String imgUrl = '/users/${widget.uid}/images/$fileName.jpg';
      // if (_image != null) {
      // }
      // await GallerySaver.saveImage(imageFile.path);
      // if (_formKey.currentState!.validate()) {
      NoteModel note = NoteModel(
        id: widget.note != null ? widget.note!.id : DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        userId: widget.uid,
        imgUrl: imgUrl as String,
      );
      if (widget.note != null) {
        await noteController.updateNote(widget.uid, note, imgUrl as String);
        if (imgUrlOld != imgUrl) {
          await noteController.deleteImage(imgUrlOld as String);
          await noteController.uploadImage(
              widget.uid, imageFile!, imgUrl as String);
        }
      } else {
        // await noteController.addNote(widget.uid, note, imageFile: _image);
        await noteController.addNote(widget.uid, note);
        await noteController.uploadImage(
            widget.uid, imageFile!, imgUrl as String);
      }
      Navigator.pop(context, true);
      // Navigator.pop(context,
      //     MaterialPageRoute(builder: (context) => Tree(uid: widget.uid)));
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Tree(uid: widget.uid),
      //   ),
      // );
      // }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Gagal Melakukan Aksi!'),
            content: const Text('Pastikan Anda Mengisi Semua Form!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarColor: AppStyle.mainColor,
            toolbarTitle: 'Crop Image',
            statusBarColor: AppStyle.mainColor,
            backgroundColor: AppStyle.bgColor,
            cropFrameColor: AppStyle.mainColor,
            cropGridColor: AppStyle.mainColor.withOpacity(0.5),
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: false,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
          // imgUrl = croppedFile.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppStyle.bgColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppStyle.primaryColor.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(0, 0),
                                )
                              ],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  color: AppStyle.mainColor),
                            ),
                          ),
                          Container(
                            // ignore: prefer_const_constructors
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Catatan',
                              style: AppStyle.mainTitle,
                            ),
                          )
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: AppStyle.bgColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppStyle.primaryColor
                                            .withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 5,
                                        offset: const Offset(0, 0),
                                      )
                                    ],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _image == null && widget.note == null
                                          // _image == null
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Text(
                                                'Gambar',
                                                style: AppStyle.mainTitle,
                                              ),
                                            )
                                          // : Image.file(_image!),
                                          : _image == null
                                              ? FutureBuilder(
                                                  future: noteController
                                                      .getImageUrl(
                                                          widget.note!.imgUrl),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<String>
                                                              snapshot) {
                                                    if (snapshot.connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        snapshot.hasData) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              snapshot.data
                                                                  as String),
                                                          width:
                                                              double.infinity,
                                                        ),
                                                      );
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  },
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.file(_image!)),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                textStyle: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppStyle.bgColor,
                                                ),
                                                backgroundColor:
                                                    AppStyle.mainColor,
                                              ),
                                              onPressed: () {
                                                _getImage(ImageSource.camera);
                                              },
                                              child: Icon(Icons.camera,
                                                  color: AppStyle.bgColor),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                textStyle: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppStyle.bgColor,
                                                ),
                                                backgroundColor:
                                                    AppStyle.mainColor,
                                              ),
                                              onPressed: () {
                                                _getImage(ImageSource.gallery);
                                              },
                                              child: Icon(
                                                  Icons.collections_rounded,
                                                  color: AppStyle.bgColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Tuliskan judul anda',
                                      labelText: 'Judul',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyle.mainColor,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                      filled: true,
                                      fillColor: AppStyle.bgColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppStyle.mainColor,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: AppStyle.mainColor,
                                            width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: AppStyle.accentColor,
                                            width: 1),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: AppStyle.accentColor,
                                            width: 2),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Harap masukkan judul';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: 'Tuliskan deskripsi anda',
                                      labelText: 'Deskripsi',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyle.mainColor,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                      filled: true,
                                      fillColor: AppStyle.bgColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: AppStyle.mainColor,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: AppStyle.mainColor,
                                            width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: AppStyle.accentColor,
                                            width: 1),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: AppStyle.accentColor,
                                            width: 2),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 16),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Harap masukkan deskripsi';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                      onPressed: saveNote,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.bgColor,
                        ),
                        backgroundColor: AppStyle.mainColor,
                      ),
                      child: Text(
                        'Simpan',
                        style: AppStyle.mainTitle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
