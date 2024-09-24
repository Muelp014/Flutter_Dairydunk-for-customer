import 'package:DairyDunk/model/List.dart';
import 'package:flutter/material.dart';
import 'package:DairyDunk/components/mycarttile.dart';
import 'package:DairyDunk/model/Product.dart';
import 'package:DairyDunk/model/cartitem.dart';
import 'package:DairyDunk/pages/paymentpage.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';

class MyCartPage extends StatelessWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Resturant>(
      builder: (context, resturant, child) {
        final userCart = resturant.cart;

        return Scaffold(
          appBar: AppBar(
            title: Text("ตะกร้าสินค้า"),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("คุณแน่ใจหรือไม่ว่าต้องการล้างตะกร้าสินค้า?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            resturant.clearCart();
                          },
                          child: Text('ยืนยัน'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: userCart.isEmpty
                    ? Center(
                        child: Text("ตะกร้าสินค้าว่างเปล่า..."),
                      )
                    : ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          final cartItem = userCart[index];
                          return Mycarttile(cartitem: cartItem);
                        },
                      ),
              ),
              MyButton(
                onTap: () async {
                  bool stockAvailable = true;
                  List<Cartitem> outOfStockItems = [];

                  for (var cartItem in userCart) {
                    int currentStock = await resturant.fetchStock(cartItem.product.name);
                    if (cartItem.quantity > currentStock) {
                      stockAvailable = false;
                      outOfStockItems.add(Cartitem(product: cartItem.product, quantity: currentStock));
                    }
                  }

                  if (stockAvailable) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Paymentpage()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('สินค้าไม่เพียงพอ'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: outOfStockItems.map((item) {
                            return Text('${item.product.name}: เหลือเพียง ${item.quantity} ชิ้น');
                          }).toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                text: "ไปที่หน้ายืนยันการสั่งซื่อ",
                color: Colors.red,
                textColor: Colors.white,
              ),
              SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyCartPage(),
  ));
}
