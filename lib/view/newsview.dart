import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/news_controller.dart';
import '../model/news_model.dart';
import 'detailednewsview.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NewsController>();

    return DefaultTabController(
      length: 4, // Number of tabs
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB2EBF2),
              Color(0xFFE0F7FA),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('News', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.menu, color: Colors.black87),
            ),
            actions: [
              Container(width: 48),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              onTap: (idx) => ctrl.updateCategory(NewsCategory.values[idx]),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 3,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Local'),
                Tab(text: 'International'),
                Tab(text: 'Sports'),
                Tab(text: 'Technology'),
              ],
            ),
          ),
          body: Obx(() {
            if (ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final articles = ctrl.articles;
            if (articles.isEmpty) {
              return const Center(child: Text('No news available.', style: TextStyle(fontSize: 18, color: Colors.grey)));
            }

            final trending = articles.first;
            final topStories = articles.skip(1).take(3).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTrending(trending),
                const SizedBox(height: 28),
                const Text('Top Stories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 14),
                ...topStories.map((a) => _TopStoryItem(article: a)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTrending(NewsArticle article) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(Get.context!).push(
          MaterialPageRoute(
            builder: (_) => DetailedNewsView(article: article),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white.withOpacity(0.92),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: article.urlToImage != null
                    ? Stack(
                        children: [
                          Image.network(
                            article.urlToImage!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.25),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(height: 180, color: Colors.grey[300]),
              ),
              const SizedBox(height: 14),
              const Text('Trending', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(article.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
              const SizedBox(height: 6),
              Text(article.description, style: const TextStyle(color: Colors.blueGrey, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopStoryItem extends StatelessWidget {
  final NewsArticle article;

  const _TopStoryItem({required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailedNewsView(article: article),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Colors.white.withOpacity(0.93),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                    const SizedBox(height: 6),
                    Text(article.description,
                        maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: article.urlToImage != null
                    ? Image.network(article.urlToImage!,
                        height: 60, width: 60, fit: BoxFit.cover)
                    : Container(height: 60, width: 60, color: Colors.grey[300]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
