/// Fact Data Model for "Tahukah Kamu?" Section
class Fact {
  final String id;
  final String title;
  final String fact;
  final String planetId;
  final String planetName;

  const Fact({
    required this.id,
    required this.title,
    required this.fact,
    required this.planetId,
    required this.planetName,
  });
}
