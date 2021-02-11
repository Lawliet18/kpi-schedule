class Lessons {
  String lessonId;
  String dayName;
  String lessonName;
  String lessonNumber;
  String lessonRoom;
  String lessonType;
  String teacherName;
  String lessonWeek;
  String timeStart;
  String timeEnd;
  String? description;
  String? imagePath;
  String? dateNotes;

  Lessons({
    required this.lessonId,
    required this.dayName,
    required this.lessonName,
    required this.lessonNumber,
    required this.lessonRoom,
    required this.lessonType,
    required this.teacherName,
    required this.lessonWeek,
    required this.timeStart,
    required this.timeEnd,
    this.dateNotes,
    this.description,
    this.imagePath,
  });

  factory Lessons.fromJson(Map<String, dynamic> json) {
    return Lessons(
      lessonId: json['lesson_id'],
      dayName: json['day_name'],
      lessonName: json['lesson_name'],
      lessonNumber: json['lesson_number'],
      lessonRoom: json['lesson_room'],
      lessonType: json['lesson_type'],
      teacherName: json['teacher_name'],
      lessonWeek: json['lesson_week'],
      timeStart: json['time_start'],
      timeEnd: json['time_end'],
      dateNotes: json['notes_date'],
      description: json['description'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lesson_id'] = this.lessonId;
    data['day_name'] = this.dayName;
    data['lesson_name'] = this.lessonName;
    data['lesson_number'] = this.lessonNumber;
    data['lesson_room'] = this.lessonRoom;
    data['lesson_type'] = this.lessonType;
    data['teacher_name'] = this.teacherName;
    data['lesson_week'] = this.lessonWeek;
    data['time_start'] = this.timeStart;
    data['time_end'] = this.timeEnd;
    data['notes_date'] = this.dateNotes;
    data['description'] = this.description;
    data['image_path'] = this.imagePath;
    return data;
  }
}
