import 'package:flutter/material.dart';
import 'package:DairyDunk/components/myquantityselector.dart';
import 'package:DairyDunk/model/List.dart';
import 'package:DairyDunk/model/cartitem.dart';
import 'package:provider/provider.dart';

class Mycarttile extends StatelessWidget {
  final Cartitem cartitem;

  const Mycarttile({super.key, required this.cartitem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Resturant>(
        builder: (context, resturant, child) => Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            cartitem.product.imagepath,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        // Name and price
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartitem.product.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                cartitem.product.price.toString() + '\฿',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                              ),
                              const SizedBox(height: 10),
                              Quantityselec(
                                quantity: cartitem.quantity,
                                product: cartitem.product,
                                onDecrement: () {
                                  resturant.removeFromCart(cartitem);
                                },
                                onIncrement: () {
                                  resturant.addToCart(cartitem.product);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
