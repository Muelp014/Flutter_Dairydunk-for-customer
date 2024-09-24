import 'package:flutter/material.dart';
import 'package:DairyDunk/model/List.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Myrecipt extends StatelessWidget {
  const Myrecipt({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate estimated delivery time
    DateTime now = DateTime.now();
    DateTime estimatedDeliveryTime = now.add(Duration(minutes: 30));
    String formattedTime = DateFormat('HH:mm').format(estimatedDeliveryTime);

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Thank you for your order"),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Consumer<Resturant>(
                builder: (context, resturant, child) =>
                    Text(resturant.displayCartReceipt()),
              ),
            ),
            const SizedBox(height: 25),
            Text("Estimated delivery time is: $formattedTime")
          ],
        ),
      ),
    );
  }
}
