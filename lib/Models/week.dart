class Week {
  int data;

  Week({required this.data});

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(data: json['data']);
  }
}
