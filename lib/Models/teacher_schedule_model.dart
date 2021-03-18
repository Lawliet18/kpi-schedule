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
    final groups = <String>[];
    if (json['groups'] != null && json["groups"] is List<dynamic>) {
      json['groups'].forEach((v) {
        groups.add(v['group_full_name'] as String);
      });
    }
    if (json["groups"] is String) {
      groups.add(json["groups"] as String);
    }
    return TeacherSchedules(
      lessonId: json['lesson_id'],
      dayName: json['day_name'],
      lessonFullName: json['lesson_full_name'],
      lessonNumber: json['lesson_number'],
      lessonRoom: json['lesson_room'],
      lessonType: json['lesson_type'],
      lessonWeek: json['lesson_week'],
      teacherId: json['teacher_id'] ?? '',
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      groups: groups.join(' '),
    );
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lesson_id'] = lessonId;
    data['day_name'] = dayName;
    data['lesson_full_name'] = lessonFullName;
    data['lesson_number'] = lessonNumber;
    data['lesson_room'] = lessonRoom;
    data['lesson_type'] = lessonType;
    data['lesson_week'] = lessonWeek;
    data['teacher_id'] = teacherId;
    data['time_start'] = timeStart;
    data['time_end'] = timeEnd;
    data['groups'] = groups;
    return data;
  }
}
