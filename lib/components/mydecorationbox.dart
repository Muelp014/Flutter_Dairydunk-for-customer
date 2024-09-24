import "package:flutter/material.dart";
import "package:DairyDunk/model/List.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class Mydecorationbox extends StatelessWidget {
  const Mydecorationbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var myPrimaryTextStyle =
        TextStyle(color: Theme.of(context).colorScheme.inversePrimary);
    var mySecondaryTextStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //derivery day
          Column(
            children: [
              Text(
                DateFormat('EEEE dd/MM/yyyy').format(DateTime.now()),
                style: myPrimaryTextStyle,
              ),
            ],
          ),
           Column(
            children: [
              Consumer<Resturant>(
                builder: (context, restaurant, child) {
                  return Text(
                    'Total price ${restaurant.getTotalPrice()}',
                    style: mySecondaryTextStyle,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}