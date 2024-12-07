import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app_world/models/show_category.dart';



class ShowCategoryNews{

  List<ShowCategoryModel>  showCategories = [];

  Future <void> getShowCategoryNews(String category) async {
    String url = "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=5de8500153074db29d726bdcc6f95cad";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData['articles'].forEach((element){
        if(element["urlToImage"]!= null && element["description"]!=null){
          ShowCategoryModel categoryModel = ShowCategoryModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"],
              author: element["author"]
          );
          showCategories.add(categoryModel);
        }
      });
    }
  }
}