import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String title;
  final String desc;
  final bool status;
  final String currency;
  final DocumentSnapshot lastDoc;

  Job({
    this.id,
    this.title,
    this.desc,
    this.status,
    this.currency,
    this.lastDoc,
  });

  factory Job.fromMap(
      Map<String, dynamic> map, String id, DocumentSnapshot lastDoc) {
    return Job(
      id: id,
      title: map['title'],
      currency: map['currency'],
      desc: map['description'],
      status: map['status'],
      lastDoc: lastDoc,
    );
  }
}