import 'package:flutter/material.dart';

class LatestNewsSidebar extends StatelessWidget {
  const LatestNewsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest on Crop Biodiversity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('• Satellite survey completed'),
          Text('• Community seed banks launched'),
          Text('• Drone missions expanded'),
          Text('• Climate risk dashboard released'),
        ],
      ),
    );
  }
}
