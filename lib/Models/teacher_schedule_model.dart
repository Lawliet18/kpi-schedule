class TeacherSchedules {
  String lessonId;
  String dayName;
  String lessonFullName;
  String lessonNumber;
  String lessonRoom;
  String lessonType;
  String lessonWeek;
  String teacherId;
  String timeStart;
  String timeEnd;
  String groups;

  TeacherSchedules({
    required this.lessonId,
    required this.dayName,
    required this.lessonFullName,
    required this.lessonNumber,
    required this.lessonRoom,
    required this.lessonType,
    required this.lessonWeek,
    required this.timeStart,
    required this.timeEnd,
    required this.teacherId,
    required this.groups,
  });

  factory TeacherSchedules.fromJson(Map<String, dynamic> json) {
    List<String> groups = [];
    if (json['groups'] != null && json["groups"] is List<dynamic>) {
      print(json['groups']);
      json['groups'].forEach((v) {
        groups.add(v['group_full_name']);
      });
    }
    if (json["groups"] is String) {
      groups.add(json["groups"]);
    }
    return TeacherSchedules(
      lessonId: json['lesson_id'],
      dayName: json['day_name'],
      lessonFullName: json['lesson_full_name'],
      lessonNumber: json['lesson_number'],
      lessonRoom: json['lesson_room'],
      lessonType: json['lesson_type'],
      lessonWeek: json['lesson_week'],
      teacherId: json['teacher_id'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      groups: groups.join(' '),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lesson_id'] = this.lessonId;
    data['day_name'] = this.dayName;
    data['lesson_full_name'] = this.lessonFullName;
    data['lesson_number'] = this.lessonNumber;
    data['lesson_room'] = this.lessonRoom;
    data['lesson_type'] = this.lessonType;
    data['lesson_week'] = this.lessonWeek;
    data['teacher_id'] = this.teacherId;
    data['time_start'] = this.timeStart;
    data['time_end'] = this.timeEnd;
    data['groups'] = this.groups;
    return data;
  }
}
