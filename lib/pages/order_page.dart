import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'orderdetail.dart'; // Import OrderDetailsPage

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late String currentUserEmail;
  late List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserEmail = user.email!;
      });

      try {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('Orders_list')
                .where('customerId', isEqualTo: currentUserEmail)
                .get();

        List<Map<String, dynamic>> fetchedOrders =
            querySnapshot.docs.map((doc) => doc.data()).toList();

        setState(() {
          orders = fetchedOrders;
        });
      } catch (e) {
        print('Error fetching orders: $e');
        // Handle error fetching orders
      }
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('Orders_list').doc(orderId).delete();
      // Refresh the orders list after deletion
      fetchOrders();
    } catch (e) {
      print('Error deleting order: $e');
      // Handle error deleting order
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสั่งซื้อของฉัน'),
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders found'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                String deliveryStatus = orders[index]['deliveryStatus'];

                return Dismissible(
                  key: Key(orders[index]['orderId']), // Ensure unique key
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      if (deliveryStatus == 'waiting' || deliveryStatus == 'pending') {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ยืนยันการลบ'),
                              content: Text('คุณต้องการที่จะลบรายการสั่งซื้อนี้หรือไม่?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteOrder(orders[index]['orderId']);
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('ยืนยัน'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Show a message that it cannot be deleted
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ไม่สามารถลบรายการที่มีสถานะ "จัดส่งแล้ว" ได้'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    // No action needed as we handle deletion in confirmDismiss
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text('รหัสการสั่งซื้อ: ${orders[index]['orderId']}'),
                      subtitle: Text('ราคารวม: ${orders[index]['totalPrice']}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsPage(order: orders[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrdersPage(),
  ));
}
