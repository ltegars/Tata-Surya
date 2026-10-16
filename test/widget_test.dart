import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jelajah_tata_surya/data/data.dart';
import 'package:jelajah_tata_surya/main.dart';
import 'package:jelajah_tata_surya/models/planet.dart';
import 'package:jelajah_tata_surya/presentation/planet/planet.dart';
import 'package:jelajah_tata_surya/presentation/quiz/quiz.dart';

void main() {
  group('Phase 2 Data Layer Verification', () {
    test('Planet dataset contains 8 planets with valid Indonesian information', () {
      expect(PlanetData.planets.length, 8);

      final names = PlanetData.planets.map((p) => p.name).toList();
      expect(names, [
        'Merkurius',
        'Venus',
        'Bumi',
        'Mars',
        'Jupiter',
        'Saturnus',
        'Uranus',
        'Neptunus',
      ]);

      for (final planet in PlanetData.planets) {
        expect(planet.id.isNotEmpty, true);
        expect(planet.name.isNotEmpty, true);
        expect(planet.type.isNotEmpty, true);
        expect(planet.description.isNotEmpty, true);
        expect(planet.diameter.isNotEmpty, true);
        expect(planet.distanceFromSun.isNotEmpty, true);
        expect(planet.temperature.isNotEmpty, true);
        expect(planet.funFact.isNotEmpty, true);
      }
    });

    test('Fact dataset contains educational facts including Jupiter', () {
      expect(FactData.facts.isNotEmpty, true);
      final featured = FactData.featuredFact;
      expect(featured.fact.contains('Jupiter'), true);
      expect(featured.fact.contains('...'), false); // No truncation
    });
  });

  group('Phase 2 Navigation Shell & Home Screen Verification', () {
    testWidgets('Home screen renders header, hero, features, and tahukah kamu', (WidgetTester tester) async {
      await tester.pumpWidget(const JelajahTataSuryaApp());
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Jelajah Tata Surya'), findsOneWidget);

      // Hero
      expect(find.text('Halo, Penjelajah!'), findsOneWidget);
      expect(find.text('Jelajahi\nTata Surya'), findsOneWidget);
      expect(find.text('Kenali planet, temukan fakta menarik, dan jelajahi luar angkasa.'), findsOneWidget);
      expect(find.text('Mulai Eksplorasi →'), findsOneWidget);

      // Fitur Utama
      expect(find.text('Fitur Utama'), findsOneWidget);
      expect(find.text('Planet Explorer'), findsOneWidget);
      expect(find.text('Kenali 8 planet'), findsOneWidget);
      expect(find.text('Tata Surya'), findsOneWidget);
      expect(find.text('Lihat gerakan planet'), findsOneWidget);
      expect(find.text('AR Explorer'), findsOneWidget);
      expect(find.text('Lihat planet di sekitarmu'), findsOneWidget);
      expect(find.text('Kuis Tata Surya'), findsOneWidget);
      expect(find.text('Uji pengetahuanmu'), findsOneWidget);

      // Tahukah Kamu?
      expect(find.text('Tahukah Kamu?'), findsOneWidget);
      expect(find.text('Jupiter adalah planet terbesar di Tata Surya.'), findsOneWidget);
      expect(find.text('Pelajari lebih lanjut'), findsOneWidget);

      // Bottom Navigation items
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Planet'), findsOneWidget);
      expect(find.text('AR'), findsOneWidget);
      expect(find.text('Quiz'), findsOneWidget);
    });

    // Phase 3: Planet tab now shows real PlanetExplorerScreen
    testWidgets('Bottom navigation switches between all 4 tabs smoothly', (WidgetTester tester) async {
      await tester.pumpWidget(const JelajahTataSuryaApp());
      await tester.pumpAndSettle();

      // Tap Planet tab (Tab 1) — now real PlanetExplorerScreen
      await tester.tap(find.text('Planet').last);
      await tester.pumpAndSettle();
      // PlanetExplorerScreen shows heading 'Planet' and subtitle
      expect(find.text('Kenali planet-planet di Tata Surya'), findsOneWidget);
      // First planet card (Merkurius) is in viewport
      expect(find.text('Merkurius'), findsOneWidget);

      // Tap AR tab (Tab 2)
      await tester.tap(find.text('AR'));
      await tester.pumpAndSettle();
      expect(find.text('AR Explorer'), findsOneWidget);

      // Tap Quiz tab (Tab 3)
      await tester.tap(find.text('Quiz'));
      await tester.pumpAndSettle();
      // QuizScreen AppBar shows 'Kuis Tata Surya'
      expect(find.text('Kuis Tata Surya'), findsWidgets);
      // The first question is shown
      expect(find.text('Soal 1 dari 10'), findsOneWidget);

      // Return home via Beranda tab button
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.text('Halo, Penjelajah!'), findsOneWidget);
    });

    // Phase 3: Hero CTA navigates to Planet Explorer
    testWidgets('Hero CTA navigates to Planet tab', (WidgetTester tester) async {
      await tester.pumpWidget(const JelajahTataSuryaApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mulai Eksplorasi →'));
      await tester.pumpAndSettle();
      // PlanetExplorerScreen subtitle is visible
      expect(find.text('Kenali planet-planet di Tata Surya'), findsOneWidget);

      // Back button in PlanetExplorerScreen returns to Beranda
      await tester.tap(find.byTooltip('Kembali'));
      await tester.pumpAndSettle();
      expect(find.text('Halo, Penjelajah!'), findsOneWidget);
    });
  });

  group('Phase 4C AR Explorer Verification', () {
    final earth = PlanetData.planets.firstWhere((p) => p.id == 'earth');
    final mars = PlanetData.planets.firstWhere((p) => p.id == 'mars');

    setUp(() {
      PlanetArScreen.debugArSupportedOverride = false;
    });

    tearDown(() {
      PlanetArScreen.debugArSupportedOverride = null;
    });

    testWidgets('PlanetDetailScreen has active Buka AR button that opens PlanetArScreen for Earth', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlanetDetailScreen(planet: earth),
      ));
      await tester.pumpAndSettle();

      // Find 'Buka AR' button
      final bukaArButton = find.text('Buka AR');
      expect(bukaArButton, findsOneWidget);

      // Scroll down to make sure Buka AR is in view and tap it
      await tester.scrollUntilVisible(bukaArButton, 100);
      await tester.tap(bukaArButton);
      await tester.pumpAndSettle();

      // Should be on PlanetArScreen with Earth's name and AR Explorer tag
      expect(find.byType(PlanetArScreen), findsOneWidget);
      expect(find.text('Bumi'), findsWidgets);
      expect(find.text('AR Explorer'), findsOneWidget);
      // Fallback state on non-Android platform
      expect(find.text('AR tidak tersedia di perangkat ini.'), findsOneWidget);
      expect(find.text('Gunakan mode 3D untuk tetap menjelajahi planet.'), findsOneWidget);
    });

    testWidgets('PlanetDetailScreen opens PlanetArScreen for Mars with correct data', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlanetDetailScreen(planet: mars),
      ));
      await tester.pumpAndSettle();

      final bukaArButton = find.text('Buka AR');
      expect(bukaArButton, findsOneWidget);

      await tester.scrollUntilVisible(bukaArButton, 100);
      await tester.tap(bukaArButton);
      await tester.pumpAndSettle();

      expect(find.byType(PlanetArScreen), findsOneWidget);
      expect(find.text('Mars'), findsWidgets);
      expect(find.text('AR Explorer'), findsOneWidget);
      expect(find.text('AR tidak tersedia di perangkat ini.'), findsOneWidget);
    });

    testWidgets('PlanetArScreen displays graceful fallback on unsupported platforms', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlanetArScreen(
          planet: earth,
          isArSupported: false,
        ),
      ));
      await tester.pumpAndSettle();

      // Verify clear fallback text as specified in PRD
      expect(find.text('AR tidak tersedia di perangkat ini.'), findsOneWidget);
      expect(find.text('Gunakan mode 3D untuk tetap menjelajahi planet.'), findsOneWidget);
      expect(find.text('Jelajahi 3D'), findsOneWidget);
      expect(find.text('Kembali ke Detail Planet'), findsOneWidget);
    });

    testWidgets('PlanetArScreen renders educational instruction and fallback in AR mode', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlanetArScreen(
          planet: earth,
          isArSupported: true,
          viewerBuilder: (context, planet) => const SizedBox(
            key: Key('mock_ar_viewer'),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Verify mock viewer
      expect(find.byKey(const Key('mock_ar_viewer')), findsOneWidget);

      // Verify educational instructions
      expect(find.text('Jelajahi Bumi di dunia nyata'), findsOneWidget);
      expect(find.text('Tempatkan planet pada permukaan datar.'), findsOneWidget);
      expect(find.text('Permukaan Datar'), findsOneWidget);
      expect(find.text('Putar & Zoom'), findsOneWidget);
      expect(find.text('Buka Mode 3D'), findsOneWidget);
    });

    testWidgets('PlanetArScreen handles missing model asset gracefully', (WidgetTester tester) async {
      const missingModelPlanet = Planet(
        id: 'unknown',
        name: 'Planet Misterius',
        orderFromSun: 99,
        type: 'Eksoplanet',
        description: 'Deskripsi tes',
        diameter: '1.000 km',
        distanceFromSun: '999 juta km',
        temperature: '0°C',
        moons: 0,
        imageAsset: 'assets/images/planets/earth.png',
        model3dAsset: 'assets/models/non_existent.glb',
        audioAsset: 'assets/audio/earth.mp3',
        funFact: 'Fakta tes',
      );

      await tester.pumpWidget(const MaterialApp(
        home: PlanetArScreen(
          planet: missingModelPlanet,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Model 3D belum tersedia'), findsOneWidget);
      expect(find.text('Kembali ke Detail Planet'), findsOneWidget);
    });

    testWidgets('PlanetArScreen back button pops back to previous screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PlanetDetailScreen(planet: earth),
      ));
      await tester.pumpAndSettle();

      final bukaArButton = find.text('Buka AR');
      await tester.scrollUntilVisible(bukaArButton, 100);
      await tester.tap(bukaArButton);
      await tester.pumpAndSettle();
      expect(find.byType(PlanetArScreen), findsOneWidget);

      // Tap back button
      await tester.tap(find.byTooltip('Kembali ke Detail Planet'));
      await tester.pumpAndSettle();

      // Returned to PlanetDetailScreen
      expect(find.byType(PlanetDetailScreen), findsOneWidget);
      expect(find.byType(PlanetArScreen), findsNothing);
    });
  });

  // =========================================================================
  // Phase 5A — Quiz Tests
  // =========================================================================

  group('Phase 5A Quiz Tata Surya Verification', () {
    testWidgets('QuizScreen renders title, soal counter, question and options', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Kuis Tata Surya'), findsOneWidget);
      expect(find.text('Soal 1 dari 10'), findsOneWidget);
      expect(find.text('Planet terbesar di Tata Surya adalah...'), findsOneWidget);
      expect(find.text('Bumi'), findsOneWidget);
      expect(find.text('Mars'), findsOneWidget);
      expect(find.text('Jupiter'), findsOneWidget);
      expect(find.text('Saturnus'), findsOneWidget);
      expect(find.text('Lanjut'), findsOneWidget);
    });

    testWidgets('Selecting correct answer shows correct feedback', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Jupiter'));
      await tester.pumpAndSettle();

      expect(find.text('Jawaban benar'), findsOneWidget);
    });

    testWidgets('Selecting wrong answer shows incorrect feedback', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bumi'));
      await tester.pumpAndSettle();

      expect(find.text('Jawaban kurang tepat'), findsOneWidget);
    });

    testWidgets('Answer cannot be changed after selection', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bumi'));
      await tester.pumpAndSettle();
      expect(find.text('Jawaban kurang tepat'), findsOneWidget);

      await tester.tap(find.text('Jupiter'));
      await tester.pumpAndSettle();
      expect(find.text('Jawaban kurang tepat'), findsOneWidget);
    });

    testWidgets('Lanjut button advances to next question', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Jupiter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lanjut'));
      await tester.pumpAndSettle();

      expect(find.text('Soal 2 dari 10'), findsOneWidget);
    });

    test('QuizData has exactly 10 well-formed questions', () {
      expect(QuizData.questions.length, 10);
      for (final q in QuizData.questions) {
        expect(q.options.length, 4);
        expect(q.correctAnswerIndex >= 0 && q.correctAnswerIndex < 4, true);
        expect(q.question.isNotEmpty, true);
        expect(q.explanation.isNotEmpty, true);
      }
    });

    testWidgets('After all 10 questions QuizResultScreen is shown', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      final questions = QuizData.questions;
      for (var i = 0; i < questions.length; i++) {
        final correctOption = questions[i].options[questions[i].correctAnswerIndex];
        await tester.scrollUntilVisible(find.text(correctOption).first, 200);
        await tester.tap(find.text(correctOption).first);
        await tester.pumpAndSettle();

        if (i == questions.length - 1) {
          await tester.scrollUntilVisible(find.text('Lihat Hasil'), 200);
          await tester.tap(find.text('Lihat Hasil'));
        } else {
          await tester.scrollUntilVisible(find.text('Lanjut'), 200);
          await tester.tap(find.text('Lanjut'));
        }
        await tester.pumpAndSettle();
      }

      expect(find.byType(QuizResultScreen), findsOneWidget);
      expect(find.text('Kuis Selesai'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);
      expect(find.text('Kembali ke Beranda'), findsOneWidget);
    });

    testWidgets('Coba Lagi resets quiz to first question', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      final questions = QuizData.questions;
      for (var i = 0; i < questions.length; i++) {
        final correctOption = questions[i].options[questions[i].correctAnswerIndex];
        await tester.scrollUntilVisible(find.text(correctOption).first, 200);
        await tester.tap(find.text(correctOption).first);
        await tester.pumpAndSettle();

        if (i == questions.length - 1) {
          await tester.scrollUntilVisible(find.text('Lihat Hasil'), 200);
          await tester.tap(find.text('Lihat Hasil'));
        } else {
          await tester.scrollUntilVisible(find.text('Lanjut'), 200);
          await tester.tap(find.text('Lanjut'));
        }
        await tester.pumpAndSettle();
      }

      expect(find.byType(QuizResultScreen), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.text('Soal 1 dari 10'), findsOneWidget);
    });
  });

  // =========================================================================
  // Phase 5A — Exit Dialog Tests
  // =========================================================================

  group('Phase 5A Quiz Exit Dialog Verification', () {
    testWidgets('Back button visible when onExitToHome is provided', (WidgetTester tester) async {
      bool exited = false;
      await tester.pumpWidget(MaterialApp(
        home: QuizScreen(onExitToHome: () => exited = true),
      ));
      await tester.pumpAndSettle();

      // Arrow back button should be visible
      expect(find.byTooltip('Keluar dari kuis'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(exited, false);
    });

    testWidgets('Back button NOT visible when onExitToHome is null', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: QuizScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });

    testWidgets('Tapping back button shows exit confirmation dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: QuizScreen(onExitToHome: () {}),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Keluar dari kuis'));
      await tester.pumpAndSettle();

      // Dialog content
      expect(find.text('Keluar dari kuis?'), findsOneWidget);
      expect(
        find.text('Jawaban dan progres kuis saat ini akan hilang.'),
        findsOneWidget,
      );
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);
    });

    testWidgets('Tapping Batal dismisses dialog and stays in quiz', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: QuizScreen(onExitToHome: () {}),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Keluar dari kuis'));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari kuis?'), findsOneWidget);

      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // Dialog dismissed, still on quiz
      expect(find.text('Keluar dari kuis?'), findsNothing);
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.text('Soal 1 dari 10'), findsOneWidget);
    });

    testWidgets('Tapping Keluar calls onExitToHome callback', (WidgetTester tester) async {
      bool exited = false;
      await tester.pumpWidget(MaterialApp(
        home: QuizScreen(onExitToHome: () => exited = true),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Keluar dari kuis'));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari kuis?'), findsOneWidget);

      await tester.tap(find.text('Keluar'));
      await tester.pumpAndSettle();

      // Callback was invoked
      expect(exited, true);
      // Dialog dismissed
      expect(find.text('Keluar dari kuis?'), findsNothing);
    });
  });

  // =========================================================================
  // Phase 5B — Quiz Navigation Bugfix Verification
  // =========================================================================

  group('Phase 5B Quiz Navigation Bugfix Verification', () {
    testWidgets('1 & 2: Quiz Result shows Kembali ke Beranda and tapping it returns to Home via MainNavigationShell', (WidgetTester tester) async {
      await tester.pumpWidget(const JelajahTataSuryaApp());
      await tester.pumpAndSettle();

      // Navigate to Quiz tab (Tab 3)
      await tester.tap(find.text('Quiz'));
      await tester.pumpAndSettle();

      // Complete all 10 questions
      final questions = QuizData.questions;
      for (var i = 0; i < questions.length; i++) {
        final correctOption = questions[i].options[questions[i].correctAnswerIndex];
        await tester.scrollUntilVisible(find.text(correctOption).first, 200);
        await tester.tap(find.text(correctOption).first);
        await tester.pumpAndSettle();

        if (i == questions.length - 1) {
          await tester.scrollUntilVisible(find.text('Lihat Hasil'), 200);
          await tester.tap(find.text('Lihat Hasil'));
        } else {
          await tester.scrollUntilVisible(find.text('Lanjut'), 200);
          await tester.tap(find.text('Lanjut'));
        }
        await tester.pumpAndSettle();
      }

      // Requirement 1: Quiz Result menampilkan "Kembali ke Beranda"
      expect(find.byType(QuizResultScreen), findsOneWidget);
      expect(find.text('Kembali ke Beranda'), findsOneWidget);

      // Requirement 2: Menekan "Kembali ke Beranda" mengarahkan ke Home
      await tester.tap(find.text('Kembali ke Beranda'));
      await tester.pumpAndSettle();

      // Home screen is visible and tab is Beranda
      expect(find.byType(QuizResultScreen), findsNothing);
      expect(find.text('Halo, Penjelajah!'), findsOneWidget);
      expect(find.text('Fitur Utama'), findsOneWidget);
    });

    testWidgets('3 to 7: Coba Lagi resets to Soal 1, preserves back button, and exit dialog allows Batal or Keluar to Home', (WidgetTester tester) async {
      await tester.pumpWidget(const JelajahTataSuryaApp());
      await tester.pumpAndSettle();

      // Navigate to Quiz tab
      await tester.tap(find.text('Quiz'));
      await tester.pumpAndSettle();

      // Complete all 10 questions
      final questions = QuizData.questions;
      for (var i = 0; i < questions.length; i++) {
        final correctOption = questions[i].options[questions[i].correctAnswerIndex];
        await tester.scrollUntilVisible(find.text(correctOption).first, 200);
        await tester.tap(find.text(correctOption).first);
        await tester.pumpAndSettle();

        if (i == questions.length - 1) {
          await tester.scrollUntilVisible(find.text('Lihat Hasil'), 200);
          await tester.tap(find.text('Lihat Hasil'));
        } else {
          await tester.scrollUntilVisible(find.text('Lanjut'), 200);
          await tester.tap(find.text('Lanjut'));
        }
        await tester.pumpAndSettle();
      }

      expect(find.byType(QuizResultScreen), findsOneWidget);

      // Tap "Coba Lagi"
      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();

      // Requirement 3: "Coba Lagi" mengembalikan Quiz ke Soal 1
      expect(find.byType(QuizResultScreen), findsNothing);
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.text('Soal 1 dari 10'), findsOneWidget);

      // Requirement 4: Setelah Coba Lagi, tombol keluar/back tetap tersedia
      final exitButton = find.byTooltip('Keluar dari kuis');
      expect(exitButton, findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Requirement 5: Menekan tombol keluar → dialog muncul
      await tester.tap(exitButton);
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari kuis?'), findsOneWidget);
      expect(find.text('Jawaban dan progres kuis saat ini akan hilang.'), findsOneWidget);
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);

      // Requirement 6: Memilih Batal → tetap di Quiz
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari kuis?'), findsNothing);
      expect(find.byType(QuizScreen), findsOneWidget);
      expect(find.text('Soal 1 dari 10'), findsOneWidget);

      // Requirement 7: Memilih Keluar → kembali ke Home
      await tester.tap(exitButton);
      await tester.pumpAndSettle();
      expect(find.text('Keluar dari kuis?'), findsOneWidget);

      await tester.tap(find.text('Keluar'));
      await tester.pumpAndSettle();

      expect(find.text('Keluar dari kuis?'), findsNothing);
      expect(find.text('Halo, Penjelajah!'), findsOneWidget);
      expect(find.text('Fitur Utama'), findsOneWidget);
    });
  });
}

