import 'package:DairyDunk/pages/DriversListPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดคำสั่งซื้อ'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('รหัสการสั่งซื้อ: ${order['orderId']}'),
            SizedBox(height: 10),
            Text('ชื่อลูกค้า: ${order['customerName']}'),
            SizedBox(height: 10),
            Text('สถานะการจัดส่ง: ${_getDeliveryStatusText(order['deliveryStatus'])}'),
            SizedBox(height: 10),
            Text('ที่ตั้ง: ${order['location']}'),
            SizedBox(height: 10),
            Text('รหัสการชำระเงิน: ${order['paymentId']}'),
            SizedBox(height: 10),
            Text('เวลาที่สั่ง: ${order['timestamp'].toDate()}'),
            SizedBox(height: 10),
            Text('ราคารวม: ${order['totalPrice']} บาท'),
            SizedBox(height: 20),
            Text('รายการสินค้า:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: order['items'].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${order['items'][index]['productName']}'),
                  subtitle: Text('จำนวน: ${order['items'][index]['quantity']}'),
                  trailing: Text(
                      'ราคาต่อหน่วย: ${order['items'][index]['price per unit']} บาท'),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'ราคารวมทั้งหมด: ${order['totalPrice']} บาท',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  String _getDeliveryStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'กำลังรอจัดส่ง';
      case 'pending':
        return 'รอการยืนยัน';
      case 'Paid':
        return 'จัดส่งแล้ว';
      case 'complete':
        return 'สำเร็จแล้ว';
      default:
        return 'สถานะไม่ทราบ';
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ข้อมูลผู้จัดส่ง',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ), // Display driver's name
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    // Navigate to DriverProfilePage using acceptedBy
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DriverProfilePage(
                          acceptedBy: order['acceptedBy'],
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    // Make a phone call (replace with actual phone number)
                    _makePhoneCall('tel:+1234567890');
                  },
                  icon: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'ไม่สามารถโทรออกได้ $url';
    }
  }
}

class DriverProfilePage extends StatelessWidget {
  final String acceptedBy;

  const DriverProfilePage({Key? key, required this.acceptedBy}) : super(key: key);

  Future<Map<String, dynamic>?> fetchDriverProfile(String acceptedBy) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> driverDoc = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(acceptedBy)
          .get();

      if (driverDoc.exists) {
        return driverDoc.data();
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
        future: fetchDriverProfile(acceptedBy),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาดในการดึงข้อมูลโปรไฟล์คนขับ'));
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
