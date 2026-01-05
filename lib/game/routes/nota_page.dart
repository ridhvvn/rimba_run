import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import '../flutter_web_2d_game.dart';
import 'package:flame/game.dart';
import 'nota_detail_page.dart';

class NotaPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  late final PositionComponent contentContainer;
  late final ClipComponent scrollWindow;
  late final Sprite listBgSprite;
  double _contentHeight = 0;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final background = await game.loadSprite('background.png');
    listBgSprite = await game.loadSprite('list.png');
    final leftBtn = await game.loadSprite('left.png');
    final utamaBtn = await game.loadSprite('utamabutton.png');

    // 1. Background
    add(SpriteComponent(
      sprite: background,
      size: FlutterWeb2DGame.resolution,
      paint: Paint()..filterQuality = FilterQuality.none,
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
    ));

    // 2. Scrollable Area Setup
    // We want a central window to scroll through the cards
    final windowSize = Vector2(FlutterWeb2DGame.resolution.x * 0.8, FlutterWeb2DGame.resolution.y * 0.7);
    final windowPosition = Vector2(
      (FlutterWeb2DGame.resolution.x - windowSize.x) / 2,
      FlutterWeb2DGame.resolution.y * 0.2, // Start below the top buttons area
    );

    contentContainer = PositionComponent(
      anchor: Anchor.topLeft,
    );

    scrollWindow = ClipComponent.rectangle(
      size: windowSize,
      position: windowPosition,
      anchor: Anchor.topLeft,
      children: [contentContainer],
    );
    add(scrollWindow);

    // 3. Scroll Handler
    add(ScrollHandler(
      size: windowSize,
      position: windowPosition,
      content: contentContainer,
      getContentHeight: () => _contentHeight,
    ));

    // 4. Buttons
    // Back Button (Left)
    add(NotaButton(
      sprite: leftBtn,
      size: leftBtn.originalSize * 0.4,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.1, FlutterWeb2DGame.resolution.y * 0.1),
      onPressed: () => game.router.pop(),
    ));

    // Home Button (Utama)
    add(NotaButton(
      sprite: utamaBtn,
      size: utamaBtn.originalSize,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.85, FlutterWeb2DGame.resolution.y * 0.1),
      onPressed: () => game.router.pushReplacementNamed('welcome'),
    ));

    // 5. Fetch Data
    _fetchData(windowSize.x);
  }

  Future<void> _fetchData(double cardWidth) async {
    const url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTrkt2G-3z1GcIyE9SRHHBLXd-Xk5nZrmG_hjR60WDuRB0bI0KYBJiqVvIaPGc9K0U8Aov-MVzJkq9T/pub?output=csv';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<List<dynamic>> rows = const CsvToListConverter().convert(response.body);
        
        // Skip header
        final dataRows = rows.skip(1).toList();
        
        double currentY = 0;
        final double spacing = 20;
        
        // Calculate card height based on aspect ratio to fit width
        // Assuming list.png is a horizontal bar/card
        final double cardHeight = listBgSprite.originalSize.y * (cardWidth / listBgSprite.originalSize.x);
        final Vector2 cardSize = Vector2(cardWidth, cardHeight);

        int index = 1;
        for (var row in dataRows) {
          if (row.length >= 4) {
            final peribahasa = row[0].toString();
            final contoh = row[3].toString(); // Using column 3 for Contoh
            
            final card = NoteCard(
              sprite: listBgSprite,
              index: index,
              peribahasa: peribahasa,
              contoh: contoh,
              size: cardSize,
              position: Vector2(0, currentY),
            );
            
            contentContainer.add(card);
            currentY += cardSize.y + spacing;
            index++;
          }
        }
        
        _contentHeight = currentY;

      } else {
        debugPrint('Failed to load data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}

class NoteCard extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  final Sprite sprite;
  final int index;
  final String peribahasa;
  final String contoh;

  NoteCard({
    required this.sprite,
    required this.index,
    required this.peribahasa,
    required this.contoh,
    required Vector2 size,
    required Vector2 position,
  }) : super(size: size, position: position);

  @override
  Future<void> onLoad() async {
    // Background Card
    add(SpriteComponent(
      sprite: sprite,
      size: size,
    ));

    // Text (Only Peribahasa)
    final textStyle = GoogleFonts.lora(
      fontSize: 45,
      fontWeight: FontWeight.bold,
    );

    // Text Layer
    add(TextBoxComponent(
      text: '$index. $peribahasa',
      textRenderer: TextPaint(
        style: textStyle.copyWith(
          color: const Color.fromARGB(255, 76, 40, 11),
        ),
      ),
      boxConfig: TextBoxConfig(
        maxWidth: size.x * 0.75,
        timePerChar: 0,
        growingBox: true,
      ),
      anchor: Anchor.centerLeft,
      position: Vector2(size.x * 0.05, size.y / 2),
      align: Anchor.centerLeft,
    ));

    // Right Arrow Button
    final rightBtnSprite = await game.loadSprite('right.png');
    add(NotaButton(
      sprite: rightBtnSprite,
      size: rightBtnSprite.originalSize * 0.3,
      position: Vector2(size.x * 0.9, size.y / 2),
      onPressed: () {
        game.router.pushReplacement(Route(
          () => NotaDetailPage(peribahasa: peribahasa, contoh: contoh),
          maintainState: false,
        ));
      },
    ));
  }
}

class ScrollHandler extends PositionComponent with DragCallbacks {
  final PositionComponent content;
  final double Function() getContentHeight;

  ScrollHandler({
    required Vector2 size,
    required Vector2 position,
    required this.content,
    required this.getContentHeight,
  }) : super(size: size, position: position, anchor: Anchor.topLeft);

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final contentHeight = getContentHeight();
    final windowHeight = size.y;

    // Only scroll if content is taller than window
    if (contentHeight > windowHeight) {
      double newY = content.position.y + event.localDelta.y;
      
      // Clamp scrolling
      // Top limit: 0
      // Bottom limit: -(contentHeight - windowHeight)
      final minScroll = -(contentHeight - windowHeight) - 50; // Extra padding at bottom
      final maxScroll = 0.0;

      newY = newY.clamp(minScroll, maxScroll);
      content.position.y = newY;
    }
  }
}

class NotaButton extends SpriteComponent with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  final VoidCallback onPressed;

  NotaButton({
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
    add(ScaleEffect.by(
      Vector2.all(1.1),
      EffectController(duration: 0.1, reverseDuration: 0.1),
    ));
    onPressed();
  }
}
