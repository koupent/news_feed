import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

//抽象クラス(メソッドの定義だけをしているクラスのこと)
@ChopperApi()
abstract class ApiService extends ChopperService {
  static const BASE_URL = "http://newsapi.org/v2"; //注意！末尾の「/」は不要
  static const API_KEY = "825c4e894e924d2188a3c5a5af8cc314";

  //データサーバーに対し、GETまたはPOST要求を出すメソッド
  static ApiService create() {
    final client = ChopperClient(
      baseUrl: BASE_URL,
      services: [_$ApiService()],
      converter: JsonConverter(), //リクエストを[json」に変換して、データサーバーに問い合わせする
    );
    return _$ApiService(client);
  }

  @Get(path: "/top-headlines")
  Future<Response> getHeadLines(
      {@Query("country") String country = "jp",
      @Query("pageSize") int pageSize = 10,
      @Query("apiKey") String apiKey = ApiService.API_KEY});

  @Get(path: "/top-headlines")
  Future<Response> getKeywordNews(
      {@Query("country") String country = "jp",
      @Query("pageSize") int pageSize = 30,
      @Query("q") String keyword,
      @Query("apiKey") String apiKey = ApiService.API_KEY});

  @Get(path: "/top-headlines")
  Future<Response> getCategoryNews(
      {@Query("country") String country = "jp",
      @Query("pageSize") int pageSize = 30,
      @Query("category") String category,
      @Query("apiKey") String apiKey = ApiService.API_KEY});
}
