import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import '../flutter_web_2d_game.dart';

class AmbientDust extends Component {
  final int count;
  
  AmbientDust({this.count = 50});

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < count; i++) {
      add(DustSpeck());
    }
  }
}

class DustSpeck extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  late Vector2 velocity;
  late Paint _paint;
  final _random = Random();

  @override
  Future<void> onLoad() async {
    // Random position within resolution
    position = Vector2(
      _random.nextDouble() * FlutterWeb2DGame.resolution.x,
      _random.nextDouble() * FlutterWeb2DGame.resolution.y,
    );

    // Random size (tiny)
    final radius = _random.nextDouble() * 2 + 1; // 1 to 3 pixels radius
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    // Random velocity (slow drift)
    velocity = Vector2(
      (_random.nextDouble() - 0.5) * 50, // -25 to 25 speed x
      (_random.nextDouble() - 0.5) * 50, // -25 to 25 speed y
    );

    // Random white/grey color with opacity
    final brightness = _random.nextInt(55) + 200; // 200-255 (Light Grey to White)
    final opacity = _random.nextDouble() * 0.4 + 0.1; // 0.1 - 0.5 opacity
    _paint = Paint()
      ..color = Color.fromARGB((opacity * 255).toInt(), brightness, brightness, brightness)
      ..style = PaintingStyle.fill;
  }

  @override
  void update(double dt) {
    position += velocity * dt;

    // Wrap around logic
    if (position.x < -size.x) position.x = FlutterWeb2DGame.resolution.x + size.x;
    if (position.x > FlutterWeb2DGame.resolution.x + size.x) position.x = -size.x;
    if (position.y < -size.y) position.y = FlutterWeb2DGame.resolution.y + size.y;
    if (position.y > FlutterWeb2DGame.resolution.y + size.y) position.y = -size.y;
  }

  @override
  void render(Canvas canvas) {
    // Draw a circle at the center of the component
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _paint);
  }
}
