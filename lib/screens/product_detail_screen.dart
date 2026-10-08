import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/category_badge.dart';
import '../widgets/star_rating.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isBookmarked = false;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover image with bookmark badge (Stack)
                  _buildCoverImage(product),
                  // Product info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category badges (Wrap)
                        _buildCategoryBadges(product),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Rating and reviews (Row)
                        _buildRatingRow(product),
                        const SizedBox(height: 16),
                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Quantity selector
                        _buildQuantitySelector(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom sticky action bar
          _buildBottomBar(product),
        ],
      ),
    );
  }

  /// Cover image with Stack overlay: bookmark badge + gradient
  Widget _buildCoverImage(Product product) {
    return Stack(
      children: [
        // Product image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 80, color: Colors.grey),
            ),
          ),
        ),
        // Gradient overlay at top for status bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black45, Colors.transparent],
              ),
            ),
          ),
        ),
        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: _circleButton(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        // Bookmark badge
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: _circleButton(
            icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: _isBookmarked ? Colors.amber : Colors.white,
            onTap: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  /// Category badges using Wrap for responsive layout
  Widget _buildCategoryBadges(Product product) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: product.categories
          .map((category) => CategoryBadge(label: category))
          .toList(),
    );
  }

  /// Star rating row
  Widget _buildRatingRow(Product product) {
    return Row(
      children: [
        StarRating(rating: product.rating),
        const SizedBox(width: 8),
        Text(
          product.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${product.reviewCount} reviews)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Quantity selector with StatefulWidget interactivity
  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _quantityButton(Icons.remove, () {
                if (_quantity > 1) setState(() => _quantity--);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _quantityButton(Icons.add, () {
                setState(() => _quantity++);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20),
      ),
    );
  }

  /// Bottom sticky action bar with "Add to Cart" button
  Widget _buildBottomBar(Product product) {
    final total = product.price * _quantity;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total price
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Add to Cart button — Expanded fills remaining width
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added $_quantity x ${product.title} to cart',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
