import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/news_controller.dart';
import '../model/news_model.dart';

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<NewsController>();

    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: const Icon(Icons.menu),
          actions: const [SizedBox(width: 48)],
          elevation: 0,
          bottom: TabBar(
            onTap: (idx) => ctrl.updateCategory(NewsCategory.values[idx]),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
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
            return const Center(child: Text('No news available.'));
          }

          final trending = articles.first;
          final topStories = articles.skip(1).take(3).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTrending(trending),
              const SizedBox(height: 24),
              const Text('Top Stories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...topStories.map((a) => _TopStoryItem(article: a)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTrending(NewsArticle article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: article.urlToImage != null
              ? Image.network(
                  article.urlToImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(height: 180, color: Colors.grey[300]),
        ),
        const SizedBox(height: 12),
        const Text('Trending', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(article.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(article.description, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _TopStoryItem extends StatelessWidget {
  final NewsArticle article;

  const _TopStoryItem({required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(article.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: article.urlToImage != null
                ? Image.network(article.urlToImage!,
                    height: 60, width: 60, fit: BoxFit.cover)
                : Container(height: 60, width: 60, color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
