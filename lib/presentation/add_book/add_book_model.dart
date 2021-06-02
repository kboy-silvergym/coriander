import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coriander/domain/book.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle = '';
  File imageFile;
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addBookToFirebase() async {
    if (bookTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }
    final imageURL = await _uploadImageFile();

    FirebaseFirestore.instance.collection('books').add(
      {
        'title': bookTitle,
        'imageURL': imageURL,
        'createdAt': Timestamp.now(),
      },
    );
  }

  setImage(File imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }

  Future<String> _uploadImageFile() async {
    if (imageFile == null) {
      return '';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('books').child(bookTitle);
    final snapshot = await ref
        .putFile(
          imageFile,
        )
        .snapshot;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future updateBook(Book book) async {
    final imageURL = await _uploadImageFile();
    final document =
        FirebaseFirestore.instance.collection('books').doc(book.documentID);
    await document.update(
      {
        'title': bookTitle,
        'imageURL': imageURL,
        'updateAt': Timestamp.now(),
      },
    );
  }
}
