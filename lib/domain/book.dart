import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book(DocumentSnapshot doc) {
    documentID = doc.id;

    final data = doc.data() as Map<String, Object>;
    title = data['title'];
    imageURL = data['imageURL'];
  }

  String documentID;
  String title;
  String imageURL;
}
