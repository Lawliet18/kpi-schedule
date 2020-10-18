class Week {
  int data;

  Week({this.data});

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(data: json['data']);
  }
}
