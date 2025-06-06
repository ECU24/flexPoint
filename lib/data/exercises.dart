class Exercise {
  String name;
  String weight;
  String reps;
  String sets;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
    this.isCompleted = false,
  });

  toJson() {
    return {
      'name': name,
      'weight': weight,
      'reps': reps,
      'sets': sets,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] ?? '',
      weight: map['weight'] ?? '',
      reps: map['reps'] ?? '',
      sets: map['sets'] ?? '',
    );
  }
}
