import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'routes/welcome_page.dart';
import 'routes/game_page.dart';
import 'routes/end_page.dart';
import 'routes/settings_page.dart';
import 'routes/manual_page.dart';
import 'routes/map_page.dart';
import 'routes/scene_one_page.dart';
import 'routes/scene_two_page.dart';
import 'routes/scene_three_page.dart';
import 'routes/victory_page.dart';

class FlutterWeb2DGame extends FlameGame {
  static final Vector2 resolution = Vector2(1920, 1080);
  int currentLevel = 1;

  FlutterWeb2DGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: resolution.x,
            height: resolution.y,
          ),
        );

  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    await super.onLoad();

    router = RouterComponent(
      initialRoute: 'welcome',
      routes: {
        'welcome': Route(WelcomePage.new, maintainState: false),
        'manual': Route(ManualPage.new, maintainState: false),
        'game': Route(GamePage.new, maintainState: false),
        'end': Route(EndPage.new, maintainState: false),
        'settings': Route(SettingsPage.new, maintainState: false),
        'map': Route(MapPage.new, maintainState: false),
        'scene1': Route(SceneOnePage.new, maintainState: false),
        'scene2': Route(SceneTwoPage.new, maintainState: false),
        'scene3': Route(SceneThreePage.new, maintainState: false),
        'victory': Route(VictoryPage.new, maintainState: false),
      },
    );

    add(router);
  }
}
