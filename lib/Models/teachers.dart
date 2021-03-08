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
      teacherId: json['teacher_id'] as String,
      teacherName: json['teacher_name'] as String,
      teacherFullName: json['teacher_full_name'] as String,
      teacherShortName: json['teacher_short_name'] as String,
      teacherUrl: json['teacher_url'] as String,
      teacherRating: json['teacher_rating'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teacher_id'] = teacherId;
    data['teacher_name'] = teacherName;
    data['teacher_full_name'] = teacherFullName;
    data['teacher_short_name'] = teacherShortName;
    data['teacher_url'] = teacherUrl;
    data['teacher_rating'] = teacherRating;
    return data;
  }
}
