class BoatType {
  final String id;
  final String name;

  BoatType({required this.id, required this.name});

  factory BoatType.fromMap(Map<String, dynamic> map, String id) {
    return BoatType(
      id: id,
      name: map['name'] as String? ?? '',
    );
  }
}
