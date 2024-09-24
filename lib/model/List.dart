// lib/model/resturant.dart

import 'dart:math';
import 'package:DairyDunk/data/proddata.dart';
import 'package:DairyDunk/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'Product.dart';
import 'cartitem.dart';

class Resturant extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Product> _menu = productMenu;
  final List<Cartitem> _cart = [];

  List<Product> get menu => _menu;
  List<Cartitem> get cart => _cart;

  void addToCart(Product product) {
    Cartitem? cartitem = _cart.firstWhereOrNull((item) {
      bool isSameProduct = item.product == product;
      return isSameProduct;
    });

    if (cartitem != null) {
      cartitem.quantity++;
    } else {
      _cart.add(
        Cartitem(
          product: product,
        ),
      );
    }
    notifyListeners();
  }
  Future<void> updateStock(List<Cartitem> cartItems) async {
    WriteBatch batch = _firestore.batch();

    for (var cartItem in cartItems) {
      String productName = cartItem.product.name;

      DocumentReference productRef =
          _firestore.collection('products').doc(productName);

      batch.update(productRef, {
        'stock': FieldValue.increment(-cartItem.quantity),
      });
    }

    try {
      await batch.commit();
      print('Stock updated successfully');
    } catch (e) {
      print('Error updating stock: $e');
      throw e;
    }
  }

   Future<int> fetchStock(String productName) async {
    try {
      DocumentSnapshot productDoc = await _firestore
          .collection('products')
          .doc(productName)
          .get();

      if (productDoc.exists) {
        return productDoc['stock'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching stock: $e');
      return 0;
    }
  }
  void removeFromCart(Cartitem cartitem) {
    int cartIndex = _cart.indexOf(cartitem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (Cartitem cartitem in _cart) {
      total += cartitem.product.price * cartitem.quantity;
    }
    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;
    for (Cartitem cartitem in _cart) {
      totalItemCount += cartitem.quantity;
    }
    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    String formatDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    receipt.writeln('Date: $formatDate');
    receipt.writeln();
    receipt.writeln("__________________");

    for (Cartitem cartitem in _lastOrderCart) {
      receipt.writeln(
          '${cartitem.product.name} x ${cartitem.quantity} - ${_formatPrice(cartitem.product.price * cartitem.quantity)}');
    }

    receipt.writeln("__________________");
    receipt.writeln();
    receipt.writeln("Total Item: ${_lastOrderCart.length}");
    receipt.writeln(
        'Total Price: ${_formatPrice(_lastOrderCart.fold(0.0, (total, cartitem) => total + cartitem.product.price * cartitem.quantity))}');
    return receipt.toString();
  }

  String _formatPrice(double price) {
    return "\฿${price.toStringAsFixed(2)}";
  }

  List<Cartitem> _lastOrderCart = [];

  Future<void> sendOrderToFirestore(String location) async {
  try {
    final int paymentId =
        Random().nextInt(900) + 100; // Generate 3-digit payment ID
    final int orderId =
        Random().nextInt(9000) + 1000; // Generate 4-digit order ID

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('customer')
        .doc(user.email)
        .get();

    if (!userDoc.exists) {
      throw Exception('User profile not found');
    }

    UserProfile userProfile =
        UserProfile.fromMap(userDoc.data() as Map<String, dynamic>);

    CollectionReference Orders_list =
        FirebaseFirestore.instance.collection('Orders_list');

    List<Map<String, dynamic>> itemsData = _cart
        .map((cart) => {
              'productName': cart.product.name,
              'quantity': cart.quantity,
              'price per unit': cart.product.price,
            })
        .toList();

    double totalPrice = getTotalPrice();

    // เพิ่มหมายเลขโทรศัพท์จากข้อมูลผู้ใช้
    String phoneNumber = userProfile.phoneNumber;

    Map<String, dynamic> orderData = {
      'orderId': orderId.toString(),
      'timestamp': FieldValue.serverTimestamp(),
      'paymentId': paymentId.toString(),
      'items': itemsData,
      'totalPrice': totalPrice,
      'deliveryStatus': 'waiting', // Set initial status to "waiting"
      'location': location,
      'customerId': userProfile.uid,
      'customerName': userProfile.name,
      'customerPhoneNumber': phoneNumber, // เพิ่มหมายเลขโทรศัพท์
      'acceptedBy': 'waiting', // Set acceptedBy to "waiting"
    };

    await Orders_list.doc(orderId.toString()).set(orderData);

    _lastOrderCart = List.from(_cart);
    clearCart();
  } catch (e) {
    print('Error sending order: $e');
    throw e;
  }
}

}
