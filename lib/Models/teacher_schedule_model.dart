class TeacherSchedules {
  String lessonId;
  String dayName;
  String lessonFullName;
  String lessonNumber;
  String lessonRoom;
  String lessonType;
  String lessonWeek;
  String timeStart;
  String timeEnd;
  //List<Groups> groups;

  TeacherSchedules({
    this.lessonId,
    this.dayName,
    this.lessonFullName,
    this.lessonNumber,
    this.lessonRoom,
    this.lessonType,
    this.lessonWeek,
    this.timeStart,
    this.timeEnd,
    //this.groups
  });

  TeacherSchedules.fromJson(Map<String, dynamic> json) {
    lessonId = json['lesson_id'];
    dayName = json['day_name'];
    lessonFullName = json['lesson_full_name'];
    lessonNumber = json['lesson_number'];
    lessonRoom = json['lesson_room'];
    lessonType = json['lesson_type'];
    lessonWeek = json['lesson_week'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    // if (json['groups'] != null) {
    //   groups = new List<Groups>();
    //   json['groups'].forEach((v) {
    //     groups.add(new Groups.fromJson(v));
    //   });
    // }
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
    data['time_start'] = this.timeStart;
    data['time_end'] = this.timeEnd;
    return data;
  }
}

class Groups {
  int groupId;
  String groupFullName;

  Groups({this.groupId, this.groupFullName});

  Groups.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    groupFullName = json['group_full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_full_name'] = this.groupFullName;
    return data;
  }
}
