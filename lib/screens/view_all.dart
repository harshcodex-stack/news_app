import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_world/models/slider_model.dart';
import 'package:news_app_world/screens/article_screen.dart';

import '../models/article_model.dart';
import '../services/news_service.dart';
import '../services/slider_service.dart';

class ViewAllNews extends StatefulWidget {
  String news;
  ViewAllNews({required this.news});

  @override
  State<ViewAllNews> createState() => _ViewAllNewsState();
}

class _ViewAllNewsState extends State<ViewAllNews> {

  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  List<SliderModel> filteredSliders = [];
  List<ArticleModel> filteredArticles = [];
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'All';
  String selectedSort = 'Title';

  void initState() {
    getSliders();
    getNews();
    super.initState();
  }

  getNews() async {
    NewsService newsClass = NewsService();
    await newsClass.getNews();
    articles = newsClass.news;
    filteredArticles = articles;
    setState(() {});
  }

  getSliders() async {
    SliderService slider = SliderService();
    await slider.getSliders();
    sliders = slider.sliders;
    filteredSliders = sliders;
    setState(() {});
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredArticles = articles;
        filteredSliders = sliders;
      });
    } else {
      setState(() {
        filteredArticles = articles.where((article) {
          return article.title!.toLowerCase().contains(query.toLowerCase()) ||
              article.description!.toLowerCase().contains(query.toLowerCase());
        }).toList();

        filteredSliders = sliders.where((slider) {
          return slider.title!.toLowerCase().contains(query.toLowerCase()) ||
              slider.description!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void filterByCategory(String category) {
    setState(() {
      selectedFilter = category;
    });

    if (category == 'All') {
      setState(() {
        filteredArticles = articles;
      });
    } else if (category == 'Headlines') {
      setState(() {
        filteredArticles = [];
      });
    } else {
      setState(() {
        filteredArticles = articles.where((article) {
          return article.title!.toLowerCase().contains(category.toLowerCase()) ||
              article.description!.toLowerCase().contains(category.toLowerCase());
        }).toList();

        filteredSliders = sliders.where((slider) {
          return slider.title!.toLowerCase().contains(category.toLowerCase()) ||
              slider.description!.toLowerCase().contains(category.toLowerCase());
        }).toList();
      });
    }
  }

  void sortArticles(String option) {
    if (option == 'Title') {
      setState(() {
        filteredArticles.sort((a, b) => a.title!.compareTo(b.title!));
      });
    } else if (option == 'Date') {
      setState(() {
        filteredArticles.sort((a, b) => a.publishedAt!.compareTo(b.publishedAt!));
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.news} News",
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (['All', 'Headlines', 'Sports', 'Technology'].contains(value)) {
                filterByCategory(value);
              } else {
                // Sorting
                setState(() {
                  selectedSort = value;
                });

              }
            },
            itemBuilder: (BuildContext context) {
              return [
                'All', 'Headlines', 'Sports', 'Technology',
                'Title', 'Date'
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  filterSearchResults(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search News',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Filter: $selectedFilter | Sort by: $selectedSort',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.news == "Headlines" ? filteredSliders.length : filteredArticles.length,
                itemBuilder: (context, index) {
                  return AllNewsScreen(
                    Image: widget.news == "Headlines"
                        ? filteredSliders[index].urlToImage!
                        : filteredArticles[index].urlToImage!,
                    desc: widget.news == "Headlines"
                        ? filteredSliders[index].description!
                        : filteredArticles[index].description!,
                    title: widget.news == "Headlines"
                        ? filteredSliders[index].title!
                        : filteredArticles[index].title!,
                    url: widget.news == "Headlines"
                        ? filteredSliders[index].url!
                        : filteredArticles[index].url!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllNewsScreen extends StatelessWidget {
  String Image, desc, title, url;
  AllNewsScreen({
    required this.Image,
    required this.desc,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleScreen(blogUrl: url)));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: Image,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
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
      ),
    );
  }
}
