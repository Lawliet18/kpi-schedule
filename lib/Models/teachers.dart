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

  Teachers.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_id'];
    teacherName = json['teacher_name'];
    teacherFullName = json['teacher_full_name'];
    teacherShortName = json['teacher_short_name'];
    teacherUrl = json['teacher_url'];
    teacherRating = json['teacher_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacher_id'] = this.teacherId;
    data['teacher_name'] = this.teacherName;
    data['teacher_full_name'] = this.teacherFullName;
    data['teacher_short_name'] = this.teacherShortName;
    data['teacher_url'] = this.teacherUrl;
    data['teacher_rating'] = this.teacherRating;
    return data;
  }
}