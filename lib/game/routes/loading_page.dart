import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import '../components/ambient_dust.dart';
import '../flutter_web_2d_game.dart';

class LoadingPage extends PositionComponent with HasGameReference<FlutterWeb2DGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Ambient Dust
    add(AmbientDust(count: 50));

    // Add a simple loading text
    add(TextComponent(
      text: 'Loading...',
      textRenderer: TextPaint(
        style: GoogleFonts.lora(
          fontSize: 64,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: FlutterWeb2DGame.resolution / 2,
    ));

    // List of all images to preload
    final imagesToLoad = [
      'background.png', 'background2.png', 'background2a.png', 'background3.png', 'background4.png',
      'bear1.png', 'bear2.png', 'bear3.png', 'bear4.png',
      'bush1.png',
      'dialog.png', 'dialog2.png',
      'down.png',
      'forest1.png',
      'glad.png', 'good.png',
      'harimau1.png', 'harimau2.png', 'harimau3.png',
      'hi.png',
      'lari1.png', 'lari2.png', 'lari3.png',
      'left.png',
      'list.png',
      'manualbutton.png',
      'map.png',
      'mipmap.png', 'mipmap1.png', 'mipmap2.png',
      'mute.png',
      'next.png',
      'notabutton.png',
      'over.png',
      'playbutton.png',
      'right.png',
      'rimbarun.png',
      'scene1.png', 'scene1a.png', 'scene1b.png', 'scene1c.png',
      'settingbutton.png', 'settings.png',
      'sky1.png',
      'soalan.png',
      'tree1.png',
      'unmute.png',
      'up.png',
      'utamabutton.png',
      'victory.png',
    ];

    // Load all images
    await game.images.loadAll(imagesToLoad);

    // Fetch CSV Data
    await _fetchCsvData();

    // Load Text Content
    await _loadTextContent();

    // Once loaded, go to welcome page
    game.router.pushReplacementNamed('welcome');
  }

  Future<void> _loadTextContent() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/text_content.json');
      game.textContent = json.decode(jsonString);
    } catch (e) {
      debugPrint('Error loading text content: $e');
    }
  }

  Future<void> _fetchCsvData() async {
    const url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTrkt2G-3z1GcIyE9SRHHBLXd-Xk5nZrmG_hjR60WDuRB0bI0KYBJiqVvIaPGc9K0U8Aov-MVzJkq9T/pub?output=csv';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<List<dynamic>> rows = const CsvToListConverter().convert(response.body);
        // Skip header
        game.notaData = rows.skip(1).toList();
      } else {
        debugPrint('Failed to load CSV data');
      }
    } catch (e) {
      debugPrint('Error loading CSV: $e');
    }
  }
}
