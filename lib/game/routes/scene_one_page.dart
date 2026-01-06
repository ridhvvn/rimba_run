import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class SceneOnePage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  late final SpriteComponent char1;
  late final SpriteComponent char2;
  late final SpriteComponent dialog1;
  late final SpriteComponent dialog2;
  int _step = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Background (background2.png)
    add(SpriteComponent(
      sprite: await game.loadSprite('background2.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // 3. Character 1 (scene1a.png) - Player?
    // Placing on the left-ish side
    char1 = SpriteComponent(
      sprite: await game.loadSprite('scene1a.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.7, FlutterWeb2DGame.resolution.y * 0.8),
      size: Vector2(164, 311) * 1.5, // Scale up a bit
    );
    // Start invisible
    char1.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
    add(char1);

    // 4. Character 2 (scene1.png) - Tiger?
    // Placing on the right-ish side
    char2 = SpriteComponent(
      sprite: await game.loadSprite('scene1.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.6, FlutterWeb2DGame.resolution.y * 0.95),
      size: Vector2(303, 464) * 1.2, // Scale up a bit
    );
    // Start invisible
    char2.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
    add(char2);

    // 5. Dialogue 1 (scene1b.png) - Near Character 1
    final dialog1SpriteName = (game.currentLevel == 1) ? 'bear1.png' : 'scene1b.png';
    dialog1 = SpriteComponent(
      sprite: await game.loadSprite(dialog1SpriteName),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.2, FlutterWeb2DGame.resolution.y * 0.85),
      size: Vector2(358, 191) * 1.5,
    );
    // Start invisible
    dialog1.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
    add(dialog1);

    // 6. Dialogue 2 (scene1c.png) - Near Character 2
    final dialog2SpriteName = (game.currentLevel == 1) ? 'bear3.png' : 'scene1c.png';
    dialog2 = SpriteComponent(
      sprite: await game.loadSprite(dialog2SpriteName),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.35, FlutterWeb2DGame.resolution.y * 0.85),
      size: Vector2(373, 180) * 1.5,
    );
    // Start invisible
    dialog2.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
    add(dialog2);

    // 2. Foreground Element (background2a.png) - Maybe a tree on the left? 
    // Placing it on the left side, using original size
    add(SpriteComponent(
      sprite: await game.loadSprite('background2a.png'),
      position: Vector2(1, 0),
      size: Vector2(701, 1080),
    ));

    // Ambient Dust
    add(AmbientDust(count: 50));
    
    // Animation Sequence
    
    // Pair 1: scene1a (char1) and scene1b (dialog1)
    // Fade In
    char1.add(OpacityEffect.fadeIn(EffectController(duration: 1.0, startDelay: 0.5)));
    dialog1.add(OpacityEffect.fadeIn(EffectController(duration: 1.0, startDelay: 0.5)));

    // 7. Next Button
    add(NextButton(
      position: Vector2(FlutterWeb2DGame.resolution.x - 150, FlutterWeb2DGame.resolution.y - 150),
      onPressed: _onNextPressed,
    ));
  }

  void _onNextPressed() {
    if (_step == 0) {
      // Fade out Pair 1
      char1.add(OpacityEffect.fadeOut(EffectController(duration: 1.0)));
      dialog1.add(OpacityEffect.fadeOut(EffectController(duration: 1.0)));

      // Fade in Pair 2
      char2.add(OpacityEffect.fadeIn(EffectController(duration: 1.0, startDelay: 1.0)));
      dialog2.add(OpacityEffect.fadeIn(EffectController(duration: 1.0, startDelay: 1.0)));

      _step++;
    } else if (_step == 1) {
      // Fade out Pair 2
      char2.add(OpacityEffect.fadeOut(EffectController(duration: 1.0)));
      dialog2.add(OpacityEffect.fadeOut(EffectController(duration: 1.0)));

      // Navigate to next page
      add(TimerComponent(
        period: 1.0,
        removeOnFinish: true,
        onTick: () => game.router.pushReplacementNamed('scene2'),
      ));
      
      _step++;
    }
  }
}

class NextButton extends PositionComponent with TapCallbacks, HasGameReference<FlutterWeb2DGame> {
  final VoidCallback onPressed;

  NextButton({required Vector2 position, required this.onPressed})
      : super(position: position, anchor: Anchor.center, size: Vector2(228, 263) * 0.6);

  @override
  Future<void> onLoad() async {
    final sprite = await game.loadSprite('next.png');
    add(SpriteComponent(
      sprite: sprite,
      size: size,
    ));

    // Add a subtle pulse effect to draw attention
    add(ScaleEffect.by(
      Vector2.all(1.1),
      EffectController(
        duration: 1,
        reverseDuration: 1,
        infinite: true,
        curve: Curves.easeInOut,
      ),
    ));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
