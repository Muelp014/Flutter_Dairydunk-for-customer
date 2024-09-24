import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverProfilePage extends StatelessWidget {
  final String orderId;

  const DriverProfilePage({Key? key, required this.orderId}) : super(key: key);

  Future<Map<String, dynamic>?> fetchDriverProfile(String orderId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> orderDoc = await FirebaseFirestore.instance
          .collection('Order_list')
          .doc(orderId)
          .get();

      if (orderDoc.exists) {
        String? acceptedBy = orderDoc.data()?['acceptedBy'];

        if (acceptedBy != null) {
          DocumentSnapshot<Map<String, dynamic>> driverDoc = await FirebaseFirestore.instance
              .collection('Employee')
              .doc(acceptedBy)
              .get();

          if (driverDoc.exists) {
            return driverDoc.data();
          } else {
            print('Driver document does not exist');
            return null;
          }
        } else {
          print('AcceptedBy field is null');
          return null;
        }
      } else {
        print('Order document does not exist');
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
            return Center(child: Text('เกิดข้อผิดพลาดในการดึงข้อมูลโปรไฟล์คนขับ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('ไม่พบโปรไฟล์สำหรับคำสั่งซื้อนี้'));
          } else {
            Map<String, dynamic> profile = snapshot.data!;

            String driverName = profile['name'] ?? 'ไม่ทราบชื่อ';
            String driverPhone = profile['phoneNumber'] ?? 'ไม่ทราบเบอร์';
            String vehicleDetails = profile['vehicleType'] ?? 'ไม่ทราบประเภท';
            String licenseNumber = profile['licenseNumber'] ?? 'ไม่ทราบเลขทะเบียน';
            String profileImageUrl = profile['profileImageUrl'] ?? '';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (profileImageUrl.isNotEmpty)
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                  if (profileImageUrl.isNotEmpty)
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
                        SizedBox(height: 10),
                        Text('เลขทะเบียน: $licenseNumber'),
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    if (await canLaunch(telScheme)) {
      await launch(telScheme);
    } else {
      throw 'ไม่สามารถโทรออกได้ $telScheme';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: DriverProfilePage(orderId: 'your_order_id'),
  ));
}
