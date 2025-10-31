import 'package:sihemat_v3/components/news_carousel_widget.dart';


/// Data berita statis
/// Anda bisa mengganti ini dengan data dari API di masa depan
class NewsData {
  static List<NewsItem> getNewsItems() {
    return [
      NewsItem(
        imagePath: 'assets/images/news1.png',
        url: 'https://www.example.com/berita-1',
        title: 'Tips Perawatan Kendaraan di Musim Hujan',
      ),
      NewsItem(
        imagePath: 'assets/images/news2.png',
        url: 'https://www.example.com/berita-2',
        title: 'Update Fitur Terbaru Aplikasi SIHEMAT',
      ),
      NewsItem(
        imagePath: 'assets/images/news3.png',
        url: 'https://www.example.com/berita-3',
        title: 'Cara Menghemat BBM dengan GPS Tracking',
      ),
      NewsItem(
        imagePath: 'assets/images/news4.png',
        url: 'https://www.example.com/berita-4',
        title: 'Promo Service Kendaraan Bulan Ini',
      ),
    ];
  }

  /// Untuk future: fungsi untuk fetch news dari API
  static Future<List<NewsItem>> fetchNewsFromAPI() async {
    // TODO: Implementasi fetch dari API
    // try {
    //   final response = await http.get(Uri.parse('YOUR_API_URL'));
    //   if (response.statusCode == 200) {
    //     final List<dynamic> jsonData = json.decode(response.body);
    //     return jsonData.map((item) => NewsItem(
    //       imagePath: item['image_url'],
    //       url: item['article_url'],
    //       title: item['title'],
    //     )).toList();
    //   }
    // } catch (e) {
    //   debugPrint('Error fetching news: $e');
    // }
    
    // Fallback ke data statis
    return getNewsItems();
  }
}