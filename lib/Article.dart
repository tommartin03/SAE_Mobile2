class Article {
  final int id;
  final String title;
  final String image;
  final String description;
  final double price;
  int quantite;

  Article({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    this.quantite = 1, // default value is 1
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
    );
  }

  factory Article.fromJsonWithQuantite(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      quantite: json['quantite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'description': description,
      'price': price,
      'quantite': quantite,
    };
  }
}
