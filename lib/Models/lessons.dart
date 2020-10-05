class Lessons {
  String lessonId;
  String groupId;
  String dayNumber;
  String dayName;
  String lessonName;
  String lessonFullName;
  String lessonNumber;
  String lessonRoom;
  String lessonType;
  String teacherName;
  String lessonWeek;
  String timeStart;
  String timeEnd;
  String rate;
  List<Teachers> teachers;

  Lessons({
    this.lessonId,
    this.groupId,
    this.dayNumber,
    this.dayName,
    this.lessonName,
    this.lessonFullName,
    this.lessonNumber,
    this.lessonRoom,
    this.lessonType,
    this.teacherName,
    this.lessonWeek,
    this.timeStart,
    this.timeEnd,
    this.rate,
    this.teachers,
  });

  factory Lessons.fromJson(Map<String, dynamic> json) {
    var list = json['teachers'] as List;
    List<Teachers> imagesList = list.map((i) => Teachers.fromJson(i)).toList();
    return Lessons(
      lessonId: json['lesson_id'],
      groupId: json['group_id'],
      dayNumber: json['day_number'],
      dayName: json['day_name'],
      lessonName: json['lesson_name'],
      lessonFullName: json['lesson_full_name'],
      lessonNumber: json['lesson_number'],
      lessonRoom: json['lesson_room'],
      lessonType: json['lesson_type'],
      teacherName: json['teacher_name'],
      lessonWeek: json['lesson_week'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      rate: json['rate'],
      teachers: imagesList,
    );
  }
}

class Teachers {
  String teacherId;
  String teacherName;
  String teacherFullName;
  String teacherShortName;
  String teacherUrl;
  String teacherRating;

  Teachers(
      {this.teacherId,
      this.teacherName,
      this.teacherFullName,
      this.teacherShortName,
      this.teacherUrl,
      this.teacherRating});

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
}
