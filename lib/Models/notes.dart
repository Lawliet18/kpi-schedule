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
      lessonId: json['lesson_id'] as String,
      dateNotes: json['notes_date'] as String,
      description: json['description'] as String,
      imagePath: json['image_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lesson_id'] = lessonId;
    data['notes_date'] = dateNotes;
    data['description'] = description;
    data['image_path'] = imagePath;
    return data;
  }
}
