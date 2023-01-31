import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup {
  final String? id;
  late String? name;
  late String? leader;
  late List<String>? members;
  late Timestamp? groupCreated;

  OurGroup({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
  });
}
