class Doctor {
  final String id;
  final String image;
  final String name;
  final String username;
  final String experience;
  final String title;
  final String password;
  final String description;

  Doctor({
    required this.id,
    required this.image,
    required this.name,
    required this.username,
    required this.experience,
    required this.title,
    required this.password,
    required this.description,
  });

  factory Doctor.fromMap(Map<String, dynamic> data, String documentId) {
    final doctorDetails = data['doctor_details'] ?? {};
    return Doctor(
      id: documentId,
      image: doctorDetails['image'] ?? '',
      name: doctorDetails['name'] ?? '',
      username: doctorDetails['username'] ?? '',
      experience: doctorDetails['experiencedoctor'] ?? '',
      title: doctorDetails['doctorTitle'] ?? '',
      password: doctorDetails['password'] ?? '',
      description: doctorDetails['description'] ?? '',
    );
  }
}
