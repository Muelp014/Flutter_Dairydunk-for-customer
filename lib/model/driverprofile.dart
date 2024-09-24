// models/driver_profile.dart

class DriverProfile {
  final String name;
  final String phone;
  final String vehicleDetails;
  final String status;

  DriverProfile({
    required this.name,
    required this.phone,
    required this.vehicleDetails,
    required this.status,
  });

  factory DriverProfile.fromMap(Map<String, dynamic> data) {
    return DriverProfile(
      name: data['driverName'] ?? '',
      phone: data['driverPhone'] ?? '',
      vehicleDetails: data['vehicleDetails'] ?? '',
      status: data['status'] ?? '',
    );
  }
}
