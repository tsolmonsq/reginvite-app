class Guest {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String status;
  final bool checkedIn;

  Guest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.status,
    required this.checkedIn,
  });

  String get fullName => '$firstName $lastName';

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      checkedIn: json['checked_in'] ?? false,
    );
  }
}
