class Config {
  static const PAGE_SIZE = 20;
  static const DEBUG = true;

  /// //////////////////////////////////////常量////////////////////////////////////// ///
  /*
  博客园Authorization_Code授权返回数据
  {
    "access_token": "this is token string",
    "expires_in": 586400,
    "token_type": "Bearer",
    "refresh_token": "this is refresh token string"
  }

  */
  static const Authorization_Code_Respone = "Authorization_Code_Respone";

  /*
  博客园Client_Credentials授权
  {
    "access_token": "this token string",
    "expires_in": 86400,
    "token_type": "Bearer"
  } 
  */
  static const Client_Credentials_Respone = "Client_Credentials_Respone";

  // static const USER_NAME_KEY = "user-name";
  // static const PW_KEY = "user-pw";
  // static const USER_BASIC_CODE = "user-basic-code";
  // static const USER_INFO = "user-info";
  // static const LANGUAGE_SELECT = "language-select";
  // static const LANGUAGE_SELECT_NAME = "language-select-name";
  // static const REFRESH_LANGUAGE = "refreshLanguageApp";
  // static const THEME_COLOR = "theme-color";
  // static const LOCALE = "locale";
}
