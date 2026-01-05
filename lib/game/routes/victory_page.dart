import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../flutter_web_2d_game.dart';

class VictoryPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background
    add(SpriteComponent(
      sprite: await game.loadSprite('victory.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // Back to Welcome Button
    add(SimpleButton(
      text: 'Back to Menu',
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.85),
      onPressed: () {
        game.currentLevel = 1; // Reset level
        game.router.pushReplacementNamed('welcome');
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
