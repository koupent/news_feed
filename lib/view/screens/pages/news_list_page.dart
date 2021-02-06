import 'package:flutter/material.dart';
import 'package:news_feed/data/category_info.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/view/components/article_tile.dart';
import 'package:news_feed/view/components/category_chips.dart';
import 'package:news_feed/view/components/search_bar.dart';
import 'package:news_feed/view/screens/news_web_page_screen.dart';
import 'package:news_feed/viewmodels/news_list_viewmodel.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false);

    if (viewModel.loadStatus != LoadStatus.LOADING && viewModel.articles.isEmpty) {
      // 非同期処理に逃げることで、StatelessWidget内でも
      Future(() => viewModel.getNews(searchType: SearchType.CATEGORY, category: categories[0]));
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          tooltip: "更新",
          onPressed: () => onRefresh(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // 検索バー
              SearchBar(
                onSearch: (keyword) => getKeywordNews(context, keyword),
              ),
              // カテゴリーチップス
              CategoryChips(
                onCategorySelected: (category) => getCategoryNews(context, category),
              ),
              // 記事表示
              Expanded(
                child: Consumer<NewsListViewModel>(
                  builder: (context, model, child) {
                    return model.loadStatus == LoadStatus.LOADING
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: model.articles.length,
                            itemBuilder: (context, int position) => ArticleTile(
                              article: model.articles[position],
                              onArticleClicked: (article) => _openArticleWebPage(article, context),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 記事更新処理
  Future<void> onRefresh(BuildContext context) async {
    print("NewsListPage.onRefresh");
    final viewModel = context.read<NewsListViewModel>();
    await viewModel.getNews(
      searchType: viewModel.searchType,
      keyword: viewModel.keyword,
      category: viewModel.category,
    );
  }

  Future<void> getKeywordNews(BuildContext context, keyword) async {
    print("NewsListPage.getKeywordNews");
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false); //Provider4.1.0以前の記述方法
//    final viewModel = context.read<NewsListViewModel>(); //Provider4.1.0以降の記述方法
    await viewModel.getNews(
      searchType: SearchType.KEYWORD,
      keyword: keyword,
      category: categories[0],
    );
  }

  Future<void> getCategoryNews(BuildContext context, category) async {
    print("NewsListPage.getCategoryNews / category: ${category.nameJp}");
    final viewModel = Provider.of<NewsListViewModel>(context, listen: false); //Provider4.1.0以前の記述方法
//    final viewModel = context.read<NewsListViewModel>(); //Provider4.1.0以降の記述方法
    await viewModel.getNews(
      searchType: SearchType.CATEGORY,
      category: category,
    );
  }

  //リンク先をWebページ画面に表示
  _openArticleWebPage(Article article, BuildContext context) {
    print("_openArticleWebPage: ${article.url}");
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsWebPageScreen(article: article)));
  }
}
