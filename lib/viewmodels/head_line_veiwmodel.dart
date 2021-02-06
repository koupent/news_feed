import 'package:flutter/material.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/models/repository/news_repository.dart';

class HeadLineViewModel extends ChangeNotifier {
  //データ取得を担うモデルのコンストラクタ(View → ViewModel)
  final NewsRepository _repository;

  //DI
  HeadLineViewModel({repository}) : _repository = repository;

  //クラスのカプセル化(_searchTypeを外部からむやみに変更されないようにする)
  SearchType _searchType = SearchType.CATEGORY; //初期値
  SearchType get searchType => _searchType;

  LoadStatus _loadStatus = LoadStatus.DONE; //初期値
  LoadStatus get loadStatus => _loadStatus;

  //ViewまたはModelに自動的に値を引き渡す
  List<Article> _articles = List(); //初期化
  List<Article> get articles => _articles; //カプセル化

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  Future<void> getHeadLines({@required SearchType searchType}) async {
    _searchType = searchType;

    _articles = await _repository.getNews(searchType: SearchType.HEAD_LINE);
  }

  //Model層 → ViewModel層 自動通知処理
  onRepositoryUpdate(NewsRepository repository) {
    _articles = repository.articles;
    _loadStatus = repository.loadStatus;
    notifyListeners();
  }
}
