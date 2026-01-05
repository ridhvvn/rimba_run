import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../flutter_web_2d_game.dart';

class SceneThreePage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  late final SpriteComponent gladChar;
  late final SpriteComponent goodChar;
  late final SpriteComponent dialog;
  late final TextComponent dialogText;
  int _step = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final backgroundSprite = await game.loadSprite('background.png');
    final dialogSprite = await game.loadSprite('dialog.png');
    final gladSprite = await game.loadSprite('glad.png');
    final goodSprite = await game.loadSprite('good.png');

    // 1. Background
    add(SpriteComponent(
      sprite: backgroundSprite,
      size: FlutterWeb2DGame.resolution,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
    ));

    // 2. Dialog Box
    dialog = SpriteComponent(
      sprite: dialogSprite,
      size: dialogSprite.originalSize * 1.2,
      anchor: Anchor.center,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.4, FlutterWeb2DGame.resolution.y * 0.5),
    );
    add(dialog);

    // 3. Text
    dialogText = TextComponent(
      text: 'Fuh, nasib baik kita\nsempat lari!', // "Glad we made it"
      textRenderer: TextPaint(
        style: GoogleFonts.lora(
          fontSize: 50,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: dialog.position,
    );
    add(dialogText);

    // 4. Characters
    // Glad Character (Step 0)
    gladChar = SpriteComponent(
      sprite: gladSprite,
      size: gladSprite.originalSize * 1.5,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.75, FlutterWeb2DGame.resolution.y * 1.1),
    );
    // Start with FadeIn
    gladChar.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
    gladChar.add(OpacityEffect.fadeIn(EffectController(duration: 1.0)));
    add(gladChar);

    // Good Character (Step 1)
    goodChar = SpriteComponent(
      sprite: goodSprite,
      size: goodSprite.originalSize * 1.5,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.75, FlutterWeb2DGame.resolution.y * 1.1),
    );
    goodChar.add(OpacityEffect.fadeOut(EffectController(duration: 0))); // Start invisible
    add(goodChar);

    // 5. Next Button
    add(NextButton(
      position: Vector2(FlutterWeb2DGame.resolution.x - 150, FlutterWeb2DGame.resolution.y - 150),
      onPressed: _nextStep,
    ));
  }

  void _nextStep() {
    if (_step == 0) {
      // Transition to Step 1
      // Fade out Glad
      gladChar.add(OpacityEffect.fadeOut(EffectController(duration: 0.5)));
      
      // Fade in Good
      goodChar.add(OpacityEffect.fadeIn(EffectController(duration: 0.5, startDelay: 0.5)));

      // Change Text
      dialogText.text = 'Syukurlah kita selamat.\nIngat pesanan orang tua.'; // "Good/Lesson learned"
      
      _step++;
    } else {
      // Finish Level
      //game.currentLevel++;
      // Check if game is finished (Level 3 done -> Victory)
      // Assuming Level 3 is the last one based on previous context
      // If currentLevel was 3 coming in, it's now 4.
      // Or if this IS Scene 3 (Level 3), then next is Victory.
      
      // Logic from previous map_page:
      // Level 1 -> Scene 1 -> Scene 2 -> Map (Level 2)
      // Level 2 -> Scene 1 -> Scene 2 -> Map (Level 3)
      // Level 3 -> Scene 1 -> Scene 2 -> Map (Level 4??) -> Victory
      
      // Wait, the user request said: "if level 3, route to victory page" in map_page.
      // So if we are here, we just finished a scene sequence.
      // Usually Scene 3 is the END of the level sequence?
      // Let's assume we go back to Map to decide where to go next.
      
      game.router.pushReplacementNamed('map');
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

