class ExercisePerDay {
  final int? EPDid;
  final int? day_id;
  final int? Exercise_id;
  final int Exercise_order;

  ExercisePerDay({
    this.EPDid,
    this.day_id,
    this.Exercise_id,
    required this.Exercise_order,
  });

  Map<String, dynamic> toMap() {
    return {
      'EPDid': EPDid,
      'day_id': day_id,
      'Exercise_id': Exercise_id,
      'Exercise_order': Exercise_order,
    };
  }

  factory ExercisePerDay.fromMap(Map<String, dynamic> map) {
    return ExercisePerDay(
      EPDid: map['EPDid'],
      day_id: map['day_id'],
      Exercise_id: map['Exercise_id'],
      Exercise_order: map['Exercise_order'],
    );
  }
}
