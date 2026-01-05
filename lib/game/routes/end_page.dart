import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../flutter_web_2d_game.dart';

class EndPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // 1. Background
    add(SpriteComponent(
      sprite: await game.loadSprite('background.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // 2. Dark Overlay (to make it a bit dark)
    add(RectangleComponent(
      size: FlutterWeb2DGame.resolution,
      paint: Paint()..color = Colors.black.withOpacity(0.5),
    ));

    // 3. Game Over Text (over.png)
    final overSprite = await game.loadSprite('over.png');
    final overComponent = SpriteComponent(
      sprite: overSprite,
      anchor: Anchor.center,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.4),
      scale: Vector2.zero(), // Start scaled down
    );

    // Animation: Pop in
    overComponent.add(ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(
        duration: 1.0,
        curve: Curves.elasticOut,
      ),
    ));
    add(overComponent);

    final homeBtn = await game.loadSprite('utamabutton.png');

    // Home Button
    add(EndPageButton(
      sprite: homeBtn,
      size: homeBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.8),
      onPressed: () {
        game.currentLevel = 1; // Reset level
        game.router.pushReplacementNamed('welcome');
      },
    ));
  }
}

class EndPageButton extends SpriteComponent with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  final VoidCallback onPressed;

  EndPageButton({
    required super.sprite, 
    required super.position, 
    required super.size,
    required this.onPressed,
  }) : super(
          anchor: Anchor.center, 
          paint: Paint()..filterQuality = FilterQuality.none,
        );

  @override
  void onTapUp(TapUpEvent event) {
    onPressed();
  }
}
