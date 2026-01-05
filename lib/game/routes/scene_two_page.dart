import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../flutter_web_2d_game.dart';

class QuestionData {
  final String image;
  final String correctAnswer;
  QuestionData(this.image, this.correctAnswer);
}

class SceneTwoPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  late final SpriteComponent background;
  late final SpriteComponent soalan;
  
  // Pairs of components (Lari & Harimau)
  final List<List<SpriteComponent>> pairs = [];
  int _currentPairIndex = 0;

  // Questions
  final List<QuestionData> _questions = [
    QuestionData('soalan.png', 'A'),
    QuestionData('soalan.png', 'B'),
    QuestionData('soalan.png', 'C'),
  ];
  int _currentQuestionIndex = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Background
    add(SpriteComponent(
      sprite: await game.loadSprite('background3.png'),
      size: FlutterWeb2DGame.resolution,
    ));

    // 3. Soalan (Question)
    soalan = SpriteComponent(
      sprite: await game.loadSprite(_questions[_currentQuestionIndex].image),
      anchor: Anchor.topCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, 50),
    );
    add(soalan);

    // 4. Answer Buttons (A, B, C, D)
    final buttonY = FlutterWeb2DGame.resolution.y * 0.85;
    final buttonSpacing = 200.0;
    final startX = (FlutterWeb2DGame.resolution.x - (buttonSpacing * 3)) / 2;

    final options = ['A', 'B', 'C', 'D'];
    for (var i = 0; i < options.length; i++) {
      add(AnswerButton(
        text: options[i],
        position: Vector2(startX + (i * buttonSpacing), buttonY),
        onPressed: () => _checkAnswer(options[i]),
      ));
    }

    // 2. Pairs (Lari & Harimau)
    // We load all 3 pairs but start them invisible (except the first one maybe, or handle in init)
    
    // Pair 1
    final lari1 = SpriteComponent(
      sprite: await game.loadSprite('lari1.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.8, FlutterWeb2DGame.resolution.y * 0.8),
    );
    final harimau1 = SpriteComponent(
      sprite: await game.loadSprite('harimau1.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.2, FlutterWeb2DGame.resolution.y * 0.8),
    );
    pairs.add([lari1, harimau1]);

    // Pair 2
    final lari2 = SpriteComponent(
      sprite: await game.loadSprite('lari2.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.7, FlutterWeb2DGame.resolution.y * 0.8),
    );
    final harimau2 = SpriteComponent(
      sprite: await game.loadSprite('harimau2.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.3, FlutterWeb2DGame.resolution.y * 0.8),
    );
    pairs.add([lari2, harimau2]);

    // Pair 3
    final lari3 = SpriteComponent(
      sprite: await game.loadSprite('lari3.png'),
      anchor: Anchor.bottomCenter,
      position: Vector2(FlutterWeb2DGame.resolution.x * 0.6, FlutterWeb2DGame.resolution.y * 0.8),
    );
    final harimau3 = SpriteComponent(
      sprite: await game.loadSprite('harimau3.png'),
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
      } else {
        // Already safe (lari1), move to next question
        _nextQuestion();
      }
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
      _loadQuestionSprite();
    } else {
      // All questions done -> Increment Level -> Map
      game.currentLevel++;
      game.router.pushReplacementNamed('map');
    }
  }
  
  Future<void> _loadQuestionSprite() async {
    soalan.sprite = await game.loadSprite(_questions[_currentQuestionIndex].image);
  }
}

class AnswerButton extends PositionComponent with TapCallbacks {
  final String text;
  final VoidCallback onPressed;

  AnswerButton({required this.text, required Vector2 position, required this.onPressed})
      : super(position: position, anchor: Anchor.center, size: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    // Simple circle button
    add(CircleComponent(
      radius: 50,
      paint: Paint()..color = Colors.orange,
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
      Vector2.all(1.2),
      EffectController(duration: 0.1, reverseDuration: 0.1),
    ));
    onPressed();
  }
}
