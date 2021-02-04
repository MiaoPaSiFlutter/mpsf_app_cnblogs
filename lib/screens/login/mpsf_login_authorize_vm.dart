import 'package:mpsf_app/common/config/net_config.dart';

class MpsfLoginAuthorizeVM {
  // ignore: non_constant_identifier_names
  static const String client_id = NetConfig.CLIENT_ID;
  // ignore: non_constant_identifier_names
  static const String redirect_uri = NetConfig.REDIRECT_URI;
  // ignore: non_constant_identifier_names
  String authorize_url = 
      "https://oauth.cnblogs.com/connect/authorize?client_id=$client_id&scope=openid profile CnBlogsApi  offline_access&response_type=code id_token&redirect_uri=$redirect_uri&state=cnblogs.com&nonce=cnblogs.com";

  


}
