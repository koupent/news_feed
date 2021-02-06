import 'package:moor/moor.dart';
import 'package:news_feed/models/db/database.dart';

part 'dao.g.dart';

@UseDao(tables: [ArticleRecords])
class NewsDao extends DatabaseAccessor<MyDatabase> with _$NewsDaoMixin {
  NewsDao(MyDatabase attachedDatabase) : super(attachedDatabase);

  //Delete
  Future clearDB() => delete(articleRecords).go();

  //Add
  Future insertDB(List<ArticleRecord> articles) async {
    await batch((batch) {
      batch.insertAll(articleRecords, articles);
    });
  }

  //Read
  Future<List<ArticleRecord>> get articlesFromDB => select(articleRecords).get();

  Future<List<ArticleRecord>> insertAndReadNewsFromDB(List<ArticleRecord> articles) => transaction(() async {
        await clearDB();
        await insertDB(articles);
        return await articlesFromDB;
      });
}
