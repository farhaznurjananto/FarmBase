import 'package:farmbase/controller/note_controller.dart';
import 'package:farmbase/utils.dart';
import 'package:farmbase/view/note/note_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:farmbase/model/note_model.dart';

class NoteIndexScreen extends StatefulWidget {
  // const NoteIndexScreen({super.key});
  final String uid;
  const NoteIndexScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<NoteIndexScreen> createState() => _NoteIndexScreenState();
}

class _NoteIndexScreenState extends State<NoteIndexScreen> {
  NoteController noteController = NoteController();
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    List<NoteModel> notes = await noteController.getNotes(widget.uid);
    setState(() {
      this.notes = notes;
    });
  }

  void deleteNote(String noteId) async {
    await noteController.deleteNote(widget.uid, noteId);
    setState(() {
      notes.removeWhere((note) => note.id == noteId);
    });
  }

  dynamic selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppStyle.mainColor,
                        child: Icon(Icons.description_rounded,
                            color: AppStyle.bgColor),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Catatan Harian Anda',
                          style: AppStyle.mainTitle,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 590,
                  child: notes.isNotEmpty
                      ? ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: AppStyle.bgColor,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppStyle.primaryColor.withOpacity(0.1),
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
                                children: [
                                  Container(
                                    // child: IconButton(
                                    //   icon: Icon(Icons.delete),
                                    //   onPressed: () {
                                    //     deleteNote(note.id);
                                    //   },
                                    // ),
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/img-card.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              note.title,
                                              style: GoogleFonts.poppins(
                                                fontSize: 24,
                                                fontWeight: FontWeight.normal,
                                                color: AppStyle.mainColor,
                                              ),
                                            ),
                                            PopupMenuButton(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'update',
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: const [
                                                      Icon(Icons.edit,
                                                          color: Colors.blue),
                                                      Text('Update'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: const [
                                                      Icon(Icons.delete,
                                                          color: Colors.red),
                                                      Text('Hapus'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) {
                                                if (value == "delete") {
                                                  deleteNote(note.id);
                                                } else if (value == "update") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NoteCreateScreen(
                                                              uid: widget.uid,
                                                              note: note,
                                                            )),
                                                  ).then((value) {
                                                    if (value != null) {
                                                      getNotes();
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        Text(
                                          note.description,
                                          style: AppStyle.mainDescription,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            children: [
                              Image.asset('assets/images/not_found.png',
                                  height: 280),
                              Text(
                                'Belum ada catatan',
                                style: AppStyle.mainDescription,
                              ),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteCreateScreen(
                      uid: widget.uid,
                    )),
          ).then((value) {
            if (value != null) {
              getNotes();
            }
          });
        },
        backgroundColor: AppStyle.mainColor,
        label: Row(
          children: [
            const Icon(Icons.mode_edit_rounded),
            const SizedBox(width: 10),
            Text(
              'Buat Catatan',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppStyle.bgColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class NoteIndexScreen extends StatefulWidget {
//   final String uid;
//   const NoteIndexScreen({Key? key, required this.uid}) : super(key: key);

//   @override
//   State<NoteIndexScreen> createState() => _NoteIndexScreenState();
// }

// class _NoteIndexScreenState extends State<NoteIndexScreen> {
//   NoteController noteController = NoteController();
//   List<NoteModel> notes = [];

//   @override
//   void initState() {
//     super.initState();
//     getNotes();
//   }

//   void getNotes() async {
//     List<NoteModel> notes = await noteController.getNotes(widget.uid);
//     setState(() {
//       this.notes = notes;
//     });
//   }

//   void deleteNote(String noteId) async {
//     await noteController.deleteNote(widget.uid, noteId);
//     setState(() {
//       notes.removeWhere((note) => note.id == noteId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//       ),
//       body: ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return ListTile(
//             title: Text(note.title),
//             subtitle: Text(note.description),
//             trailing: IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 deleteNote(note.id);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NoteCreateScreen(
//                 uid: widget.uid,
//               ),
//             ),
//           ).then((value) {
//             if (value != null) {
//               getNotes();
//             }
//           });
//         },
//       ),
//     );
//   }
// }
