import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  late String? uid;
  late String? email;
  late String? fullName;
  late Timestamp? dateCreated;
  late String? groupId;

  OurUser({
    this.uid,
    this.email,
    this.fullName,
    this.dateCreated,
    this.groupId,
  });
}
