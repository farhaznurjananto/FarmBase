import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbase/model/note_model.dart';

class NoteController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<void> updateNote(String userId, NoteModel note) async {
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
