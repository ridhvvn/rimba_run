import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_fonts/google_fonts.dart';
import '../flutter_web_2d_game.dart';
import 'nota_page.dart';

class NotaDetailPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  final String peribahasa;
  final String contoh;

  NotaDetailPage({required this.peribahasa, required this.contoh});

  @override
  Future<void> onLoad() async {
    size = FlutterWeb2DGame.resolution;
    await super.onLoad();

    try {
      final background = await game.loadSprite('background.png');
      final dialog = await game.loadSprite('soalan.png');
      final backBtn = await game.loadSprite('left.png');
      final utamaBtn = await game.loadSprite('utamabutton.png');

      // 1. Background
      add(SpriteComponent(
        sprite: background,
        size: FlutterWeb2DGame.resolution,
        paint: Paint()..filterQuality = FilterQuality.none,
        anchor: Anchor.center,
        position: FlutterWeb2DGame.resolution / 2,
      ));

      // 2. Dialog Box
      final dialogComponent = SpriteComponent(
        sprite: dialog,
        size: dialog.originalSize * 1.5,
        paint: Paint()..filterQuality = FilterQuality.none,
        anchor: Anchor.center,
        position: FlutterWeb2DGame.resolution / 2,
      );
      add(dialogComponent);

      // 3. Text Content
      final peribahasaStyle = GoogleFonts.lora(
        fontSize: 55,
        fontWeight: FontWeight.bold,
      );
      
      final contohStyle = GoogleFonts.lora(
        fontSize: 35,
        fontWeight: FontWeight.normal,
      );

      // --- Peribahasa (Top) ---
      add(TextBoxComponent(
        text: peribahasa,
        textRenderer: TextPaint(
          style: peribahasaStyle.copyWith(
            color: const Color.fromARGB(255, 76, 40, 11),
          ),
        ),
        boxConfig: TextBoxConfig(
          maxWidth: dialogComponent.size.x * 0.8,
          timePerChar: 0,
          growingBox: true,
        ),
        anchor: Anchor.topCenter,
        position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.35),
        align: Anchor.topCenter,
      ));

      // --- Contoh (Bottom) ---
      add(TextBoxComponent(
        text: 'Contoh:\n$contoh',
        textRenderer: TextPaint(
          style: contohStyle.copyWith(
            color: const Color.fromARGB(255, 76, 40, 11),
          ),
        ),
        boxConfig: TextBoxConfig(
          maxWidth: dialogComponent.size.x * 0.7,
          timePerChar: 0,
          growingBox: true,
        ),
        anchor: Anchor.topCenter,
        position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y * 0.55),
        align: Anchor.topCenter,
      ));

      // 4. Buttons
      // Back Button
      add(NotaButton(
        sprite: backBtn,
        size: backBtn.originalSize * 0.4,
        position: Vector2(FlutterWeb2DGame.resolution.x * 0.1, FlutterWeb2DGame.resolution.y * 0.1),
        onPressed: () => game.router.pushReplacementNamed('nota'),
      ));

      // Home Button (Utama)
      add(NotaButton(
        sprite: utamaBtn,
        size: utamaBtn.originalSize,
        position: Vector2(FlutterWeb2DGame.resolution.x * 0.85, FlutterWeb2DGame.resolution.y * 0.1),
        onPressed: () => game.router.pushReplacementNamed('welcome'),
      ));

    } catch (e) {
      debugPrint('Error loading NotaDetailPage: $e');
    }
  }
}