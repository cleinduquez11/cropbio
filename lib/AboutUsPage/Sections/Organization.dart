import 'package:flutter/material.dart';

class OrganizationSection extends StatelessWidget {
  const OrganizationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Who We Are",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 20),
        Text(
          "CropBio is developed and maintained through collaborative efforts between "
          "academic institutions, agricultural researchers, and technology developers. "
          "We integrate geospatial technologies, field research, and data science "
          "to build a comprehensive biodiversity monitoring system.",
          style: TextStyle(height: 1.7, color: Colors.black87),
        ),
      ],
    );
  }
}
