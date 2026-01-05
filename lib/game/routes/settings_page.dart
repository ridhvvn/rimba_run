import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class SettingsPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sky = await game.loadSprite('sky1.png');
    final forest = await game.loadSprite('forest1.png');
    final tree = await game.loadSprite('tree1.png');
    final bush = await game.loadSprite('bush1.png');
    final settingsTitle = await game.loadSprite('settings.png');
    final manualBtn = await game.loadSprite('manualbutton.png');
    final notaBtn = await game.loadSprite('notabutton.png');
    final backBtn = await game.loadSprite('utamabutton.png');
    
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

    // 2. Forest (Static)
    addFullScreenLayer(forest);

    // 3. Tree (Static)
    addFullScreenLayer(tree);
    
    // 4. Bush (Static)
    addFullScreenLayer(bush);

    // 5. Ambient Dust
    add(AmbientDust(count: 50));

    // Title
    add(SpriteComponent(
      sprite: settingsTitle,
      size: settingsTitle.originalSize,
      paint: Paint()..filterQuality = FilterQuality.none,
      position: FlutterWeb2DGame.resolution / 2,
      anchor: Anchor.center,
    )..add(ScaleEffect.to(
        Vector2.all(1.05), 
        EffectController(
          duration: 1.0, 
          reverseDuration: 1.0, 
          infinite: true, 
          curve: Curves.easeInOut,
        ),
      )));

    // Manual Button
    add(SettingsButton(
      sprite: manualBtn,
      size: manualBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.4),
      onPressed: () => game.router.pushNamed('manual'),
    ));

    // Nota Button
    add(SettingsButton(
      sprite: notaBtn,
      size: notaBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.5),
      onPressed: () => game.router.pushNamed('nota'),
    ));

    // Back Button (Utama)
    add(SettingsButton(
      sprite: backBtn,
      size: backBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.6),
      onPressed: () => game.router.pop(),
    ));
  }
}

class SettingsButton extends SpriteComponent with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  final VoidCallback onPressed;

  SettingsButton({
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
