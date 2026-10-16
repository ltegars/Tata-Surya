import '../models/planet.dart';

/// Local dataset of the 8 planets in our Solar System
/// Language: Bahasa Indonesia, calibrated for SMP students (ages 12-15)
abstract final class PlanetData {
  static const List<Planet> planets = [
    Planet(
      id: 'mercury',
      name: 'Merkurius',
      orderFromSun: 1,
      type: 'Planet Kebumian (Terestrial)',
      description:
          'Merkurius adalah planet terkecil di Tata Surya dan yang paling dekat dengan Matahari. Permukaannya penuh kawah seperti Bulan dan tidak memiliki atmosfer tebal untuk menahan panas.',
      diameter: '4.879 km',
      distanceFromSun: '57,9 juta km',
      temperature: '167°C (-180°C hingga 430°C)',
      moons: 0,
      imageAsset: 'assets/images/planets/mercury.png',
      model3dAsset: 'assets/models/mercury.glb',
      audioAsset: 'assets/audio/mercury.mp3',
      funFact:
          'Meskipun paling dekat dengan Matahari, Merkurius bukanlah planet terpanas karena tidak memiliki efek rumah kaca atmosfer.',
    ),
    Planet(
      id: 'venus',
      name: 'Venus',
      orderFromSun: 2,
      type: 'Planet Kebumian (Terestrial)',
      description:
          'Venus sering disebut sebagai kembaran Bumi karena ukurannya yang mirip. Namun, atmosfer karbon dioksida yang sangat tebal menjadikannya planet paling panas di Tata Surya.',
      diameter: '12.104 km',
      distanceFromSun: '108,2 juta km',
      temperature: '464°C',
      moons: 0,
      imageAsset: 'assets/images/planets/venus.png',
      model3dAsset: 'assets/models/venus.glb',
      audioAsset: 'assets/audio/venus.mp3',
      funFact:
          'Satu hari di Venus lebih lama daripada satu tahunnya, dan ia berotasi searah jarum jam (berlawanan dari kebanyakan planet lain).',
    ),
    Planet(
      id: 'earth',
      name: 'Bumi',
      orderFromSun: 3,
      type: 'Planet Kebumian (Terestrial)',
      description:
          'Bumi adalah rumah kita, satu-satunya planet yang diketahui mendukung kehidupan berkat keberadaan air cair, atmosfer pelindung kaya oksigen, dan medan magnet yang kuat.',
      diameter: '12.742 km',
      distanceFromSun: '149,6 juta km',
      temperature: '15°C',
      moons: 1,
      imageAsset: 'assets/images/planets/earth.png',
      model3dAsset: 'assets/models/earth.glb',
      audioAsset: 'assets/audio/earth.mp3',
      funFact:
          'Sekitar 71% permukaan Bumi tertutup air, itulah mengapa Bumi tampak seperti marmer biru cerah dari luar angkasa.',
    ),
    Planet(
      id: 'mars',
      name: 'Mars',
      orderFromSun: 4,
      type: 'Planet Kebumian (Terestrial)',
      description:
          'Mars dijuluki "Planet Merah" karena tanahnya kaya akan besi oksida (karat). Mars memiliki gunung berapi tertinggi di Tata Surya, yaitu Olympus Mons, serta dua bulan kecil.',
      diameter: '6.779 km',
      distanceFromSun: '227,9 juta km',
      temperature: '-63°C',
      moons: 2,
      imageAsset: 'assets/images/planets/mars.png',
      model3dAsset: 'assets/models/mars.glb',
      audioAsset: 'assets/audio/mars.mp3',
      funFact:
          'Mars memiliki dua satelit alami bernama Phobos dan Deimos, yang dinamai dari dewa ketakutan dan teror dalam mitologi Yunani.',
    ),
    Planet(
      id: 'jupiter',
      name: 'Jupiter',
      orderFromSun: 5,
      type: 'Gas Raksasa (Gas Giant)',
      description:
          'Jupiter adalah planet terbesar di Tata Surya kita. Diameternya lebih dari 11 kali diameter Bumi. Planet ini terkenal dengan Bintik Merah Raksasa, sebuah badai besar yang berlangsung berabad-abad.',
      diameter: '139.820 km',
      distanceFromSun: '778,5 juta km',
      temperature: '-110°C',
      moons: 95,
      imageAsset: 'assets/images/planets/jupiter.png',
      model3dAsset: 'assets/models/jupiter.glb',
      audioAsset: 'assets/audio/jupiter.mp3',
      funFact:
          'Massa Jupiter lebih dari dua kali lipat gabungan seluruh planet lain di Tata Surya digabungkan bersama.',
    ),
    Planet(
      id: 'saturn',
      name: 'Saturnus',
      orderFromSun: 6,
      type: 'Gas Raksasa (Gas Giant)',
      description:
          'Saturnus terkenal dengan sistem cincinnya yang megah dan memukau, tersusun atas miliaran partikel es, batu, dan debu. Saturnus adalah planet kedua terbesar di Tata Surya.',
      diameter: '116.460 km',
      distanceFromSun: '1,43 miliar km',
      temperature: '-140°C',
      moons: 146,
      imageAsset: 'assets/images/planets/saturn.png',
      model3dAsset: 'assets/models/saturn.glb',
      audioAsset: 'assets/audio/saturn.mp3',
      funFact:
          'Kerapatan rata-rata Saturnus lebih rendah daripada air! Jika ada wadah air yang cukup raksasa, Saturnus akan mengapung di atasnya.',
    ),
    Planet(
      id: 'uranus',
      name: 'Uranus',
      orderFromSun: 7,
      type: 'Es Raksasa (Ice Giant)',
      description:
          'Uranus memiliki warna biru kehijauan khas akibat gas metana di atmosfernya. Yang unik, Uranus berotasi dengan kemiringan hampir 98 derajat, seolah berputar miring menyamping.',
      diameter: '50.724 km',
      distanceFromSun: '2,87 miliar km',
      temperature: '-195°C',
      moons: 28,
      imageAsset: 'assets/images/planets/uranus.png',
      model3dAsset: 'assets/models/uranus.glb',
      audioAsset: 'assets/audio/uranus.mp3',
      funFact:
          'Karena kemiringan rotasinya yang ekstrem, setiap kutub di Uranus mengalami 42 tahun siang hari terus-menerus diikuti 42 tahun malam terus-menerus.',
    ),
    Planet(
      id: 'neptune',
      name: 'Neptunus',
      orderFromSun: 8,
      type: 'Es Raksasa (Ice Giant)',
      description:
          'Neptunus adalah planet terjauh dari Matahari di Tata Surya. Planet biru gelap ini memiliki angin paling kencang di Tata Surya, dengan kecepatan mencapai lebih dari 2.000 km/jam.',
      diameter: '49.244 km',
      distanceFromSun: '4,50 miliar km',
      temperature: '-201°C',
      moons: 16,
      imageAsset: 'assets/images/planets/neptune.png',
      model3dAsset: 'assets/models/neptune.glb',
      audioAsset: 'assets/audio/neptune.mp3',
      funFact:
          'Neptunus adalah planet pertama yang keberadaannya diprediksi melalui perhitungan matematika sebelum pernah dilihat langsung melalui teleskop.',
    ),
  ];

  static Planet? getById(String id) {
    try {
      return planets.firstWhere((planet) => planet.id == id);
    } catch (_) {
      return null;
    }
  }
}
