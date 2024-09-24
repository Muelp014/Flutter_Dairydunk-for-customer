import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverProfilePage extends StatelessWidget {
  final String orderId;

  const DriverProfilePage({Key? key, required this.orderId}) : super(key: key);

  Future<Map<String, dynamic>?> fetchDriverProfile(String orderId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
          .collection('deliprogress')
          .doc(orderId)
          .get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching driver profile: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์คนขับ'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchDriverProfile(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาดในการดึงข้อมูลโปรไฟล์คนขับ'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('ไม่พบโปรไฟล์สำหรับคำสั่งซื้อนี้'));
          } else {
            Map<String, dynamic> profile = snapshot.data!['driverProfile'];

            String driverName = profile['name'] ?? 'ไม่ทราบชื่อ';
            String driverPhone = profile['phoneNumber'] ?? 'ไม่ทราบเบอร์';
            String vehicleDetails = profile['vehicleType'] ?? 'ไม่ทราบประเภท';
            String status = profile['status'] ?? 'ไม่ทราบสถานะ'; // Ensure 'status' is part of the document

            String profileImageUrl = profile['profileImageUrl'];

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ชื่อคนขับ: $driverName'),
                        SizedBox(height: 10),
                        Text('เบอร์โทรคนขับ: $driverPhone'),
                        SizedBox(height: 10),
                        Text('ประเภทยานพาหนะ: $vehicleDetails'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _makePhoneCall(driverPhone);
                    },
                    child: Text('โทรหาคนขับ'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    if (await canLaunch(telScheme)) {
      await launch(telScheme);
    } else {
      throw 'ไม่สามารถโทรออกได้ $telScheme';
    }
  }
}
