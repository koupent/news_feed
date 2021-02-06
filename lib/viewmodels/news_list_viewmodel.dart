import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/models/repository/news_repository.dart';

class NewsListViewModel extends ChangeNotifier {
  //データ取得を担うモデルのコンストラクタ(View → ViewModel)
  final NewsRepository _repository;

  //DI
  NewsListViewModel({repository}) : _repository = repository;

  //クラスのカプセル化(_searchTypeを外部からむやみに変更されないようにする)
  SearchType _searchType = SearchType.CATEGORY; //初期値
  SearchType get searchType => _searchType;

  Category _category = categories[0]; //初期値
  Category get category => _category;

  String _keyword = ""; //初期値
  String get keyword => _keyword;

  LoadStatus _loadStatus = LoadStatus.DONE; //初期値
  LoadStatus get loadStatus => _loadStatus;

  //ViewまたはModelに自動的に値を引き渡す
  List<Article> _articles = List(); //初期化
  List<Article> get articles => _articles; //カプセル化

  //ViewModel → Model → ViewModel
  Future<void> getNews({@required SearchType searchType, String keyword, Category category}) async {
    _searchType = searchType;
    _keyword = keyword;
    _category = category;

    //Repository → ViewModelからデータ取得
    //Viewに自動的に値を引き渡す
    _articles = await _repository.getNews(
      searchType: _searchType,
      keyword: _keyword,
      category: _category,
    );
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  //Model層 → ViewModel層 自動通知処理
  onRepositoryUpdate(NewsRepository repository) {
    _articles = repository.articles;
    _loadStatus = repository.loadStatus;
    notifyListeners();
  }
}
