class Product {
  final String title;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> categories;

  const Product({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.categories,
  });
}
