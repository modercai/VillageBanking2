// ignore_for_file: must_be_immutable, subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:join_create_group_functionality/services/database.dart';


class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) {


    void main() {
  test('calculateLoanRepayment should calculate the remaining balance correctly', () async {
    // Arrange
    final groupId = 'group_id_123';
    final memberId = 'member_id_456';
    final interestRate = 0.1;
    final loanAmount = 1000;
    final paidAmount = 500;
    final expectedRemainingBalance = 600;

    final groupData = {
      'interest_rate': interestRate,
    };
    final memberData = {
      'loan_amount': loanAmount,
      'paid_amount': paidAmount,
    };

    final mockGroupRef = MockDocumentReference();
    when(mockGroupRef.get()).thenAnswer((_) async => MockDocumentSnapshot(groupData));

    final mockMemberRef = MockDocumentReference();
    when(mockMemberRef.get()).thenAnswer((_) async => MockDocumentSnapshot(memberData));

    when(FirebaseFirestore.instance.collection('groups').doc(groupId)).thenReturn(mockGroupRef);
    when(mockGroupRef.collection('user_transactions').doc(memberId)).thenReturn(mockMemberRef);

    // Act
    await OurDatabase().calculateLoanRepayment(groupId, memberId);

    // Assert
    verify(mockGroupRef.get()).called(1);
    verify(mockMemberRef.get()).called(1);
    verify(mockMemberRef.update({'remaining_balance': expectedRemainingBalance})).called(1);
  });
}
    return Future.value(MockDocumentSnapshot({}));
  }
}


class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;
  MockDocumentSnapshot(this._data);
  Map<String, dynamic> data() => _data;
}


