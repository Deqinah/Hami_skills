import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int itemCount;
  final VoidCallback onPressed;

  const CartBadge({
    Key? key,
    required this.itemCount,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: onPressed,
        ),
        if (itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                itemCount > 99 ? '99+' : itemCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}