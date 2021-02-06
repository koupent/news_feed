import 'package:news_feed/models/db/database.dart';
import 'package:news_feed/models/model/news_model.dart';

//Dartのモデルクラス　→　DBのテーブルクラス
extension ConvertToArticleRecord on List<Article> {
  List<ArticleRecord> toArticleRecords(List<Article> articles) {
    var articleRecords = List<ArticleRecord>();
    articles.forEach((article) {
      articleRecords.add(ArticleRecord(
        title: article.title ?? "",
        description: article.description ?? "",
        url: article.url,
        urlToImage: article.urlToImage ?? "",
        publishDate: article.publishDate ?? "",
        content: article.content ?? "",
      ));
    });
    return articleRecords;
  }
}

//DBのテーブルクラス → Dartのモデルクラス
extension ConvertToArticle on List<ArticleRecord> {
  List<Article> toArticles(List<ArticleRecord> articleRecords) {
    var articles = List<Article>();
    articleRecords.forEach((articleRecord) {
      articles.add(Article(
        title: articleRecord.title ?? "",
        description: articleRecord.description ?? "",
        url: articleRecord.url,
        urlToImage: articleRecord.urlToImage ?? "",
        publishDate: articleRecord.publishDate ?? "",
        content: articleRecord.content ?? "",
      ));
    });
    return articles;
  }
}
