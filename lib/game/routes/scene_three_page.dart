import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../flutter_web_2d_game.dart';

class SceneThreePage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    add(TextComponent(
      text: 'Scene 3: Berjaya Lari',
      anchor: Anchor.center,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.4),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 48, color: Colors.white)),
    ));

    add(SimpleButton(
      text: 'Complete Level',
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.6),
      onPressed: () {
        game.currentLevel++;
        if (game.currentLevel == 3) {
          game.router.pushReplacementNamed('victory');
        } else {
          game.router.pushReplacementNamed('map');
        }
      },
    ));
  }
}

class SimpleButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;

  SimpleButton({required this.text, required Vector2 position, required this.onPressed})
      : super(position: position, anchor: Anchor.center, size: Vector2(300, 60));

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue,
    ));
    add(TextComponent(
      text: text,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 32, color: Colors.white)),
    ));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
