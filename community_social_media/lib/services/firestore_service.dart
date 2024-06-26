import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_social_media/models/event_model.dart';
import 'package:community_social_media/models/post_model.dart';
import 'package:community_social_media/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final firestoreService = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future<void> createUser(UserModel userModel) async {
    print("girdi");
    await firestoreService
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .set(userModel.toJson());
  }

  Future<UserModel> getUser() async {
    try {
      var docRef = await firestoreService
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      var user = UserModel.fromJson(docRef.data()!);
      return user;
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> createPost(PostModel postModel) async {
    var docId = firestoreService.collection("posts").doc().id;
    postModel.postId = docId;
    await firestoreService
        .collection("posts")
        .doc(docId)
        .set(postModel.toJson());
  }

  Future<String> uploadImage(File fileName) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var taskSnapshot =
        await storage.ref().child('post_images/$imageName').putFile(fileName);
    var url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> getUserName() async {
    var data = await firestoreService
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return data.data()!['userName'];
  }

  Future<List<PostModel>> getPosts() async {
    var data =
        await firestoreService.collection("posts").orderBy("timestamp").get();
    var datav2 = data.docs;
    var datav3 = datav2.map((e) => PostModel.fromJson(e.data())).toList();
    return datav3;
  }

  Future<List<PostModel>> getPostsOfUser() async {
    var data = await firestoreService
        .collection("posts")
        .where("userId", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    var datav2 = data.docs;
    var datav3 = datav2.map((e) => PostModel.fromJson(e.data())).toList();
    return datav3;
  }

  Future<void> addUserIdToLikes(String docId) async {
    firestoreService.collection("events").doc(docId).update({
      'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  Future<void> deleteUserIdFromLikes(String docId) async {
    firestoreService.collection("events").doc(docId).update({
      'likes': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  Future<void> createEvent(EventModel newEvent) async {
    var docRef = firestoreService.collection("events").doc();
    newEvent.eventId = docRef.id;
    await docRef.set(newEvent.toJson());
  }

  Future<List<EventModel>> getEvent(bool bringHistory) async {
    try {
      List<EventModel> events = List<EventModel>.empty(growable: true);

      var querySnapshot = await firestoreService
          .collection("events")
          .orderBy("eventDate",
              descending: bringHistory == false ? false : true)
          .get();
      for (var doc in querySnapshot.docs) {
        var event = EventModel.fromJson(doc.data());
        events.add(event);
      }
      return events;
    } catch (e) {
      throw Exception('Error : $e');
    }
  }
}
