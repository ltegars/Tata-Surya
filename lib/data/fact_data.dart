import '../models/fact.dart';

/// Local dataset for "Tahukah Kamu?" section on Home screen
/// As specified in PRD_DESIGN.md Section 15
abstract final class FactData {
  static const List<Fact> facts = [
    Fact(
      id: 'fact-jupiter-size',
      title: 'Planet Raksasa',
      fact: 'Jupiter adalah planet terbesar di Tata Surya.',
      planetId: 'jupiter',
      planetName: 'Jupiter',
    ),
    Fact(
      id: 'fact-saturn-density',
      title: 'Massa Jenis Ringan',
      fact: 'Kerapatan planet Saturnus lebih kecil daripada air, sehingga secara teori ia bisa mengapung di lautan air raksasa.',
      planetId: 'saturn',
      planetName: 'Saturnus',
    ),
    Fact(
      id: 'fact-venus-heat',
      title: 'Planet Terpanas',
      fact: 'Venus adalah planet paling panas di Tata Surya akibat efek rumah kaca yang sangat pekat di atmosfernya.',
      planetId: 'venus',
      planetName: 'Venus',
    ),
    Fact(
      id: 'fact-mars-volcano',
      title: 'Gunung Tertinggi',
      fact: 'Gunung Olympus Mons di Mars memiliki ketinggian hampir tiga kali lipat tinggi Gunung Everest di Bumi.',
      planetId: 'mars',
      planetName: 'Mars',
    ),
    Fact(
      id: 'fact-neptune-wind',
      title: 'Angin Tercepat',
      fact: 'Kecepatan badai angin di Neptunus dapat melampaui 2.000 kilometer per jam, yang tercepat di Tata Surya.',
      planetId: 'neptune',
      planetName: 'Neptunus',
    ),
  ];

  /// Returns the featured fact for the Home screen
  static Fact get featuredFact => facts.first;
}
