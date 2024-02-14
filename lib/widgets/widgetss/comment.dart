import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comments({
    Key? key,
    required this.text,
    required this.user,
    required this.time, required imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 20,
            child: Text(
              user[0].toUpperCase(),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            user,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• $time',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
