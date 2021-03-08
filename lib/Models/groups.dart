class Groups {
  int groupId;
  String groupFullName;
  String groupPrefix;
  String groupOkr;
  String groupType;
  String groupUrl;

  Groups(
      {required this.groupId,
      required this.groupFullName,
      required this.groupPrefix,
      required this.groupOkr,
      required this.groupType,
      required this.groupUrl});

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
      groupId: json['group_id'] as int,
      groupFullName: json['group_full_name'] as String,
      groupPrefix: json['group_prefix'] as String,
      groupOkr: json['group_okr'] as String,
      groupType: json['group_type'] as String,
      groupUrl: json['group_url'] as String,
    );
  }
}
