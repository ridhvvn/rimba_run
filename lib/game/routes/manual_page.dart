import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class ManualPage extends PositionComponent
    with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final background = await game.loadSprite('background.png');
    final dialog = await game.loadSprite('dialog.png');
    final character = await game.loadSprite('hi.png');
    final nextBtn = await game.loadSprite('next.png');

    // 1. Background (Scaled to fill screen)
    add(SpriteComponent(
      sprite: background,
      size: FlutterWeb2DGame.resolution,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
    ));

    // Ambient Dust
    add(AmbientDust(count: 50));

    // Components to animate
    final dialogComponent = SpriteComponent(
      sprite: dialog,
      size: dialog.originalSize * 1.2,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.center,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.4,
          FlutterWeb2DGame.resolution.y * 0.5),
      scale: Vector2.all(0.0),
    );

    final characterComponent = SpriteComponent(
      sprite: character,
      size: character.originalSize * 1.5,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.bottomLeft,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.65,
          FlutterWeb2DGame.resolution.y * 1.1),
      scale: Vector2.all(0.0),
    )..add(RotateEffect.by(
        0.035,
        EffectController(
          duration: 2.0,
          reverseDuration: 3.0,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ));

    final textComponent = TextBoxComponent(
      text: game.textContent['manual_page']?['welcome_text'] ??
          'Welcome to Rimba Run!\n\nAvoid obstacles and\ncollect items to win.',
      textRenderer: TextPaint(
        style: GoogleFonts.lora(
          fontSize: 35,
          color: const Color.fromARGB(255, 76, 40, 11),
          fontWeight: FontWeight.bold,
        ),
      ),
      boxConfig: TextBoxConfig(maxWidth: 900),
      align: Anchor.center,
      anchor: Anchor.center,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.4,
          FlutterWeb2DGame.resolution.y * 0.5),
      scale: Vector2.all(0.0),
    );

    // Buttons (Late initialization to allow circular reference in onPressed)
    late final ManualButton nextButton;
    late final ManualButton backButton;

    // Exit Animation Logic
    bool isExiting = false;
    void exitPage(String route) {
      if (isExiting) return;
      isExiting = true;

      game.router.pushReplacementNamed(route);
      /*
      //Not use animate out for now
      final duration = 0.5;
      final curve = Curves.elasticIn;

      void animateOut(PositionComponent c) {
        c.add(ScaleEffect.to(
          Vector2.zero(),
          EffectController(duration: duration, curve: curve),
        ));
      }

      animateOut(characterComponent);
      animateOut(textComponent);
      animateOut(nextButton);
      animateOut(backButton);

      // Navigate after animation
      dialogComponent.add(ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: duration, curve: curve),
        onComplete: () => game.router.pushReplacementNamed(route),
      ));
      */
    }

    // Initialize Buttons
    nextButton = ManualButton(
      sprite: nextBtn,
      size: nextBtn.originalSize * 0.5,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.6,
          FlutterWeb2DGame.resolution.y * 0.9),
      onPressed: () => exitPage('map'),
    )..scale = Vector2.all(0.0);

    backButton = ManualButton(
      sprite: nextBtn,
      size: nextBtn.originalSize * 0.5,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.2,
          FlutterWeb2DGame.resolution.y * 0.9),
      angle: pi,
      onPressed: () => exitPage('welcome'),
    )..scale = Vector2.all(0.0);

    // Add Components with Entry Animations
    add(dialogComponent
      ..add(ScaleEffect.to(
        Vector2.all(1.1),
        EffectController(duration: 0.5, curve: Curves.elasticOut),
      )));

    add(characterComponent
      ..add(ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
            duration: 0.5, curve: Curves.elasticOut, startDelay: 0.1),
      )));

    add(AmbientDust(count: 50));

    add(textComponent
      ..add(ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
            duration: 0.5, curve: Curves.elasticOut, startDelay: 0.2),
      )));

    add(nextButton
      ..add(ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
            duration: 0.5, curve: Curves.elasticOut, startDelay: 0.3),
      )));

    add(backButton
      ..add(ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
            duration: 0.5, curve: Curves.elasticOut, startDelay: 0.3),
      )));
  }
}

class ManualButton extends SpriteComponent
    with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  final VoidCallback onPressed;

  ManualButton({
    required super.sprite,
    required super.position,
    required super.size,
    required this.onPressed,
    super.angle = 0,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..filterQuality = FilterQuality.none,
        );

  @override
  void onTapUp(TapUpEvent event) {
    onPressed();
  }
}
