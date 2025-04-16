class Guest {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool checkedIn;
  final String status;

  Guest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.checkedIn,
    required this.status,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      checkedIn: json['checked_in'],
      status: json['status'],
    );
  }

  String get fullName => '$firstName $lastName';
}
