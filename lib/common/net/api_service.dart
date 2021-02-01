import 'package:dio/dio.dart';
import 'package:mpsf_app/common/config/net_config.dart';

import 'entity/api_result_data.dart';
import 'http_manager.dart';
import 'nw_api.dart';

class ApiService {
  /// authorization_code授权
  static Future<ApiResultData> getAuthorizeToken(String code) async {
    Map<String, dynamic> queryParameters =
        NetConfig.getNativeLoginCommonParmers(code);

    ApiResultData respM = await httpManager.netFetch(
      NWApi.getAuthorizeToken,
      data: queryParameters,
      options: Options(
        method: "POST",
        contentType: "application/x-www-form-urlencoded",
      ),
    );
    return respM;
  }

  /// 获取登陆用户信息
  static Future<ApiResultData> fetchUserInfo() async {
    String url = "users";
    ApiResultData respM = await httpManager.netFetch(
      url,
      options: Options(
        method: "get",
        contentType: "application/json; charset=utf-8",
        extra: {
          "Vary": "Accept-Encoding",
          "Connection": "keep-alive",
          "Transfer-Encoding": "chunked",
        },
      ),
    );
    return respM;
  }

  /// 获取个人博客信息
  static Future<ApiResultData> fetchBlogAppInfos({String blogApp}) async {
    String url = "blogs/$blogApp";
    ApiResultData respM =
        await httpManager.netFetch(url, options: Options(method: "get"));
    return respM;
  }

  /// 获取个人博客随笔列表
  static Future<ApiResultData> fetchBlogApp({String blogApp, int page}) async {
    String url = "blogs/$blogApp/posts?" + "pageIndex=$page";
    ApiResultData respM =
        await httpManager.netFetch(url, options: Options(method: "get"));
    return respM;
  }

  /// 分页获取收藏列表
  static Future<ApiResultData> fetchBookmarks({int page, int pageSize}) async {
    String url = "Bookmarks?" + "pageIndex=$page&pageSize=$pageSize";
    ApiResultData respM =
        await httpManager.netFetch(url, options: Options(method: "get"));
    return respM;
  }

  /// 获取最新一条闪存内容
  static Future<ApiResultData> fetchStatusesRecent() async {
    String url = "statuses/recent";
    ApiResultData respM =
        await httpManager.netFetch(url, options: Options(method: "get"));
    return respM;
  }

  /// 发布闪存
  static Future<ApiResultData> publistStatuses(
    String content, {
    bool isPrivate: false,
  }) async {
    String url = "statuses";
    dynamic data = {
      "Content": content,
      "IsPrivate": isPrivate,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "post"));
    return respM;
  }

  /// 发布闪存评论
  static Future<ApiResultData> publistStatusesComments(
    String statusId, {
    String replyTo,
    String parentCommentId,
    String content,
  }) async {
    String url = "statuses/$statusId/comments";
    dynamic data = {
      "statusId": statusId,
      "ReplyTo": replyTo,
      "ParentCommentId": parentCommentId,
      "Content": content,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "get"));
    return respM;
  }

  /// 删除闪存
  static Future<ApiResultData> deleteStatuses(String statusId) async {
    String url = "statuses/$statusId";
    dynamic data = {
      "statusId": statusId,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "delete"));
    return respM;
  }

  /// 删除闪存评论
  static Future<ApiResultData> deleteStatusesComments(
      String statusId, String id) async {
    String url = "statuses/$statusId/comments/$id";
    dynamic data = {
      "statusId": statusId,
      "id": id,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "delete"));
    return respM;
  }

  /// 根据Id获取闪存
  static Future<ApiResultData> fetchStatuses(String id) async {
    String url = "statuses/$id";
    dynamic data = {
      "id": id,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "get"));
    return respM;
  }

  /// 获取闪存评论
  static Future<ApiResultData> fetchStatusesComments(String statusId) async {
    String url = "statuses/$statusId/comments";
    dynamic data = {
      "statusId": statusId,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "get"));
    return respM;
  }

  /// 根据类型获取闪存列表
  static Future<ApiResultData> fetchStatusesList(
    String type, {
    int pageIndex,
    int pageSize,
    String tag,
  }) async {
    String url = "statuses/@$type?";
    dynamic data = {
      "pageIndex": "$pageIndex",
      "pageSize": "$pageSize",
      "tag": tag,
    };
    ApiResultData respM = await httpManager.netFetch(url,
        data: data, options: Options(method: "get"));
    return respM;
  }

  /// 获取我的博客列表
  static Future<ApiResultData> fetchApi(ApiType api,
      {String blogApp, int page, int pageSize}) async {
    ApiResultData respM;
    switch (api) {
      case ApiType.Statuses_all: //闪存-最新
        String url = "statuses/@all?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Statuses_following: //闪存-关注
        String url =
            "statuses/@following?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Statuses_my: //闪存-我的
        String url = "statuses/@my?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Home_blogs: //首页-博客
        String url =
            "blogposts/@sitehome?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Home_news: //首页-新闻
        String url = "NewsItems?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Home_articles: //首页-文库
        String url = "KbArticles?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Home_blogposts: //首页-精华
        String url =
            "blogposts/@picked?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Home_newsitems_hotweek: //本周内热门新闻
        String url =
            "newsitems/@hot-week?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Home_newsitems_recommended: //推荐新闻
        String url =
            "newsitems/@recommended?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Questions_all: //最新
        String url = "questions/@all?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Questions_highscore: //高分
        String url =
            "questions/@highscore?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      case ApiType.Questions_solved: //已解决
        String url =
            "questions/@solved?" + "pageIndex=$page&pageSize=$pageSize";
        respM =
            await httpManager.netFetch(url, options: Options(method: "get"));
        break;
      default:
    }
    return respM;
  }
}
