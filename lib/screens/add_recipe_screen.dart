// Import necessary packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// Import the Recipe model and the star rating widget
import '../models/recipe.dart';
import '../widgets/star_rating.dart';

// Screen for adding a new recipe
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Key for the form to allow validation and saving
  final _formKey = GlobalKey<FormState>();

  // Variables for the recipe fields
  String title = '';
  String description = '';
  int prepTime = 0;
  String difficulty = 'Easy';
  String imagePath = '';
  int rating = 0;
  String ingredients = '';

  // Image file selected by the user
  XFile? selectedImage;

  // Updates the rating and corresponding difficulty
  void _updateDifficulty(int newRating) {
    setState(() {
      rating = newRating;
      if (rating <= 3) {
        difficulty = 'Easy';
      } else if (rating == 4) {
        difficulty = 'Medium';
      } else {
        difficulty = 'Hard';
      }
    });
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final status =
        await Permission.photos.request(); // Request access permission
    if (status.isGranted) {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = image;
          imagePath = image.path;
        });
      }
    } else {
      // Show message if permission was denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access to gallery was denied')),
      );
    }
  }

  // Save the recipe to the Hive box
  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRecipe = Recipe(
        title: title,
        description: description,
        prepTime: prepTime,
        difficulty: difficulty,
        imagePath: imagePath,
        rating: rating,
        ingredients: ingredients,
      );

      // Open the Hive box and save
      final box = Hive.box<Recipe>('recipes');
      await box.add(newRecipe);

      // Go back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Input field styles
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Form field for the title
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Title', border: inputBorder),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Description', border: inputBorder),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => description = value!,
              ),
              const SizedBox(height: 12),

              // Preparation time
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Time (in minutes)', border: inputBorder),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the time' : null,
                onSaved: (value) => prepTime = int.parse(value!),
              ),
              const SizedBox(height: 12),

              // Difficulty selection
              DropdownButtonFormField<String>(
                decoration:
                    InputDecoration(labelText: 'Difficulty', border: inputBorder),
                value: difficulty,
                items: ['Easy', 'Medium', 'Hard']
                    .map((level) =>
                        DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) => setState(() => difficulty = value!),
              ),
              const SizedBox(height: 16),

              // Image selection button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Pick a photo'),
              ),

              // Image preview if selected
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(selectedImage!.path), height: 150),
                  ),
                ),
              const SizedBox(height: 16),

              // Star rating
              const Text('Rating:'),
              StarRating(
                rating: rating,
                onRatingChanged: _updateDifficulty,
              ),
              const SizedBox(height: 12),

              // Recipe ingredients
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Ingredients', border: inputBorder),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the ingredients' : null,
                onSaved: (value) => ingredients = value!,
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
