import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class VictoryPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Background
    add(SpriteComponent(
      sprite: await game.loadSprite('background4.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // Ambient Dust
    add(AmbientDust(count: 50));

    // 2. Confetti Spawner
    final rnd = Random();
    add(TimerComponent(
      period: 0.2,
      repeat: true,
      onTick: () {
        add(
          ParticleSystemComponent(
            particle: Particle.generate(
              count: 5,
              lifespan: 4,
              generator: (i) => AcceleratedParticle(
                position: Vector2(
                  rnd.nextDouble() * FlutterWeb2DGame.resolution.x,
                  -20, // Start slightly above screen
                ),
                speed: Vector2(
                  rnd.nextDouble() * 100 - 50, // Random horizontal drift
                  rnd.nextDouble() * 200 + 100, // Falling down
                ),
                acceleration: Vector2(0, 98), // Gravity
                child: CircleParticle(
                  radius: 4.0 + rnd.nextDouble() * 4,
                  paint: Paint()..color = Colors.primaries[rnd.nextInt(Colors.primaries.length)],
                ),
              ),
            ),
          ),
        );
      },
    ));

    // 3. Victory Title (victory.png)
    final victorySprite = await game.loadSprite('victory.png');
    final victoryComponent = SpriteComponent(
      sprite: victorySprite,
      anchor: Anchor.center,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.4),
      scale: Vector2.zero(), // Start invisible/small
    );
    
    // Animation: Pop in and then pulse
    victoryComponent.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.8, curve: Curves.elasticOut),
        ),
        ScaleEffect.by(
          Vector2.all(1.1),
          EffectController(
            duration: 1.0,
            reverseDuration: 1.0,
            infinite: true,
            curve: Curves.easeInOut,
          ),
        ),
      ]),
    );
    add(victoryComponent);

    // Back to Welcome Button
    final utamaBtn = await game.loadSprite('utamabutton.png');
    add(VictoryButton(
      sprite: utamaBtn,
      size: utamaBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.85),
      onPressed: () {
        game.currentLevel = 1; // Reset level
        game.router.pushReplacementNamed('welcome');
      },
    ));
  }
}

class VictoryButton extends SpriteComponent with TapCallbacks {
  final VoidCallback onPressed;

  VictoryButton({
    required super.sprite,
    required super.position,
    required super.size,
    required this.onPressed,
  }) : super(anchor: Anchor.center);

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
