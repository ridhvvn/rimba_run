import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class QuestionData {
  final String questionText; // contoh
  final String correctAnswer; // peribahasa
  final List<String> options; // shuffled options
  final String tahap;

  QuestionData(this.questionText, this.correctAnswer, this.options, this.tahap);
}

class SceneTwoPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  late final SpriteComponent background;
  late final TextBoxComponent questionTextComponent;
  late final TextBoxComponent optionsTextComponent;
  late final TextComponent questionNumberComponent;
  late final TextComponent tahapComponent;
  
  // Pairs of components (Lari & Harimau)
  final List<List<SpriteComponent>> pairs = [];
  int _currentPairIndex = 0;

  // Questions
  List<QuestionData> _questions = [];
  int _currentQuestionIndex = 0;
  
  // Buttons
  final List<AnswerButton> _answerButtons = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Background
    add(SpriteComponent(
      sprite: await game.loadSprite('background3.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // Ambient Dust
    add(AmbientDust(count: 50));

    // Question Number Indicator
    final numberBg = CircleComponent(
      radius: 40,
      paint: Paint()..color = Colors.orange.withOpacity(0.9),
      anchor: Anchor.center,
      position: Vector2(80, 80),
    );
    add(numberBg);

    questionNumberComponent = TextComponent(
      text: '1',
      anchor: Anchor.center,
      position: numberBg.position,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(questionNumberComponent);

    // Tahap Indicator
    tahapComponent = TextComponent(
      text: '',
      anchor: Anchor.centerLeft,
      position: Vector2(140, 80),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4,
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
    add(tahapComponent);

    // Load Questions from CSV
    _loadQuestions();

    if (_questions.isEmpty) {
      // Fallback if loading fails
      _questions = [
        QuestionData('Loading Failed', 'A', ['A', 'B', 'C', 'D'], 'Unknown'),
      ];
    }

    // 3. Soalan (Question Background & Text)
    final soalanSprite = await game.loadSprite('soalan.png');
    final soalanBg = SpriteComponent(
      sprite: soalanSprite,
      anchor: Anchor.topCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, 20),
    );
    add(soalanBg);

    questionTextComponent = TextBoxComponent(
      text: _questions[_currentQuestionIndex].questionText,
      anchor: Anchor.center,
      position: Vector2(soalanBg.size.x / 2, soalanBg.size.y * 0.3),
      boxConfig: TextBoxConfig(
        maxWidth: soalanBg.size.x * 0.6,
        timePerChar: 0,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 43,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      align: Anchor.center,
    );
    soalanBg.add(questionTextComponent);

    // 4. Options Text List
    optionsTextComponent = TextBoxComponent(
      text: 'The fix was to add growingBox: true to the TextBoxConfig. This allows the TextBoxComponent to automatically expand its height to fit all the lines of text, ensuring all 4 options are visible.',
      anchor: Anchor.topCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, 350), // Below question
      boxConfig: TextBoxConfig(
        maxWidth: FlutterWeb2DGame.resolution.x * 0.45,
        timePerChar: 0,
        growingBox: true, // Allow box to grow vertically
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 35,
          color: Colors.brown,
          fontWeight: FontWeight.bold,
          height: 1.5, // Line height for spacing
          //backgroundColor: Colors.white, // Background color for debug
        ),
      ),
      align: Anchor.topLeft,
    );
    add(optionsTextComponent);

    // 5. Answer Buttons (A, B, C, D)
    _createAnswerButtons();
    _updateQuestionUI(); // Initial UI update

    // 2. Pairs (Lari & Harimau/Bear)
    // We load all 3 pairs but start them invisible (except the first one maybe, or handle in init)
    
    final isLevel1 = game.currentLevel == 1;
    final chaser1Name = isLevel1 ? 'bear1.png' : 'harimau1.png';
    final chaser2Name = isLevel1 ? 'bear2.png' : 'harimau2.png';
    final chaser3Name = isLevel1 ? 'bear4.png' : 'harimau3.png';

    // Pair 1
    final lari1Sprite = await game.loadSprite('lari1.png');
    final chaser1Sprite = await game.loadSprite(chaser1Name);

    final lari1 = SpriteComponent(
      sprite: lari1Sprite,
      size: lari1Sprite.originalSize,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.8, FlutterWeb2DGame.resolution.y * 0.8),
    );
    final harimau1 = SpriteComponent(
      sprite: chaser1Sprite,
      size: chaser1Sprite.originalSize,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.2, FlutterWeb2DGame.resolution.y * 0.8),
    );
    pairs.add([lari1, harimau1]);

    // Pair 2
    final lari2Sprite = await game.loadSprite('lari2.png');
    final chaser2Sprite = await game.loadSprite(chaser2Name);

    final lari2 = SpriteComponent(
      sprite: lari2Sprite,
      size: lari2Sprite.originalSize,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.7, FlutterWeb2DGame.resolution.y * 0.8),
    );
    final harimau2 = SpriteComponent(
      sprite: chaser2Sprite,
      size: chaser2Sprite.originalSize,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.3, FlutterWeb2DGame.resolution.y * 0.8),
    );
    pairs.add([lari2, harimau2]);

    // Pair 3
    final lari3Sprite = await game.loadSprite('lari3.png');
    final chaser3Sprite = await game.loadSprite(chaser3Name);

    final lari3 = SpriteComponent(
      sprite: lari3Sprite,
      size: lari3Sprite.originalSize,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.6, FlutterWeb2DGame.resolution.y * 0.8),
    );
    final harimau3 = SpriteComponent(
      sprite: chaser3Sprite,
      size: chaser3Sprite.originalSize,
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.4, FlutterWeb2DGame.resolution.y * 0.8),
    );
    pairs.add([lari3, harimau3]);

    // Add all pairs to the component, but set opacity to 0 for non-active ones
    for (var i = 0; i < pairs.length; i++) {
      for (var comp in pairs[i]) {
        // Start invisible
        comp.add(OpacityEffect.fadeOut(EffectController(duration: 0)));
        add(comp);
      }
    }

    // Show Pair 1 immediately
    _showPair(0, duration: 0.5);

  }

  void _loadQuestions() {
    try {
      final dataRows = game.notaData;
      
      final List<Map<String, String>> allQuestions = [];
      final List<String> allPeribahasa = [];

      for (var row in dataRows) {
        if (row.length >= 4) {
          final peribahasa = row[0].toString();
          final tahap = row[1].toString().toLowerCase();
          final contoh = row[3].toString();
          
          allPeribahasa.add(peribahasa);
          allQuestions.add({
            'peribahasa': peribahasa,
            'tahap': tahap,
            'contoh': contoh,
          });
        }
      }

      // Filter by level
      List<Map<String, String>> filteredQuestions = [];
      if (game.currentLevel == 1) {
        filteredQuestions = allQuestions.where((q) => q['tahap']!.contains('mudah') || q['tahap']!.contains('sederhana')).toList();
      } else if (game.currentLevel == 2) {
        filteredQuestions = allQuestions.where((q) => q['tahap']!.contains('tinggi') || q['tahap']!.contains('sukar')).toList();
      } else {
        filteredQuestions = allQuestions.where((q) => q['tahap']!.contains('sangat sukar')).toList();
      }

      // If no questions found for level, use all
      if (filteredQuestions.isEmpty) filteredQuestions = allQuestions;

        // Pick random questions (e.g., 5 questions per level)
        filteredQuestions.shuffle();
        final selectedQuestions = filteredQuestions.take(4).toList();

        _questions = selectedQuestions.map((q) {
          final correctAnswer = q['peribahasa']!;
          final questionText = q['contoh']!;
          final tahap = q['tahap']!;
          
          // Generate options
          final options = <String>[correctAnswer];
          final otherOptions = allPeribahasa.where((p) => p != correctAnswer).toList();
          otherOptions.shuffle();
          options.addAll(otherOptions.take(3));
          options.shuffle();

          return QuestionData(questionText, correctAnswer, options, tahap);
        }).toList();

    } catch (e) {
      debugPrint('Error loading CSV: $e');
    }
  }

  void _createAnswerButtons() {
    // Clear existing buttons
    for (var btn in _answerButtons) {
      remove(btn);
    }
    _answerButtons.clear();

    if (_questions.isEmpty) return;

    final labels = ['A', 'B', 'C', 'D'];
    final buttonY = FlutterWeb2DGame.resolution.y * 0.85;
    final buttonSpacing = 200.0;
    final startX = (FlutterWeb2DGame.resolution.x - (buttonSpacing * 3)) / 2;

    for (var i = 0; i < labels.length; i++) {
      final btn = AnswerButton(
        text: labels[i],
        size: Vector2(100, 100),
        position: Vector2(startX + (i * buttonSpacing), buttonY),
        onPressed: () => _checkAnswerByIndex(i),
      );
      add(btn);
      _answerButtons.add(btn);
    }
  }

  void _checkAnswerByIndex(int index) {
    final currentQ = _questions[_currentQuestionIndex];
    if (index < currentQ.options.length) {
      _checkAnswer(currentQ.options[index]);
    }
  }

  void _showPair(int index, {double duration = 1.0}) {
    if (index >= pairs.length) return;

    for (var comp in pairs[index]) {
      comp.add(OpacityEffect.fadeIn(EffectController(duration: duration)));
    }
  }

  void _hidePair(int index, {double duration = 1.0}) {
    if (index >= pairs.length) return;

    for (var comp in pairs[index]) {
      comp.add(OpacityEffect.fadeOut(EffectController(duration: duration)));
    }
  }

  void _checkAnswer(String answer) {
    final currentQuestion = _questions[_currentQuestionIndex];

    if (answer == currentQuestion.correctAnswer) {
      // Correct!
      if (_currentPairIndex > 0) {
        // Regain life (move away from tiger)
        _hidePair(_currentPairIndex);
        _currentPairIndex--;
        _showPair(_currentPairIndex);
      } 
      // Always move to next question on correct answer? Or just stay safe?
      // Let's move to next question
      _nextQuestion();
    } else {
      // Wrong!
      if (_currentPairIndex < pairs.length - 1) {
        // Lose life (tiger gets closer)
        _hidePair(_currentPairIndex);
        _currentPairIndex++;
        _showPair(_currentPairIndex);
      } else {
        // No lives left (lari3) -> Game Over
        game.router.pushReplacementNamed('end');
      }
    }
  }

  void _nextQuestion() {
    _currentQuestionIndex++;
    if (_currentQuestionIndex < _questions.length) {
      // Load next question
      _updateQuestionUI();
    } else {
      // All questions done -> Increment Level -> Map
      game.currentLevel++;
      game.router.pushReplacementNamed('scene3');
    }
  }
  
  void _updateQuestionUI() {
    if (_questions.isEmpty) return;
    
    final currentQ = _questions[_currentQuestionIndex];
    questionTextComponent.text = currentQ.questionText;
    questionNumberComponent.text = '${_currentQuestionIndex + 1}';
    tahapComponent.text = 'Tahap: ${currentQ.tahap.toUpperCase()}';
    
    // Update options list text
    final labels = ['A', 'B', 'C', 'D'];
    final buffer = StringBuffer();
    for (var i = 0; i < currentQ.options.length; i++) {
      buffer.writeln('${labels[i]}) ${currentQ.options[i]}');
    }
    optionsTextComponent.text = buffer.toString();
    
    // Buttons are static A, B, C, D, so no need to recreate them every time
    if (_answerButtons.isEmpty) {
      _createAnswerButtons();
    }
  }
}

class AnswerButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;

  AnswerButton({required this.text, required Vector2 position, required Vector2 size, required this.onPressed})
      : super(position: position, anchor: Anchor.center, size: size);

  @override
  Future<void> onLoad() async {
    // Circle button
    add(CircleComponent(
      radius: size.x / 2,
      paint: Paint()..color = Colors.orange.withOpacity(0.9),
      anchor: Anchor.center,
      position: size / 2,
    ));
    
    add(TextComponent(
      text: text,
      anchor: Anchor.center,
      position: size / 2,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Add a small scale effect on tap
    add(ScaleEffect.by(
      Vector2.all(1.1),
      EffectController(duration: 0.1, reverseDuration: 0.1),
    ));
    onPressed();
  }
}
