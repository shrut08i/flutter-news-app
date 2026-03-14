import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/news_model.dart';

class DetailsScreen extends StatelessWidget {

  final NewsArticle article;

  const DetailsScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HERO IMAGE ANIMATION
            Hero(
              tag: article.imageUrl,
              child: CachedNetworkImage(
                imageUrl: article.imageUrl.isNotEmpty
                    ? article.imageUrl
                    : "https://via.placeholder.com/400",

                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,

                placeholder: (context, url) =>
                    const SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                errorWidget: (context, url, error) =>
                    Container(
                      height: 250,
                      color: Colors.grey,
                      child: const Icon(
                        Icons.broken_image,
                        size: 80,
                      ),
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// SOURCE
                  Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  Text(
                    article.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}