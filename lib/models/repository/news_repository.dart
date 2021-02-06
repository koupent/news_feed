//データ取得の役割を担うModel 「Repository」
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/db/dao.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/models/networking/api_service.dart';
import 'package:news_feed/util/extentions.dart';

class NewsRepository extends ChangeNotifier {
  final ApiService _apiService; //プライベート「＿」で宣言
  final NewsDao _dao; //プライベート「＿」で宣言

  NewsRepository({dao, apiService})
      : _apiService = apiService,
        _dao = dao;

  //ViewまたはModelに自動的に値を引き渡す
  List<Article> _articles = List(); //初期化
  List<Article> get articles => _articles; //カプセル化

  //LoadStatus
  LoadStatus _loadStatus = LoadStatus.DONE; //初期化
  LoadStatus get loadStatus => _loadStatus; //カプセル化

  //引数は、ViewModelで定義したものと同じ
  getNews({@required SearchType searchType, String keyword, Category category}) async {
    _loadStatus = LoadStatus.LOADING;
    notifyListeners();

    Response response;

    try {
      switch (searchType) {
        case SearchType.HEAD_LINE:
          response = await _apiService.getHeadLines();
          break;
        case SearchType.KEYWORD:
          response = await _apiService.getKeywordNews(keyword: keyword);
          break;
        case SearchType.CATEGORY:
          response = await _apiService.getCategoryNews(category: category.nameEn);
          break;
      }
      if (response.isSuccessful) {
        //レスポンスが成功の場合
        final responseBody = response.body; //「body」結果の中身
        await insertAndReadFromDB(responseBody);
      } else {
        final errorCode = response.statusCode;
        final error = response.error;
        _loadStatus = LoadStatus.RESPONSE_ERROR;
        print("response is not successful: $errorCode / $error");
      }
    } on Exception catch (error) {
      _loadStatus = LoadStatus.NETWORK_ERROR;
      print("error: $error");
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _apiService.dispose(); //ViewModelからメソッド実行
    super.dispose();
  }

  insertAndReadFromDB(responseBody) async {
    //json → モデルクラス
    final articlesFromNetwork = News.fromJson(responseBody).articles;

    //webから取得した記事リスト(Dartのモデルクラス：Article)をDBのテーブルクラス(Articles)に変換してDB登録
    final articleFromDB = await _dao.insertAndReadNewsFromDB(articlesFromNetwork.toArticleRecords(articlesFromNetwork));

    //DBから取得したデータをモデルクラスに再変換して返す
    _articles = articleFromDB.toArticles(articleFromDB);
    _loadStatus = LoadStatus.DONE;
  }
}
