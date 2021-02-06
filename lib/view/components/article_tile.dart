import 'package:flutter/material.dart';
import 'package:news_feed/models/model/news_model.dart';
import 'package:news_feed/view/components/article_tile_desc.dart';
import 'package:news_feed/view/components/image_from_url.dart';

class ArticleTile extends StatelessWidget {
  final Article article;

  final ValueChanged onArticleClicked;

  ArticleTile({this.article, this.onArticleClicked});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => onArticleClicked(article),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ImageFromUrl(
                    imageUrl: article.urlToImage,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ArticleTileDesc(
                  article: article,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
