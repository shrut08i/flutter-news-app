class NewsArticle {

  final String title;
  final String description;
  final String imageUrl;
  final String source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {

    return NewsArticle(
      title: json['title'] ?? "No title available",

      description: json['description'] ?? "No description available",

      imageUrl: json['urlToImage'] ??
          "https://via.placeholder.com/400x200.png?text=No+Image",

      source: json['source']?['name'] ?? "Unknown source",
    );
  }
}