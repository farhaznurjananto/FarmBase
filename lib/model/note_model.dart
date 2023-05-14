class NoteModel {
  String id;
  String title;
  String description;
  String userId;

  NoteModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      userId: map['userId'],
    );
  }
}
