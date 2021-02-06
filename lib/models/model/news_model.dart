import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

//htmlの記述構成に従い、2つのクラスを作成する
@JsonSerializable()
class News {
  final List<Article> articles;

  News({this.articles});

  //jsonからモデルクラスに変換するメソッド
  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  //モデルクラスからjsonに変換するメソッド
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable()
class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  //json側の「publishedAt」は、モデルクラスでは「publishDate」で扱われる
  @JsonKey(name: "publishedAt")
  final String publishDate;
  final String content;

  Article(
      {this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishDate,
      this.content});

  //jsonからモデルクラスに変換するメソッド
  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  //モデルクラスからjsonに変換するメソッド
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
