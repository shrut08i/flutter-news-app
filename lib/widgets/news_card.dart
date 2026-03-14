import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/news_model.dart';
import '../screens/details_screen.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailsScreen(article: article),

            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {

              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.all(12),
        height: 220,

        child: Stack(
          children: [

            /// HERO IMAGE ANIMATION
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: article.imageUrl,
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl.isNotEmpty
                      ? article.imageUrl
                      : "https://via.placeholder.com/400",

                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,

                  placeholder: (context, url) =>
                      const Center(
                        child: CircularProgressIndicator(),
                      ),

                  errorWidget: (context, url, error) =>
                      Container(
                        color: Colors.grey,
                        child: const Icon(
                          Icons.broken_image,
                          size: 80,
                        ),
                      ),
                ),
              ),
            ),

            /// DARK GRADIENT OVERLAY
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),

                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,

                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            /// NEWS TITLE + SOURCE
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}