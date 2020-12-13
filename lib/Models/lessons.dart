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
  String description;
  String imagePath;
  String dateNotes;

  Lessons(
      {this.lessonId,
      this.dayName,
      this.lessonName,
      this.lessonNumber,
      this.lessonRoom,
      this.lessonType,
      this.teacherName,
      this.lessonWeek,
      this.timeStart,
      this.timeEnd,
      this.dateNotes,
      this.description,
      this.imagePath});

  Lessons.fromJson(Map<String, dynamic> json) {
    lessonId = json['lesson_id'];
    dayName = json['day_name'];
    lessonName = json['lesson_name'];
    lessonNumber = json['lesson_number'];
    lessonRoom = json['lesson_room'];
    lessonType = json['lesson_type'];
    teacherName = json['teacher_name'];
    lessonWeek = json['lesson_week'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    dateNotes = json['notes_date'];
    description = json['description'];
    imagePath = json['image_path'];
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
    return data;
  }
}
