import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget My3LineCard(BuildContext context, String image, String title, String category, String price) {
  return Card(
    color: Colors.white, // White background like the screenshot
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. The Image Area
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(4), // Small gap inside card
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                // Placeholder while loading
                placeholder: (context, url) => Container(color: Colors.grey[200]),
                // Error icon if image fails
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        
        // 2. The Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600, 
              fontSize: 14,
              color: Colors.black87
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // 3. The Bottom Row (Price + Red Badge)
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black, // Or Colors.green if you prefer
                ),
              ),
              
              // The Red Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red, // Match the screenshot red color
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}