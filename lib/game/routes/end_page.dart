import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../flutter_web_2d_game.dart';

class EndPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    add(TextComponent(
      text: 'Game Over', 
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y / 3),
      anchor: Anchor.center,
    ));

    final homeBtn = await game.loadSprite('utamabutton.png');

    // Home Button
    add(EndPageButton(
      sprite: homeBtn,
      size: homeBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.6),
      onPressed: () => game.router.pushReplacementNamed('welcome'),
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
