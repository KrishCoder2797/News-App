import 'package:flutter/material.dart';
import 'package:pnews/view/news_webview.dart';

import '../model/newsinfo_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsCard extends StatefulWidget {
  final Article article;
  const NewsCard({super.key, required this.article});

  @override
  State createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NewWedview(
                article: widget.article,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(86, 141, 141, 141),
                  blurRadius: 3,
                  spreadRadius: 1.1,
                ),
              ],
            ),
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                      child: CachedNetworkImage(
                        height: 210,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.article.urlToImage!,
                        placeholder: (context, url) => Center(
                          child: Image.asset(
                            "assets/images/image_placeholder.png",
                            width: double.infinity,
                            height: 210,
                            fit: BoxFit.cover,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 500),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          widget.article.title,
                          style: const TextStyle(
                              fontSize: 19.3, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Text(
                          "Published On: ${widget.article.publishedAt.substring(0, 10)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: Text(
                          widget.article.description!,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 77, 77, 77)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
