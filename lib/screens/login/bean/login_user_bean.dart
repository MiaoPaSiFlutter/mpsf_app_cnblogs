class LoginUserBean {
  String userId;
  int spaceUserId;
  int blogId;
  String displayName;
  String face;
  String avatar;
  String seniority;
  String blogApp;

  LoginUserBean(
      {this.userId,
      this.spaceUserId,
      this.blogId,
      this.displayName,
      this.face,
      this.avatar,
      this.seniority,
      this.blogApp});

  LoginUserBean.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    spaceUserId = json['SpaceUserId'];
    blogId = json['BlogId'];
    displayName = json['DisplayName'];
    face = json['Face'];
    avatar = json['Avatar'];
    seniority = json['Seniority'];
    blogApp = json['BlogApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['SpaceUserId'] = this.spaceUserId;
    data['BlogId'] = this.blogId;
    data['DisplayName'] = this.displayName;
    data['Face'] = this.face;
    data['Avatar'] = this.avatar;
    data['Seniority'] = this.seniority;
    data['BlogApp'] = this.blogApp;
    return data;
  }
}
