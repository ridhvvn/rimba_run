import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class WelcomePage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sky = await game.loadSprite('sky1.png');
    final forest = await game.loadSprite('forest1.png');
    final tree = await game.loadSprite('tree1.png');
    final bush = await game.loadSprite('bush1.png');
    final title = await game.loadSprite('rimbarun.png');
    final button = await game.loadSprite('playbutton.png');
    final settingBtn = await game.loadSprite('settingbutton.png');

    // Helper to add full-screen layers
    void addFullScreenLayer(Sprite sprite) {
      add(SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize,
        paint: Paint()..filterQuality = FilterQuality.none,
        anchor: Anchor.center,
        position: FlutterWeb2DGame.resolution / 2,
      ));
    }

    // 1. Sky (Static)
    addFullScreenLayer(sky);

    // 2. Forest (Zoom out 1.1 -> 1.0)
    add(SpriteComponent(
      sprite: forest,
      size: forest.originalSize,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
      scale: Vector2.all(1.1),
    )..add(ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
          duration: 2.5,
          curve: Curves.easeOut,
        ),
      )));

    // 3. Tree (Zoom out 1.25 -> 1.0)
    add(SpriteComponent(
      sprite: tree,
      size: tree.originalSize,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
      scale: Vector2.all(1.25),
    )..add(ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
          duration: 2.5,
          curve: Curves.easeOut,
        ),
      )));
    
    // 4. Bush (Zoom out 1.5 -> 1.0)
    add(SpriteComponent(
      sprite: bush,
      size: bush.originalSize,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
      scale: Vector2.all(1.5),
    )..add(ScaleEffect.to(
        Vector2.all(1.0), 
        EffectController(
          duration: 2.5, 
          curve: Curves.easeOut,
        ),
      )));

    // 5. Ambient Dust
    add(AmbientDust(count: 50));

    // 6. Title (Entry Zoom In 0.5 -> 1.0)
    add(SpriteComponent(
      sprite: title,
      size: title.originalSize,
      paint: Paint()..filterQuality = FilterQuality.none,
      position: FlutterWeb2DGame.resolution / 2,
      anchor: Anchor.center,
      scale: Vector2.all(0.5),
    )..add(ScaleEffect.to(
        Vector2.all(1.0), 
        EffectController(
          duration: 2.5, 
          curve: Curves.elasticOut,
        ),
      )));

    // 6. Play Button (Breathing at 1.0 scale)
    add(MenuButton(
      sprite: button,
      size: button.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x /2, FlutterWeb2DGame.resolution.y * 0.6),
      onPressed: () {
        game.router.pushReplacementNamed('manual');
      },
    )
      ..add(ScaleEffect.to(
        Vector2.all(1.05), 
        EffectController(
          duration: 1.0, 
          reverseDuration: 1.0, 
          infinite: true, 
          curve: Curves.easeInOut,
        ),
      )));

    // 7. Settings Button


    add(MenuButton(
      sprite: settingBtn,
      size: settingBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.9, FlutterWeb2DGame.resolution.y * 0.8),
      onPressed: () => game.router.pushNamed('settings'),
    ));

    // Debug Shortcut Button (Toggle this for production)
    const bool showDebugButton = false;
    if (showDebugButton) {
      add(DebugButton(
        position: Vector2(100, 100),
        onPressed: () {
          // Shortcut to Map
          game.router.pushReplacementNamed('nota');
        },
      ));
    }

    // 8. Mute/Unmute Button
    add(MuteButton(
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.1, FlutterWeb2DGame.resolution.y * 0.8),
    ));
  }
}

class MuteButton extends SpriteComponent with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  MuteButton({required Vector2 position})
      : super(position: position, anchor: Anchor.center);

  late final Sprite muteSprite;
  late final Sprite unmuteSprite;

  @override
  Future<void> onLoad() async {
    muteSprite = await game.loadSprite('unmute.png');
    unmuteSprite = await game.loadSprite('mute.png');
    
    // Set initial size based on the sprite
    size = muteSprite.originalSize * 0.45; 
    
    // Sync initial state
    _updateState();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.stop();
      sprite = muteSprite;
    } else {
      FlameAudio.bgm.play('bg.mp3');
      sprite = unmuteSprite;
    }
  }

  void _updateState() {
    if (FlameAudio.bgm.isPlaying) {
      sprite = unmuteSprite;
    } else {
      sprite = muteSprite;
    }
  }
}

class DebugButton extends PositionComponent with TapCallbacks {
  final VoidCallback onPressed;

  DebugButton({required Vector2 position, required this.onPressed})
      : super(position: position, size: Vector2(120, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.red.withOpacity(0.8),
    ));
    add(TextComponent(
      text: 'DEBUG: MAP',
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    ));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}

class MenuButton extends SpriteComponent with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  final VoidCallback onPressed;

  MenuButton({
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
