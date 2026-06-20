import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final Map article;
  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;

  void toggleFavorite() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (isFavorite) return;
      await FirebaseFirestore.instance.collection('favorites').add({
        'uid': user.uid,
        'article_id': widget.article['id'],
        'title': widget.article['title'],
        'image_url': widget.article['image_url'],
        'news_site': widget.article['news_site'],
        'summary': widget.article['summary'],
        'timestamp': FieldValue.serverTimestamp()
      });
      setState(() => isFavorite = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    String rawUrl = widget.article['image_url'] ?? '';
    String cleanUrl = rawUrl.startsWith('http://') ? rawUrl.replaceFirst('http://', 'https://') : rawUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.black),
            onPressed: toggleFavorite,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                child: Image.network(
                  cleanUrl,
                  headers: const {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'},
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://wsrv.nl/?url=${Uri.encodeComponent(cleanUrl)}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, err, stack) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                    child: Text(widget.article['news_site'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                  Text(widget.article['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 20),
                  Text(widget.article['summary'], style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}