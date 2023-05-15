class NoteModel {
  String id;
  String title;
  String imgUrl; // TODO: add imgUrl
  String description;
  String userId;

  NoteModel(
      {required this.id,
      required this.title,
      required this.imgUrl, // TODO: add imgUrl
      required this.description,
      required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imgUrl': imgUrl, // TODO: add imgUrl
      'description': description,
      'userId': userId,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      imgUrl: map['imgUrl'], // TODO: add imgUrl
      description: map['description'],
      userId: map['userId'],
    );
  }
}
