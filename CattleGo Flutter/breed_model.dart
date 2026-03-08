// lib/models/breed_model.dart
class Breed {
  final String id;
  final String name;
  final String type;
  final String origin;
  final String description;
  final String milkYield;
  final String marketValue;
  final String keyTrait;
  final String imageUrl;
  final String modelSrc;
  final List<String> characteristics;

  const Breed({
    required this.id,
    required this.name,
    required this.type,
    required this.origin,
    required this.description,
    required this.milkYield,
    required this.marketValue,
    required this.keyTrait,
    required this.imageUrl,
    required this.modelSrc,
    required this.characteristics,
  });
}
