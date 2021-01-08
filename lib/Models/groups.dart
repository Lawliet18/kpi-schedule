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
      groupId: json['group_id'],
      groupFullName: json['group_full_name'],
      groupPrefix: json['group_prefix'],
      groupOkr: json['group_okr'],
      groupType: json['group_type'],
      groupUrl: json['group_url'],
    );
  }
}
