// Εισαγωγή απαραίτητων πακέτων
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// Εισαγωγή του μοντέλου Recipe και του widget αξιολόγησης με αστέρια
import '../models/recipe.dart';
import '../widgets/star_rating.dart';

// Οθόνη για την προσθήκη νέας συνταγής
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Κλειδί για τη φόρμα ώστε να μπορούμε να κάνουμε validate και save
  final _formKey = GlobalKey<FormState>();

  // Μεταβλητές για τα πεδία της συνταγής
  String title = '';
  String description = '';
  int prepTime = 0;
  String difficulty = 'Εύκολη';
  String imagePath = '';
  int rating = 0;
  String ingredients = '';

  // Αρχείο εικόνας που επιλέγει ο χρήστης
  XFile? selectedImage;

  // Ενημερώνει τη βαθμολογία και την αντίστοιχη δυσκολία
  void _updateDifficulty(int newRating) {
    setState(() {
      rating = newRating;
      if (rating <= 3) {
        difficulty = 'Εύκολη';
      } else if (rating == 4) {
        difficulty = 'Μέτρια';
      } else {
        difficulty = 'Δύσκολη';
      }
    });
  }

  // Επιλογή εικόνας από τη συλλογή
  Future<void> _pickImage() async {
    final status =
        await Permission.photos.request(); // Ζητείται άδεια πρόσβασης
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
      // Εμφάνιση μηνύματος αν δεν δόθηκε άδεια
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Η πρόσβαση στη συλλογή απορρίφθηκε')),
      );
    }
  }

  // Αποθήκευση της συνταγής στο Hive box
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

      // Άνοιγμα του Hive box και αποθήκευση
      final box = Hive.box<Recipe>('recipes');
      await box.add(newRecipe);

      // Επιστροφή στην προηγούμενη οθόνη
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Στυλ για τα πεδία εισαγωγής
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Προσθήκη Συνταγής')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Πεδία φόρμας για τον τίτλο
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Τίτλος', border: inputBorder),
                validator: (value) =>
                    value!.isEmpty ? 'Συμπλήρωσε τον τίτλο' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 12),

              // Περιγραφή
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Περιγραφή', border: inputBorder),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Συμπλήρωσε την περιγραφή' : null,
                onSaved: (value) => description = value!,
              ),
              const SizedBox(height: 12),

              // Χρόνος προετοιμασίας
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Χρόνος (σε λεπτά)', border: inputBorder),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Συμπλήρωσε τον χρόνο' : null,
                onSaved: (value) => prepTime = int.parse(value!),
              ),
              const SizedBox(height: 12),

              // Επιλογή δυσκολίας
              DropdownButtonFormField<String>(
                decoration:
                    InputDecoration(labelText: 'Δυσκολία', border: inputBorder),
                value: difficulty,
                items: ['Εύκολη', 'Μέτρια', 'Δύσκολη']
                    .map((level) =>
                        DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) => setState(() => difficulty = value!),
              ),
              const SizedBox(height: 16),

              // Κουμπί επιλογής εικόνας
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Επιλογή φωτογραφίας'),
              ),

              // Προεπισκόπηση εικόνας αν έχει επιλεγεί
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(selectedImage!.path), height: 150),
                  ),
                ),
              const SizedBox(height: 16),

              // Επιλογή βαθμολογίας με αστέρια
              const Text('Βαθμολογία:'),
              StarRating(
                rating: rating,
                onRatingChanged: _updateDifficulty,
              ),
              const SizedBox(height: 12),

              // Υλικά συνταγής
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Υλικά', border: inputBorder),
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Συμπλήρωσε τα υλικά' : null,
                onSaved: (value) => ingredients = value!,
              ),
              const SizedBox(height: 24),

              // Κουμπί αποθήκευσης
              ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Αποθήκευση'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
