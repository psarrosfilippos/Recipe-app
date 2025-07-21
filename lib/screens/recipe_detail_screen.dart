// Import libraries
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/star_rating.dart';

// Screen displaying the details of a recipe
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  // Constructor receives the recipe to be displayed
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // Select the appropriate image widget
    if (recipe.imagePath.isEmpty) {
      // If there is no image
      imageWidget = const Icon(
        Icons.image_not_supported,
        size: 100,
        color: Colors.grey,
      );
    } else if (recipe.imagePath.startsWith('/')) {
      // If it's a path from the filesystem (File image)
      imageWidget = Image.file(
        File(recipe.imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    } else {
      // If it's an asset image (e.g. bundled image)
      imageWidget = Image.asset(
        recipe.imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 200,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true, // Return with back button
        title: Text(
          recipe.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // Truncate long titles
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Scrollable content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with transition animation (Hero)
              Hero(
                tag: recipe.title,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
              ),
              const SizedBox(height: 24),

              // Ingredients section
              Text(
                'Ingredients:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                recipe.ingredients.isNotEmpty
                    ? recipe.ingredients
                    : 'No ingredients provided.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Preparation time
              Text(
                'Preparation time: ${recipe.prepTime} minutes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Recipe difficulty
              Text(
                'Difficulty: ${recipe.difficulty}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Recipe rating with stars
              Row(
                children: [
                  const Text(
                    'Rating: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StarRating(
                      rating: recipe.rating,
                      iconSize: 22), // Widget for displaying stars
                ],
              ),
              const SizedBox(height: 16),

              // Recipe instructions
              Text(
                'Instructions:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                recipe.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
