class LoanApplication {
  String borrowerName;
  String loanAmount;
  String loanPurpose;
  String status;

  LoanApplication(
      {required this.borrowerName,
      required this.loanAmount,
      required this.loanPurpose,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'borrowerName': borrowerName,
      'loanAmount': loanAmount,
      'loanPurpose': loanPurpose,
      'status': status
    };
  }

  factory LoanApplication.fromMap(Map<String, dynamic> map) {
    return LoanApplication(
      borrowerName: map['borrowerName'],
      loanAmount: map['loanAmount'],
      loanPurpose: map['loanPurpose'],
      status: map['status'],
    );
  }
}
