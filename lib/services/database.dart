import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:join_create_group_functionality/models/users.dart';

class OurDatabse {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> createUser(OurUser user) async {
    String retVal = 'error';

    try {
      await firebaseFirestore.collection('users').doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'dateCreated': Timestamp.now(),
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();

    try {
      DocumentSnapshot docSnapshot =
          await firebaseFirestore.collection('users').doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = docSnapshot['fullName'];
      retVal.email = docSnapshot['email'];
      retVal.dateCreated = docSnapshot['dateCreated'];
      retVal.grouId = docSnapshot['groupId'];
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> createGroup(String groupName, String userUid) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      DocumentReference documentReference =
          await firebaseFirestore.collection('groups').add({
        'name': groupName,
        'leader': userUid,
        'members': members,
        'groupCreated': Timestamp.now(),
      });

      await firebaseFirestore.collection('users').doc(userUid).update({
        'groupId': documentReference.id,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> joinGroup(String groupId, String userUid) async {
    String retVal = 'error';
    List<String> members = [];

    try {
      members.add(userUid);
      await firebaseFirestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
      });

      await firebaseFirestore.collection('users').doc(userUid).update({
        'groupId': groupId,
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }

    return retVal;
  }
}
