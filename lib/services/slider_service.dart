import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app_world/models/slider_model.dart';


class SliderService{

  List<SliderModel>  sliders = [];

  Future <void> getSliders() async {
    String url = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=5de8500153074db29d726bdcc6f95cad";

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData['articles'].forEach((element){
        if(element["urlToImage"]!= null && element["description"]!=null){
          SliderModel sliderModel = SliderModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"],
              author: element["author"]
          );
          sliders.add(sliderModel);
        }
      });
    }
  }
}