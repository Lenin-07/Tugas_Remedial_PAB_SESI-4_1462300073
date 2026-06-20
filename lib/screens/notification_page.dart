import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Berita Terbaru Rilis!',
        'message':
            'Peluncuran SpaceX Starlink sukses dilakukan dari Vandenberg.',
        'time': '10 menit yang lalu',
        'icon': Icons.rocket_launch,
        'color': Colors.blue,
        'isNew': true,
      },
      {
        'title': 'Pembaruan Artikel',
        'message':
            'Artikel tentang "Space Rider" ESA baru saja diperbarui. Cek sekarang!',
        'time': '1 jam yang lalu',
        'icon': Icons.article,
        'color': Colors.orange,
        'isNew': true,
      },
      {
        'title': 'Selamat datang di SpaceNews',
        'message':
            'Terima kasih telah bergabung! Temukan berita luar angkasa terbaru setiap harinya.',
        'time': 'Kemarin',
        'icon': Icons.celebration,
        'color': Colors.purple,
        'isNew': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notif['isNew'] ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: notif['isNew']
                  ? [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
              border: notif['isNew']
                  ? Border.all(color: Colors.blue.withValues(alpha: 0.1), width: 1.5)
                  : Border.all(color: Colors.transparent),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notif['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notif['icon'], color: notif['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'],
                              style: TextStyle(
                                fontWeight: notif['isNew']
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 16,
                                color: notif['isNew']
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                            ),
                          ),
                          if (notif['isNew'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
