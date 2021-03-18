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
      lessonId: json['lesson_id'] as String,
      dayName: json['day_name'] as String,
      lessonName: json['lesson_name'] as String,
      lessonNumber: json['lesson_number'] as String,
      lessonRoom: json['lesson_room'] as String,
      lessonType: json['lesson_type'] as String,
      teacherName: json['teacher_name'] as String,
      lessonWeek: json['lesson_week'] as String,
      timeStart: json['time_start'] as String,
      timeEnd: json['time_end'] as String,
      dateNotes: json['notes_date'],
      description: json['description'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lesson_id'] = lessonId;
    data['day_name'] = dayName;
    data['lesson_name'] = lessonName;
    data['lesson_number'] = lessonNumber;
    data['lesson_room'] = lessonRoom;
    data['lesson_type'] = lessonType;
    data['teacher_name'] = teacherName;
    data['lesson_week'] = lessonWeek;
    data['time_start'] = timeStart;
    data['time_end'] = timeEnd;
    data['notes_date'] = dateNotes;
    data['description'] = description;
    data['image_path'] = imagePath;
    return data;
  }
}
