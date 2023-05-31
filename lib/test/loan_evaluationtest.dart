import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:join_create_group_functionality/utils/loanmanagement/evaluation.dart';
import 'package:mockito/mockito.dart';
import 'package:join_create_group_functionality/states/current_user.dart';
import 'package:provider/provider.dart';

class MockCurrentUser extends Mock implements CurrentUser {}

class MockLoanApplication extends Mock implements LoanApplication {}

void main() {
  group('LoanEvaluationPage', () {
    late LoanEvaluationPage loanEvaluationPage;
    late MockCurrentUser mockCurrentUser;

    setUp(() {
      mockCurrentUser = MockCurrentUser();
      loanEvaluationPage = LoanEvaluationPage();
    });

    testWidgets('should load loan applications on initialization',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CurrentUser>.value(
            value: mockCurrentUser,
            child: loanEvaluationPage,
          ),
        ),
      );

      // Verify that _loadLoanApplications is called once
      verify(mockCurrentUser.getCurrentUser.groupId).called(1);
    });

    testWidgets('should call evaluateLoan when loan application is tapped',
        (WidgetTester tester) async {
      final loanApplication = MockLoanApplication();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<CurrentUser>.value(
            value: mockCurrentUser,
            child: loanEvaluationPage,
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));

      // Verify that evaluateLoan is called with the loan application
      verify(loanApplication.status).called(1);
    });

    // Add more test cases as needed
  });
}
