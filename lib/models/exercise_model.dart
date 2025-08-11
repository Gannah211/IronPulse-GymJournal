class Exercise {
  final int? Eid;
  final String Ename;
  Exercise({this.Eid, required this.Ename});

  Map<String, dynamic> toMap() {
    return {'Eid': Eid, 'Ename': Ename};
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(Eid: map['Eid'], Ename: map['Ename']);
  }
}
