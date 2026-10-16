import '../models/quiz_question.dart';

/// Quiz Data — 10 soal Tata Surya untuk siswa SMP (usia 12–15 tahun)
/// Mencakup: Matahari, Merkurius, Venus, Bumi, Mars, Jupiter,
///           Saturnus, Uranus, Neptunus, dan konsep dasar Tata Surya.
abstract final class QuizData {
  static const List<QuizQuestion> questions = [
    // 1 — Jupiter (planet terbesar)
    QuizQuestion(
      question: 'Planet terbesar di Tata Surya adalah...',
      options: ['Bumi', 'Mars', 'Jupiter', 'Saturnus'],
      correctAnswerIndex: 2,
      explanation:
          'Jupiter adalah planet terbesar di Tata Surya. Diameternya '
          'sekitar 142.984 km, kira-kira 11 kali diameter Bumi.',
    ),

    // 2 — Matahari
    QuizQuestion(
      question: 'Matahari tersusun terutama dari unsur...',
      options: ['Oksigen dan Nitrogen', 'Hidrogen dan Helium', 'Besi dan Nikel', 'Karbon dan Silikon'],
      correctAnswerIndex: 1,
      explanation:
          'Matahari tersusun terutama dari hidrogen (sekitar 75%) dan '
          'helium (sekitar 24%). Energi Matahari berasal dari reaksi '
          'fusi nuklir hidrogen menjadi helium.',
    ),

    // 3 — Merkurius (terdekat ke Matahari)
    QuizQuestion(
      question: 'Planet yang paling dekat dengan Matahari adalah...',
      options: ['Venus', 'Mars', 'Bumi', 'Merkurius'],
      correctAnswerIndex: 3,
      explanation:
          'Merkurius adalah planet yang paling dekat dengan Matahari, '
          'berjarak rata-rata sekitar 57,9 juta km.',
    ),

    // 4 — Bumi (satu-satunya dengan kehidupan)
    QuizQuestion(
      question: 'Planet manakah yang saat ini diketahui memiliki kehidupan?',
      options: ['Mars', 'Venus', 'Bumi', 'Europa'],
      correctAnswerIndex: 2,
      explanation:
          'Bumi adalah satu-satunya planet yang diketahui memiliki '
          'kehidupan. Faktor pendukungnya antara lain air cair, '
          'atmosfer yang sesuai, dan jarak yang tepat dari Matahari.',
    ),

    // 5 — Saturnus (cincin paling terkenal)
    QuizQuestion(
      question: 'Planet manakah yang terkenal karena memiliki cincin yang sangat indah?',
      options: ['Jupiter', 'Saturnus', 'Uranus', 'Neptunus'],
      correctAnswerIndex: 1,
      explanation:
          'Saturnus terkenal dengan sistem cincinnya yang menakjubkan, '
          'terbuat dari partikel es dan batu yang mengorbit planet tersebut. '
          'Cincinnya dapat terlihat dengan teleskop kecil dari Bumi.',
    ),

    // 6 — Mars (Planet Merah)
    QuizQuestion(
      question: 'Mars sering disebut "Planet Merah" karena...',
      options: [
        'Suhunya sangat tinggi',
        'Permukaannya dipenuhi besi oksida (karat)',
        'Atmosfernya berwarna merah',
        'Banyak gunung berapi aktif'
      ],
      correctAnswerIndex: 1,
      explanation:
          'Warna merah Mars berasal dari besi oksida (karat) yang '
          'banyak terdapat di permukaan dan debu atmosfernya.',
    ),

    // 7 — Venus (planet terpanas)
    QuizQuestion(
      question: 'Planet manakah yang memiliki suhu permukaan paling tinggi di Tata Surya?',
      options: ['Merkurius', 'Venus', 'Mars', 'Jupiter'],
      correctAnswerIndex: 1,
      explanation:
          'Meski Merkurius lebih dekat ke Matahari, Venus justru lebih '
          'panas karena efek rumah kaca yang ekstrem. Suhunya mencapai '
          'sekitar 465°C.',
    ),

    // 8 — Uranus (berotasi miring)
    QuizQuestion(
      question: 'Planet manakah yang berotasi dengan sumbu yang hampir sejajar dengan bidang orbitnya?',
      options: ['Saturnus', 'Neptunus', 'Jupiter', 'Uranus'],
      correctAnswerIndex: 3,
      explanation:
          'Uranus berotasi dengan kemiringan sumbu sekitar 98°, hampir '
          'berbaring ke samping. Akibatnya, musim di Uranus berlangsung '
          'selama puluhan tahun.',
    ),

    // 9 — Neptunus (planet terjauh)
    QuizQuestion(
      question: 'Planet terjauh dari Matahari dalam Tata Surya kita adalah...',
      options: ['Saturnus', 'Uranus', 'Neptunus', 'Pluto'],
      correctAnswerIndex: 2,
      explanation:
          'Neptunus adalah planet kedelapan sekaligus terjauh dari '
          'Matahari, berjarak rata-rata sekitar 4,5 miliar km. '
          'Pluto kini diklasifikasikan sebagai planet kerdil.',
    ),

    // 10 — Konsep dasar: jumlah planet
    QuizQuestion(
      question: 'Berapa jumlah planet di Tata Surya menurut definisi IAU saat ini?',
      options: ['7', '8', '9', '10'],
      correctAnswerIndex: 1,
      explanation:
          'Sejak tahun 2006, International Astronomical Union (IAU) '
          'mengakui 8 planet: Merkurius, Venus, Bumi, Mars, Jupiter, '
          'Saturnus, Uranus, dan Neptunus. Pluto diklasifikasikan '
          'ulang sebagai planet kerdil.',
    ),
  ];
}
