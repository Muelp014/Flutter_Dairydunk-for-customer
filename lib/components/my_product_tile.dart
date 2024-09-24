import 'package:flutter/material.dart';
import 'package:DairyDunk/model/Product.dart';

class MyProductTile extends StatelessWidget {
  final Product product;
  final void Function()? onTap;

  const MyProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // เพิ่ม Padding ที่นี่
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.price.toString() + '\฿',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        product.description,
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.9),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                // image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product.imagepath,
                    height: 120,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.tertiary,
            endIndent: 25,
            indent: 25,
          ),
        ],
      ),
    );
  }
}
