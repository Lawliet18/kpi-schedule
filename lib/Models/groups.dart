class Groups {
  int groupId;
  String groupFullName;
  String groupPrefix;
  String groupOkr;
  String groupType;
  String groupUrl;

  Groups(
      {this.groupId,
      this.groupFullName,
      this.groupPrefix,
      this.groupOkr,
      this.groupType,
      this.groupUrl});

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
