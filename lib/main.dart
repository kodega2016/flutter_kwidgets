import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reusefirebase/firestore_service.dart';

import 'job.dart';
import 'kfirebase_query_widgets.dart';
import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ReUseApp());
}

class ReUseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Re-Use',
      theme: ThemeData(primaryColor: Colors.green[800]),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loader'),
        centerTitle: true,
        elevation: 2.0,
        actions: [
          IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return UserLists();
                }));
              }),
        ],
      ),
      body: KFirebaseQueryWidget<Job>(
        perPage: 15,
        path: 'jobs',
        builder: (data, id, lastDoc) => Job.fromMap(data, id, lastDoc),
        doc: (List<Job> items) => items.last?.lastDoc,
        queryBuilder: (query) => query.where('status', isEqualTo: false),
        itemBuilder: (BuildContext context, Job item) {
          return Card(
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.status.toString()),
            ),
          );
        },
      ),
    );
  }
}

class UserLists extends StatelessWidget {
  const UserLists({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: KFirebaseQueryWidget<User>(
        perPage: 15,
        path: 'users',
        builder: (data, id, lastDoc) => User.fromMap(data, id, lastDoc),
        doc: (List<User> items) => items.last?.lastDoc,
        queryBuilder: (query) => query.where('gender', isEqualTo: 'Male'),
        itemBuilder: (BuildContext context, User item) {
          return Card(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item?.email ?? ''),
            ),
          );
        },
      ),
    );
  }
}
