import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_world/models/show_category.dart';
import 'package:news_app_world/screens/article_screen.dart';
import 'package:news_app_world/services/show_category.dart';


class CategoryNews extends StatefulWidget {
  String name;
  CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ShowCategoryModel> showCategories = [];
  bool  _loading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  getNews() async{
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getShowCategoryNews(widget.name.toLowerCase());
    showCategories =showCategoryNews.showCategories;
    setState(() {
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(
              widget.name,
              style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold
              ),
            ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: showCategories.length,
            itemBuilder: (context, index){
              return ShowCategory(
                Image: showCategories[index].urlToImage!,
                desc: showCategories[index].description!,
                title: showCategories[index].title!,
                url: showCategories[index].url!,
              );
            }),
      )
        );

  }
}

class ShowCategory extends StatelessWidget {
  String Image, desc, title, url;
  ShowCategory({required this.Image,
    required this.desc, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> ArticleScreen(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
              imageUrl: Image,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
                desc,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),

          ],

        )
      ),
    );
  }
}

