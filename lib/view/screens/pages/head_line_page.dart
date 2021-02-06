import 'package:flutter/material.dart';
import 'package:news_feed/data/load_status.dart';
import 'package:news_feed/data/search_type.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/view/components/head_line_item.dart';
import 'package:news_feed/view/components/page_transformer.dart';
import 'package:news_feed/viewmodels/head_line_veiwmodel.dart';
import 'package:provider/provider.dart';

import '../news_web_page_screen.dart';

class HeadLinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HeadLineViewModel>(context, listen: false);

    if (viewModel.loadStatus != LoadStatus.LOADING && viewModel.articles.isEmpty) {
      Future(() => viewModel.getHeadLines(searchType: SearchType.HEAD_LINE));
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () => onRefresh(context),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<HeadLineViewModel>(builder: (context, model, child) {
            if (model.loadStatus == LoadStatus.LOADING) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return PageTransformer(
                pageViewBuilder: (context, pageVisibilityResolver) {
                  return PageView.builder(
                    controller: PageController(
                      viewportFraction: 0.85,
                      initialPage: 0,
                    ),
                    itemCount: model.articles.length,
                    itemBuilder: (context, index) {
                      final article = model.articles[index];
                      final pageVisibility = pageVisibilityResolver.resolvePageVisibility(index);
                      final visibleFraction = pageVisibility.visibleFraction;
                      //ページ遷移時の透過アニメーション
                      return HeadLineItem(
                        article: model.articles[index],
                        pageVisibility: pageVisibility,
                        onArticleClicked: (article) => _onArticleWebPage(context, article),
                      );
                    },
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }

  // 更新処理
  Future<void> onRefresh(BuildContext context) async {
    print("HeadLinePage.onRefresh");
    final viewModel = Provider.of<HeadLineViewModel>(context, listen: false);
    await viewModel.getHeadLines(searchType: SearchType.HEAD_LINE);
  }

  //リンク先をWebページ画面に表示
  _onArticleWebPage(BuildContext context, Article article) {
    print("HeadLinePage._openArticleWebPage: ${article.url}");
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsWebPageScreen(article: article)));
  }
}
