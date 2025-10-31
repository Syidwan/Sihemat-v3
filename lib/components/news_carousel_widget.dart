import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem {
  final String imagePath;
  final String? url;
  final String? title;

  NewsItem({
    required this.imagePath,
    this.url,
    this.title,
  });
}

class NewsCarouselWidget extends StatelessWidget {
  final List<NewsItem> newsItems;

  const NewsCarouselWidget({
    super.key,
    required this.newsItems,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hitung tinggi berdasarkan lebar dengan aspect ratio 16:9
    final screenWidth = MediaQuery.of(context).size.width;
    final carouselWidth = screenWidth * 0.9; // viewport fraction 0.9
    final carouselHeight = (carouselWidth * 9 / 16) + 16; // 16:9 + padding

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: carouselHeight,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 6),
          enlargeCenterPage: true,
          viewportFraction: 0.9,
        ),
        items: newsItems.isEmpty
            ? [_buildEmptyNewsSlide()]
            : newsItems.map((newsItem) => _buildNewsSlide(newsItem)).toList(),
      ),
    );
  }

  Widget _buildNewsSlide(NewsItem newsItem) {
    return GestureDetector(
      onTap: newsItem.url != null
          ? () async {
              try {
                await _launchURL(newsItem.url!);
              } catch (e) {
                debugPrint('Error launching URL: $e');
              }
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Image dengan aspect ratio 16:9 dan BoxFit.contain
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey.shade100, // Background untuk area kosong
                  child: Image.asset(
                    newsItem.imagePath,
                    fit: BoxFit.contain, // Gambar menyesuaikan tanpa crop
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              // Overlay indicator jika ada URL
              if (newsItem.url != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.open_in_new,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              // Title overlay jika ada
              if (newsItem.title != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Text(
                      newsItem.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyNewsSlide() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 12),
              Text(
                "Tidak ada berita terkini",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}