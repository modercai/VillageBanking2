import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup {
  final String? id;
  late String? name;
  late int? interestRate;
  late String? leader;
  late List<String>? members;
  late Timestamp? groupCreated;
  late Timestamp? cycleStartDate;

  OurGroup({
    this.id,
    this.name,
    this.interestRate,
    this.leader,
    this.members,
    this.groupCreated,
    this.cycleStartDate,
  });
}
