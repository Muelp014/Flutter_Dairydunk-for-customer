import 'package:DairyDunk/components/mycurrentlocation.dart';
import 'package:flutter/material.dart';
import 'package:DairyDunk/model/cartitem.dart';
import 'package:DairyDunk/pages/home_page.dart';
import 'package:DairyDunk/model/List.dart'; // Import Resturant class
import 'package:provider/provider.dart'; // Import provider package

class Paymentpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ยืนยันการสั่งซื้อ'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Consumer<Resturant>(
              builder: (context, resturant, child) {
                // Access cart items from resturant.cart
                List<Cartitem> cartItems = resturant.cart;

                // Calculate total price
                double totalPrice = cartItems.fold(
                    0, (previousValue, cartItem) => previousValue + cartItem.product.price * cartItem.quantity);

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ยืนยันการสั่งซื้อ',
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20.0),
                      // Display each item in the cart
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          Cartitem cartItem = cartItems[index];
                          return ListTile(
                            title: Text(cartItem.product.name),
                            subtitle: Text('Quantity: ${cartItem.quantity}'),
                            trailing: Text('Price: ${cartItem.product.price}'),
                          );
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'ยอดรวมทั้งหมด: $totalPrice บาท',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          // Get location data from Mycurrentlocation widget
                          String location = await Mycurrentlocation.getAddressData();

                          try {
                            // Update stock in Paymentpage
                            await resturant.updateStock(cartItems);

                            await resturant.sendOrderToFirestore(location);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          } catch (e) {
                            print('Error sending order: $e');
                            // Handle error appropriately
                          }
                        },
                        child: Text('ยืนยัน'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
