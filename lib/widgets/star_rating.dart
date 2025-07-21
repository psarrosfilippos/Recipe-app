import 'package:flutter/material.dart';

// Widget that displays star ratings (1 to 5)
// It can be either static or interactive if an onRatingChanged callback is provided
class StarRating extends StatelessWidget {
  final int rating; // How many stars are active (e.g. 3 means 3/5)
  final double iconSize; // Size of the icons (default 20.0)
  final ValueChanged<int>?
      onRatingChanged; // Callback when the user changes the rating

  const StarRating({
    super.key,
    required this.rating,
    this.iconSize = 20.0,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Use the minimum possible width
      children: List.generate(5, (index) {
        return IconButton(
          // If a callback is provided, set onPressed
          onPressed: onRatingChanged != null
              ? () => onRatingChanged!(
                  index + 1) // E.g. tapping the 3rd star = rating 3
              : null, // If not interactive, disable onPressed
          icon: Icon(
            index < rating
                ? Icons.star
                : Icons.star_border, // Filled or empty star
            color:
                index < rating ? Colors.amber : Colors.grey, // Yellow or gray
            size: iconSize, // Size from iconSize field
          ),
          padding: EdgeInsets.zero, // Remove padding for compact display
          constraints:
              const BoxConstraints(), // Remove IconButton margins
        );
      }),
    );
  }
}

