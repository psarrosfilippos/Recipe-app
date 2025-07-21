import 'package:flutter/material.dart';

// Widget που εμφανίζει αστέρια αξιολόγησης (1 έως 5)
// Μπορεί να είναι είτε στατικό είτε διαδραστικό αν δοθεί συνάρτηση onRatingChanged
class StarRating extends StatelessWidget {
  final int rating; // Πόσα αστέρια είναι ενεργά (π.χ. 3 σημαίνει 3/5)
  final double iconSize; // Μέγεθος των εικονιδίων (προεπιλογή 20.0)
  final ValueChanged<int>?
      onRatingChanged; // Callback όταν ο χρήστης αλλάζει τη βαθμολογία

  const StarRating({
    super.key,
    required this.rating,
    this.iconSize = 20.0,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Χρήση του ελάχιστου δυνατού πλάτους
      children: List.generate(5, (index) {
        return IconButton(
          // Αν έχει δοθεί callback, ορίζουμε το onPressed
          onPressed: onRatingChanged != null
              ? () => onRatingChanged!(
                  index + 1) // Π.χ. πάτημα 3ου αστεριού = rating 3
              : null, // Αν δεν είναι διαδραστικό, απενεργοποιούμε το onPressed
          icon: Icon(
            index < rating
                ? Icons.star
                : Icons.star_border, // Συμπληρωμένο ή κενό αστέρι
            color:
                index < rating ? Colors.amber : Colors.grey, // Κίτρινο ή γκρι
            size: iconSize, // Μέγεθος από το πεδίο iconSize
          ),
          padding: EdgeInsets.zero, // Αφαίρεση padding για πιο συμπαγή εμφάνιση
          constraints:
              const BoxConstraints(), // Αφαίρεση περιθωρίων του IconButton
        );
      }),
    );
  }
}
