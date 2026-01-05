import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../flutter_web_2d_game.dart';

class MapPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Background
    add(SpriteComponent(
      sprite: await game.loadSprite('background.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // 2. Map
    final mapSprite = await game.loadSprite('map.png');
    final mapComponent = SpriteComponent(
      sprite: mapSprite,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
      size: Vector2(1266, 678),
    );
    add(mapComponent);

    // 3. Mipmap (Player Marker)
    // Define path points (7 points)
    final pathPoints = [
      Vector2(100, 500), // Start
      Vector2(150, 480),
      Vector2(200, 450), // Level 1
      Vector2(400, 400),
      Vector2(633, 340), // Level 2
      Vector2(850, 300),
      Vector2(1050, 250), // Level 3
    ];

    int startIdx = 0;
    int endIdx = 0;

    if (game.currentLevel == 1) {
      startIdx = 0;
      endIdx = 2;
    } else if (game.currentLevel == 2) {
      startIdx = 2;
      endIdx = 4;
    } else if (game.currentLevel == 3) {
      startIdx = 4;
      endIdx = 6;
    } else {
      startIdx = 6;
      endIdx = 6;
    }

    // Create container for movement
    final mipmapContainer = PositionComponent(
      position: pathPoints[startIdx],
      anchor: Anchor.bottomCenter,
      size: Vector2(100, 100),
    );

    final mipmapSprite = await game.loadSprite('mipmap.png');
    final mipmapSpriteComponent = SpriteComponent(
      sprite: mipmapSprite,
      size: Vector2(100, 100),
    );

    // Add bouncing effect to the sprite (local animation)
    mipmapSpriteComponent.add(
      MoveEffect.by(
        Vector2(0, -15),
        EffectController(
          duration: 0.6,
          reverseDuration: 0.6,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );

    mipmapContainer.add(mipmapSpriteComponent);
    mapComponent.add(mipmapContainer);

    // Prepare arrived sprite (if needed)
    SpriteComponent? arrivedSpriteComponent;
    if (game.currentLevel == 1 || game.currentLevel == 2) {
      final arrivedSpriteName = 'mipmap1.png';
      final arrivedSprite = await game.loadSprite(arrivedSpriteName);
      
      arrivedSpriteComponent = SpriteComponent(
        sprite: arrivedSprite,
        size: Vector2(100, 100),
      );
      // Start invisible
      arrivedSpriteComponent.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
      
      // Add bounce to arrived sprite too
      arrivedSpriteComponent.add(
        MoveEffect.by(
          Vector2(0, -15),
          EffectController(
            duration: 0.6,
            reverseDuration: 0.6,
            infinite: true,
            curve: Curves.easeInOut,
          ),
        ),
      );
      
      mipmapContainer.add(arrivedSpriteComponent);
    }

    // Animate along the path segments
    if (startIdx < endIdx) {
      final List<Effect> sequenceEffects = [];
      
      // 1. Movement Effects
      for (int i = startIdx + 1; i <= endIdx; i++) {
        sequenceEffects.add(
          MoveToEffect(
            pathPoints[i],
            EffectController(duration: 1.0, curve: Curves.linear),
          ),
        );
      }

      // 2. Fade Effect (only for Level 1 & 2)
      if (arrivedSpriteComponent != null) {
        sequenceEffects.add(
          MoveEffect.by(
            Vector2.zero(),
            EffectController(duration: 0),
            onComplete: () {
              mipmapSpriteComponent.add(OpacityEffect.fadeOut(EffectController(duration: 0.5)));
              arrivedSpriteComponent!.add(OpacityEffect.fadeIn(EffectController(duration: 0.5)));
            },
          ),
        );
      }

      mipmapContainer.add(SequenceEffect(sequenceEffects));
    }

    // 4. Next Button (Enter Level)
    add(MapNextButton(
      position: Vector2(FlutterWeb2DGame.resolution.x - 150, FlutterWeb2DGame.resolution.y - 150),
      onPressed: _enterLevel,
    ));
  }

  void _enterLevel() {
    if (game.currentLevel == 1 || game.currentLevel == 2) {
      game.router.pushReplacementNamed('scene1');
    } else if (game.currentLevel == 3) {
      game.router.pushReplacementNamed('victory');
    }
  }
}

class MapNextButton extends PositionComponent with TapCallbacks, HasGameReference<FlutterWeb2DGame> {
  final VoidCallback onPressed;

  MapNextButton({required Vector2 position, required this.onPressed})
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
  void onTapUp(TapUpEvent event) {
    onPressed();
  }
}
