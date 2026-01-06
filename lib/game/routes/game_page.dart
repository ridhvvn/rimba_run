import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class GamePage extends PositionComponent with HasGameReference<FlutterWeb2DGame>, TapCallbacks {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Ambient Dust
    add(AmbientDust(count: 50));

    add(TextComponent(
      text: 'Game Loop',  
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y / 3),
      anchor: Anchor.center,
    ));

    add(TextComponent(
      text: 'Tap to End Game', 
      position: Vector2(FlutterWeb2DGame.resolution.x / 2, FlutterWeb2DGame.resolution.y / 2),
      anchor: Anchor.center,
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.router.pushReplacementNamed('end');
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;
}
