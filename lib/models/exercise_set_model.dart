class ExerciseSets {
  final int? ESid;
  final int? ExercisePerday_id;
  final int repsCount;
  final int Kgs;
  final int isFinsihed;

  ExerciseSets({
    this.ESid,
    this.ExercisePerday_id,
    required this.repsCount,
    required this.Kgs,
    required this.isFinsihed,
  });
  Map<String, dynamic> toMap() {
    return {
      'ESid': ESid,
      'ExercisePerday_id': ExercisePerday_id,
      'repsCount': repsCount,
      'Kgs': Kgs,
      'isFinsihed': isFinsihed,
    };
  }

  factory ExerciseSets.fromMap(Map<String, dynamic> map) {
    return ExerciseSets(
      ESid: map['ESid'],
      ExercisePerday_id: map['ExercisePerday_id'],
      repsCount: map['repsCount'],
      Kgs: map['Kgs'],
      isFinsihed: map['isFinsihed'],
    );
  }
   ExerciseSets copyWith({
    int? ESid,
    int? ExercisePerday_id,
    int? repsCount,
    int? Kgs,
    int? isFinsihed,
  }) {
    return ExerciseSets(
      ESid: ESid ?? this.ESid,
      ExercisePerday_id: ExercisePerday_id ?? this.ExercisePerday_id,
      repsCount: repsCount ?? this.repsCount,
      Kgs: Kgs ?? this.Kgs,
      isFinsihed: isFinsihed ?? this.isFinsihed,
    );
  }
}
