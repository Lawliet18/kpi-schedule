class Notes {
  String lessonId;
  String? description;
  String? imagePath;
  String? dateNotes;

  Notes({
    required this.lessonId,
    this.description,
    this.imagePath,
    this.dateNotes,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
        lessonId: json['lesson_id'],
        dateNotes: json['notes_date'],
        description: json['description'],
        imagePath: json['image_path']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lesson_id'] = this.lessonId;
    data['notes_date'] = this.dateNotes;
    data['description'] = this.description;
    data['image_path'] = this.imagePath;
    return data;
  }
}
