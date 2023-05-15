import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbase/model/note_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NoteController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<NoteModel>> getNotes(String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .get();

    List<NoteModel> notes = querySnapshot.docs.map((documentSnapshot) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      return NoteModel.fromMap(data ?? {});
    }).toList();

    return notes;
  }

  Future<void> addNote(String userId, NoteModel note) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  Future<String> uploadImage(String userId, File imageFile, String path) async {
    // Menentukan path penyimpanan file di Firebase Storage
    // String path =
    //     'users/$userId/images/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Membuat referensi file di Firebase Storage
    Reference storageRef = storage.ref().child(path);

    // Mengunggah file ke Firebase Storage
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    // Mendapatkan URL dari file yang diunggah
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Mengembalikan URL dari file yang diunggah
    return downloadUrl;
  }

  Future<void> deleteImage(String path) async {
    final Reference ref = FirebaseStorage.instance.ref().child(path);
    await ref.delete();
  }

  Future<String> getImageUrl(String imagePath) async {
    // Future<String> getImageUrl() async {
    Reference ref = storage.ref().child(imagePath);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateNote(String userId, NoteModel note, String path) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
