class StatusesListBean {
  int id;
  String content;
  bool isPrivate;
  bool isLucky;
  int commentCount;
  String dateAdded;
  String userAlias;
  String userDisplayName;
  String userIconUrl;
  int userId;
  String userGuid;

  StatusesListBean(
      {this.id,
      this.content,
      this.isPrivate,
      this.isLucky,
      this.commentCount,
      this.dateAdded,
      this.userAlias,
      this.userDisplayName,
      this.userIconUrl,
      this.userId,
      this.userGuid});

  StatusesListBean.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    content = json['Content'];
    isPrivate = json['IsPrivate'];
    isLucky = json['IsLucky'];
    commentCount = json['CommentCount'];
    dateAdded = json['DateAdded'];
    userAlias = json['UserAlias'];
    userDisplayName = json['UserDisplayName'];
    userIconUrl = json['UserIconUrl'];
    userId = json['UserId'];
    userGuid = json['UserGuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Content'] = this.content;
    data['IsPrivate'] = this.isPrivate;
    data['IsLucky'] = this.isLucky;
    data['CommentCount'] = this.commentCount;
    data['DateAdded'] = this.dateAdded;
    data['UserAlias'] = this.userAlias;
    data['UserDisplayName'] = this.userDisplayName;
    data['UserIconUrl'] = this.userIconUrl;
    data['UserId'] = this.userId;
    data['UserGuid'] = this.userGuid;
    return data;
  }
}
