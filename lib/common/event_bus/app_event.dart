class AppEvent {
  AppEventType eventType;
  AppEvent(this.eventType);
}

enum AppEventType {
  Unauthorized,//未授权：登录失败
}
