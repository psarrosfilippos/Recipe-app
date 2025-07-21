## Recipe app

A mobile app for creating, viewing, and managing cooking recipes, developed with Flutter and Hive. It supports dark/light themes, image import from gallery, rating with stars, and sorting by time, difficulty, or rating.  
## Features

- Add new recipes with full details (title, description, ingredients, time, difficulty, image, rating)
- Image selection from device gallery (with permission handling)
- Sort recipes by **time**, **difficulty**, or **rating**
- Local storage using **Hive** (no external server needed)
- Persistent **Dark/Light Theme** with Hive + Provider
- **Undo delete** with SnackBar
- **Responsive cards** with ripple effect and elevation
- **Hero animation** between screens
- **Custom page transitions** (slide effect)
- **Greek localization (el_GR)** for dates and text

## Technologies Used

- Flutter (Dart)
- Hive (local NoSQL database)
- Provider (state management)
- image_picker & permission_handler (gallery access)
## Architecture

- `lib/models/recipe.dart`: Main data model for each recipe
- `lib/screens/home_screen.dart`: Displays recipe list, sorting options, theme toggle
- `lib/screens/add_recipe_screen.dart`: Form to add new recipes (image picker, dropdowns, rating, etc.)
- `lib/screens/recipe_detail_screen.dart`: Shows full details of each recipe
- `lib/widgets/recipe_card.dart`: UI card for recipe preview in the list
- `lib/widgets/star_rating.dart`: Widget to display star-based rating
- `lib/theme/app_theme.dart` & `theme_notifier.dart`: Theme logic and persistence

## How to use

**1. Install Flutter & Dart SDK**

**2. Clone the repo:**


    git clone https://github.com/your-username/recipe-app.git
    cd recipe-app

**3. Install dependencies**

    flutter pub get

**4. Run on emulator or device**

    flutter run


## Acknowledgements

This application was created as part of a 4th-year university project for the course Mobile Device Programming, demonstrating practical use of Flutter, Hive, and mobile UI/UX best practices.

## Authors

Filippos Psarros

informatics and telecommunications Student

GitHub: psarrosfilipposp

More about this project -> https://github.com/psarrosfilippos/Recipe-app/blob/7034aa2c99af3dde4c6e2cda4016ab38228384b1/Recipe_app_report.pdf
[README.md](https://github.com/user-attachments/files/21339599/README.md)
