import 'package:flutter/material.dart';
import 'models/product.dart';
import 'screens/product_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ProductDetailScreen(
        product: Product(
          title: 'Nike Air Max 270 React',
          imageUrl:
              'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
          price: 149.99,
          rating: 4.5,
          reviewCount: 238,
          description:
              'The Nike Air Max 270 React combines two of Nike\'s best '
              'technologies to create a shoe that\'s comfortable, lightweight, '
              'and stylish. The Air Max 270 unit delivers visible cushioning '
              'underfoot while React foam adds incredibly smooth comfort. '
              'Together, they keep you moving all day long.',
          categories: [
            'Sneakers',
            'Running',
            'Nike',
            'Best Seller',
            'New Arrival',
          ],
        ),
      ),
    );
  }
}
