import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import '../widgets/news_shimmer.dart';
import 'details_screen.dart';

class HeadlinesScreen extends StatefulWidget {

  final VoidCallback toggleTheme;

  const HeadlinesScreen({
    super.key,
    required this.toggleTheme,
  });

  @override
  State<HeadlinesScreen> createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen> {

  late Future<List<NewsArticle>> futureNews;

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureNews = ApiService().fetchNews();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("HEADLINES"),

        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),

      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),

            child: TextField(
              decoration: InputDecoration(
                hintText: "Search news...",
                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<NewsArticle>>(

              future: futureNews,

              builder: (context, snapshot) {

                /// LOADING STATE
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const NewsShimmer();
                }

                /// ERROR STATE
                if (snapshot.hasError) {
  print(snapshot.error);

  return const Center(
    child: Text(
      "Unable to load news.\nCheck internet connection.",
      textAlign: TextAlign.center,
    ),
  );
}

                /// DATA
                final articles = snapshot.data ?? [];

                /// SEARCH FILTER
                final filteredArticles = articles.where((article) {
                  return article.title
                      .toLowerCase()
                      .contains(searchQuery);
                }).toList();

                /// EMPTY STATE
                if (filteredArticles.isEmpty) {
                  return const Center(
                    child: Text(
                      "No news found",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return RefreshIndicator(

                  onRefresh: () async {
                    setState(() {
                      futureNews = ApiService().fetchNews();
                    });
                  },

                  child: ListView(
                    children: [

                      /// TRENDING SLIDER

                      const SizedBox(height: 10),

                      /// NEWS LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: filteredArticles.length,

                        itemBuilder: (context, index) {

                          final article = filteredArticles[index];

                          return NewsCard(
                            article: article,

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailsScreen(article: article),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}