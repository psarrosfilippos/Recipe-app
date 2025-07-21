// Εισάγεται το πακέτο Hive για local αποθήκευση δεδομένων
import 'package:hive/hive.dart';

// Αυτό το αρχείο πρέπει να δημιουργηθεί αυτόματα με το Hive code generator
part 'recipe.g.dart';

// Ορίζεται ότι η κλάση Recipe είναι τύπος που μπορεί να αποθηκευτεί στο Hive
@HiveType(typeId: 0)
class Recipe extends HiveObject {
  // Τίτλος της συνταγής
  @HiveField(0)
  String title;

  // Περιγραφή της συνταγής
  @HiveField(1)
  String description;

  // Χρόνος προετοιμασίας σε λεπτά
  @HiveField(2)
  int prepTime;

  // Δυσκολία εκτέλεσης (π.χ. Εύκολη, Μέτρια, Δύσκολη)
  @HiveField(3)
  String difficulty;

  // Μονοπάτι/URL εικόνας της συνταγής
  @HiveField(4)
  String imagePath;

  // Βαθμολογία της συνταγής (π.χ. από 1 έως 5)
  @HiveField(5)
  int rating;

  // Συστατικά της συνταγής σε μορφή κειμένου
  @HiveField(6)
  String ingredients;

  // Κατασκευαστής της κλάσης Recipe με όλα τα απαιτούμενα πεδία
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
