// Import the Hive package for local data storage
import 'package:hive/hive.dart';

// This file must be generated automatically using the Hive code generator
part 'recipe.g.dart';

// Declares that the Recipe class is a type that can be stored in Hive
@HiveType(typeId: 0)
class Recipe extends HiveObject {
  // Title of the recipe
  @HiveField(0)
  String title;

  // Description of the recipe
  @HiveField(1)
  String description;

  // Preparation time in minutes
  @HiveField(2)
  int prepTime;

  // Difficulty level (e.g., Easy, Medium, Hard)
  @HiveField(3)
  String difficulty;

  // Image path/URL of the recipe
  @HiveField(4)
  String imagePath;

  // Recipe rating (e.g., from 1 to 5)
  @HiveField(5)
  int rating;

  // Ingredients of the recipe in text form
  @HiveField(6)
  String ingredients;

  // Constructor of the Recipe class with all required fields
  Recipe({
    required this.title,
    required this.description,
    required this.prepTime,
    required this.difficulty,
    required this.imagePath,
    required this.rating,
    required this.ingredients,
  });
}
