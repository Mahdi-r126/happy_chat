class Contact {
  final String name;
  final String contactToken;

  Contact({
    required this.name,
    required this.contactToken,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] ?? '',
      contactToken: json['token'] ?? '',
    );
  }
}
