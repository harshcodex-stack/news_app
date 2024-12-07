import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {

  String blogUrl;
  ArticleScreen({super.key, required this.blogUrl});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("World"),
              Text("Today",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
      body: WebView(
        initialUrl: widget.blogUrl,
        javascriptMode: JavascriptMode.disabled,
      ));
  }
}
