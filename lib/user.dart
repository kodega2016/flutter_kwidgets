import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String gender;
  final DocumentSnapshot lastDoc;

  User({
    this.id,
    this.name,
    this.email,
    this.gender,
    this.lastDoc,
  });

  factory User.fromMap(
      Map<String, dynamic> map, String id, DocumentSnapshot lastDoc) {
    return User(
      id: id,
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      lastDoc: lastDoc,
    );
  }
}
