import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article_model.dart';

class NewsService{

  List<ArticleModel>  news = [];

  Future <void> getNews() async {
    String url = "https://newsapi.org/v2/everything?q=tesla&from=2024-11-07&sortBy=publishedAt&apiKey=5de8500153074db29d726bdcc6f95cad";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData['articles'].forEach((element){
        if(element["urlToImage"]!= null && element["description"]!=null){
          ArticleModel articleModel = ArticleModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"],
              author: element["author"]
          );
          news.add(articleModel);
        }
      });
    }
  }
}