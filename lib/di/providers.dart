import 'package:news_feed/models/db/dao.dart';
import 'package:news_feed/models/db/database.dart';
import 'package:news_feed/models/networking/api_service.dart';
import 'package:news_feed/models/repository/news_repository.dart';
import 'package:news_feed/viewmodels/head_line_veiwmodel.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  //API
  Provider<ApiService>(
    create: (_) => ApiService.create(),
    dispose: (_, apiService) => apiService.dispose(),
  ),

  //DB
  Provider<MyDatabase>(
    create: (_) => MyDatabase(),
    dispose: (_, db) => db.close(),
  ),
];

List<SingleChildWidget> dependentModels = [
  //DAO (依存先は、DB)
  ProxyProvider<MyDatabase, NewsDao>(
    update: (_, db, dao) => NewsDao(db),
  ),

  //Repository　(依存先は、DB(DAO)とAPI) ※DIで書き直し
  ChangeNotifierProvider<NewsRepository>(
    create: (context) => NewsRepository(
      dao: Provider.of<NewsDao>(context, listen: false),
      apiService: Provider.of<ApiService>(context, listen: false),
    ),
  ),

//  //Repository　(依存先は、DB(DAO)とAPI)　※DI非対応
//  ProxyProvider2<NewsDao, ApiService, NewsRepository>(
//    update: (_, dao, apiService, repository) => NewsRepository(dao: dao, apiService: apiService),
//  ),
];

List<SingleChildWidget> viewModels = [
  //Model層の変更をViewModelに渡す(Repository → HeadLineViewModel)　※DI対応
  ChangeNotifierProxyProvider<NewsRepository, HeadLineViewModel>(
    create: (context) => HeadLineViewModel(
      repository: Provider.of<NewsRepository>(context, listen: false),
    ),
    update: (context, repository, viewModel) =>
        viewModel..onRepositoryUpdate(repository), //「onRepositoryUpdate()」メソッドでモデル層で変更された場合にやることを記述
  ),

  //Model層の変更をViewModelに渡す(Repository → HeadLineViewModel)　※DI非対応
//  ChangeNotifierProvider<HeadLineViewModel>(
//    //context省略禁止
//    create: (context) =>
//        HeadLineViewModel(
//          repository: Provider.of<NewsRepository>(context, listen: false),
//        ),
//  ),

  //Model層の変更をViewModelに渡す(Repository → NewsListViewModel) ※DI非対応
  ChangeNotifierProxyProvider<NewsRepository, NewsListViewModel>(
    create: (context) => NewsListViewModel(
      repository: Provider.of<NewsRepository>(context, listen: false),
    ),
    update: (context, repository, viewModel) =>
        viewModel..onRepositoryUpdate(repository), //「onRepositoryUpdate()」メソッドでモデル層で変更された場合にやることを記述
  ),

  //Model層の変更をViewModelに渡す(Repository → NewsListViewModel) ※DI非対応
//  ChangeNotifierProvider<NewsListViewModel>(
//    //context省略禁止
//    create: (context) => NewsListViewModel(
//      repository: Provider.of<NewsRepository>(context, listen: false),
//    ),
//  )
];
