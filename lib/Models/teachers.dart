class Teachers {
  String teacherId;
  String teacherName;
  String teacherFullName;
  String teacherShortName;
  String teacherUrl;
  String teacherRating;

  Teachers(
      {required this.teacherId,
      required this.teacherName,
      required this.teacherFullName,
      required this.teacherShortName,
      required this.teacherUrl,
      required this.teacherRating});

  factory Teachers.fromJson(Map<String, dynamic> json) {
    return Teachers(
      teacherId: json['teacher_id'],
      teacherName: json['teacher_name'],
      teacherFullName: json['teacher_full_name'],
      teacherShortName: json['teacher_short_name'],
      teacherUrl: json['teacher_url'],
      teacherRating: json['teacher_rating'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['teacher_id'] = teacherId;
    data['teacher_name'] = teacherName;
    data['teacher_full_name'] = teacherFullName;
    data['teacher_short_name'] = teacherShortName;
    data['teacher_url'] = teacherUrl;
    data['teacher_rating'] = teacherRating;
    return data;
  }
}
