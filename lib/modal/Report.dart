class Report {
  final String reportId;
  final String userId;
  final String doctorId;
  final String appointmentId;
  final String description;
  final String image;
  final DateTime checkupTime;

  Report({
    required this.reportId,
    required this.userId,
    required this.doctorId,
    required this.appointmentId,
    required this.description,
    required this.image,
    required this.checkupTime,
  });

  factory Report.fromMap(Map<String, dynamic> data, String documentId) {
    return Report(
      reportId: documentId,
      userId: data['userId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      appointmentId: data['appointmentId'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      checkupTime: (data['checkupTime']).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'userId': userId,
      'doctorId': doctorId,
      'appointmentId': appointmentId,
      'description': description,
      'image': image,
      'checkupTime': checkupTime,
    };
  }
}
