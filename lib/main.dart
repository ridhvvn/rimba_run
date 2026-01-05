import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/flutter_web_2d_game.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 1920,
              height: 1080,
              child: ClipRect(
                child: GameWidget<FlutterWeb2DGame>.controlled(
                  gameFactory: FlutterWeb2DGame.new,
                  overlayBuilderMap: {
                  'QuestionOverlay': (context, game) {
                    return Center(
                      child: Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Question Popup', style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                game.overlays.remove('QuestionOverlay');
                                // Resume game or handle answer
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                },
              ),
            ),
            ),
          ),
        ),
      ),
    ),
  );
}
