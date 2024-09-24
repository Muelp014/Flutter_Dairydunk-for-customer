import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentStatusScreen extends StatefulWidget {
  final String paymentId;

  PaymentStatusScreen({required this.paymentId});

  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  String status = 'Loading...';

  @override
  void initState() {
    super.initState();
    checkPaymentStatus();
  }

  void checkPaymentStatus() async {
    try {
      String apiUrl = 'YOUR_PROMPTPAY_API_URL'; // เปลี่ยนเป็น URL ของ PromptPay API ที่ใช้
      var response = await http.get(Uri.parse('$apiUrl/${widget.paymentId}'));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        String paymentStatus = jsonData['status']; // ปรับตาม JSON ที่ API คืนกลับมา
        setState(() {
          status = 'Payment status: $paymentStatus';
        });

        if (paymentStatus == 'paid') {
          // ทำการจัดส่งสินค้าหรือบริการต่อไป
          // ตัวอย่าง: Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreen()));
        }
      } else {
        setState(() {
          status = 'Failed to load payment status';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Status'),
      ),
      body: Center(
        child: Text(
          status,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
