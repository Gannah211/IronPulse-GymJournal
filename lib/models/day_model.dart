class Days {
  final int? Did;
  final String Dname;
  Days({this.Did, required this.Dname});

  Map<String, dynamic> toMap() {
    return {'Did': Did, 'Dname': Dname};
  }

  factory Days.fromMap(Map<String, dynamic> map) {
    return Days(Did: map['Did'], Dname: map['Dname']);
  }
}
