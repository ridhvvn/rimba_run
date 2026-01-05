# FlutterWeb2DGame

A 2D web game built with Flutter and Flame.

## Project Structure

- `lib/main.dart`: Entry point.
- `lib/game/flutter_web_2d_game.dart`: Main Game class with RouterComponent.
- `lib/game/routes/`: Contains the game pages (Welcome, Game, End, Settings).

## Running the Game

To run the game in Chrome:

```bash
flutter run -d chrome
```

## Building for Web

To build for production with CanvasKit optimization (recommended for high-quality 2D vector rendering):

```bash
flutter build web --web-renderer canvaskit
```

## Tech Stack

- **Framework**: Flutter
- **Game Engine**: Flame
- **Animation**: Flame Effects
- **State Management**: Flame RouterComponent
  - `world.dart`: Defines the World class for managing the game environment.

- **lib/game**: Contains the main game logic and routing.
  - `my_game.dart`: The main game class that initializes the game and manages the game loop.
  - `routes.dart`: Sets up the RouterComponent for navigating between different game screens.

- **lib/overlays**: Contains overlays for different game states.
  - `end_menu.dart`: Displays the end menu with score and restart options.
  - `game_overlay.dart`: Handles question popups during the game.
  - `main_menu.dart`: Displays the main menu with the title and play button.

- **lib/screens**: Contains the screen widgets for different game states.
  - `end_screen.dart`: Displays the end screen layout.
  - `game_screen.dart`: Contains the main game loop.
  - `welcome_screen.dart`: Displays the welcome screen with animations and play button.

- **lib/main.dart**: The entry point of the application.

## Setup Instructions
1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd flame_game_project
   ```
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run -d chrome
   ```

## Game Features
- Player movement and interactions within a dynamic game world.
- Multiple screens for different game states (Welcome, Game, End).
- Overlays for displaying game information and interactions.
- Smooth transitions between screens using the RouterComponent.

## Additional Notes
- Ensure you have Flutter and the Flame engine installed.
- Modify the `pubspec.yaml` file to add any additional dependencies as needed.
- Follow best practices for Dart and Flutter development to maintain code quality.# rimba_run
