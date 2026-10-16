/// Planet Data Model
/// Defined according to PRD_SYSTEM.md Section 9
class Planet {
  final String id;
  final String name;
  final int orderFromSun;
  final String type;
  final String description;
  final String diameter;
  final String distanceFromSun;
  final String temperature;
  final int moons;
  final String imageAsset;
  final String model3dAsset;
  final String audioAsset;
  final String funFact;

  const Planet({
    required this.id,
    required this.name,
    required this.orderFromSun,
    required this.type,
    required this.description,
    required this.diameter,
    required this.distanceFromSun,
    required this.temperature,
    required this.moons,
    required this.imageAsset,
    required this.model3dAsset,
    required this.audioAsset,
    required this.funFact,
  });
}
