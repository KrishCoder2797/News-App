import 'package:flutter/material.dart';
import 'package:pnews/model/drawer_search_category_button.dart';
import 'package:pnews/model/images.dart';
import 'package:pnews/model/mydata.dart';
import 'package:pnews/view/news_card.dart';
import 'package:pnews/view/simpener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/news_service.dart';
import '../model/news_list.dart';
import '../model/newsinfo_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => HomeState();
}

class HomeState extends State {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String appbarName = "News Updates";
  int selectedDrawerButtonIndex = 0;
  bool _isShearPressed = false;

  late ScrollController _scrollController;
  int _preloadThreshold = 5;
  List<Article> _preloadedArticles = [];

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  List<Map> drawerCategaoryButtonInfo =
      CategoryButtonInfo.drawerCategaoryButtonInfo;

  @override
  void initState() {
    super.initState();
    NewsList.futureArticles = NewsService().searchNews("world");
    _scrollController = ScrollController()..addListener(_scrollListener);

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: MyData.banneraddHomePage,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _isAdLoaded = true;
        });
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      }),
      request: const AdRequest(),
    )..load();
    _preloadArticles();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _preloadArticles();
    }
  }

  void _preloadArticles() async {
    List<Article> articles = await NewsService().searchNews("India");
    setState(() {
      _preloadedArticles = articles;
    });
    _cacheImages(articles);
  }

  void _cacheImages(List<Article> articles) {
    for (var article in articles) {
      if (article.urlToImage != null) {
        precacheImage(NetworkImage(article.urlToImage!), context);
      }
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));

    String searchKeyword = searchController.text.trim();
    if (searchKeyword == "") {
      searchKeyword = "wold";
    }
    NewsList.futureArticles = NewsService().searchNews(searchKeyword);
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            appbarName,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Stack(
            children: [
              FutureBuilder<List<Article>>(
                future: NewsList.futureArticles,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            (index == 0) ? mySerchbar() : const SizedBox(),
                            const ShimmerNewsCard(),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              mySerchbar(),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                    ),
                                    const Text(
                                      "Oops !",
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      " Slow or No internet connection",
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    ),
                                    Image.asset(
                                      "assets/images/nointernet.jpg",
                                      height: 75,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              mySerchbar(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.26,
                                  ),
                                  const Text(
                                    'No articles found,\n Please enter proper keyword',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    "assets/images/noarticalfound.png",
                                    height: 75,
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final article = snapshot.data![index];

                      
                        // try {
                        //   article.description!;
                        // } catch (e) {
                        //   article.description = "No description avaleable";
                        // }
                        article.description ??= "No description avaleable ";
                        for (int i = 1; i <= 5; i++) {
                          if (index + i < snapshot.data!.length) {
                            snapshot.data![index + i].urlToImage ??=
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png";
                            precacheImage(
                                NetworkImage(
                                    snapshot.data![index + i].urlToImage!),
                                context);
                          }
                        }

                        return Column(
                          children: [
                            (index == 0) ? mySerchbar() : const SizedBox(),
                            (article.title != "[Removed]" && article.urlToImage != null)
                                ? NewsCard(article: article)
                                : const SizedBox(),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isAdLoaded)
                    Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: _bannerAd.size.height.toDouble() + 2,
                      child: AdWidget(ad: _bannerAd),
                    ),
                ],
              )
            ],
          ),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      const Text(
                        "PNews",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        "See all news update here",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                for (int i = 0; i < drawerCategaoryButtonInfo.length; i++)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          onDrawerButtonPressed(
                            selectedDrawerButtonIndex: i,
                            searchkeyword: drawerCategaoryButtonInfo[i]
                                ["searchKeyword"],
                          );
                        },
                        child: getDrawerButtons(
                          icon: drawerCategaoryButtonInfo[i]["icon"],
                          label: drawerCategaoryButtonInfo[i]["buttonName"],
                          buttonIndex: i,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      )
                    ],
                  ),
                Container(
                  height: 1.5,
                  width: 270,
                  color: Colors.black12,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                ),
                const SizedBox(
                  height: 7,
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    setState(() {
                      _isShearPressed = true;
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    setState(() {
                      _isShearPressed = false;
                    });
                  },
                  onTap: () async {
                    _shareApp(context);
                    setState(() {});
                  },
                  onTapCancel: () {
                    setState(() {
                      _isShearPressed = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isShearPressed
                          ? const Color.fromARGB(39, 24, 170, 248)
                          : null,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    //height: ,
                    //width: 186,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.share,
                          color: Color.fromARGB(255, 31, 175, 253),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: (8 == selectedDrawerButtonIndex)
                                ? const Color.fromARGB(255, 42, 134, 221)
                                : null,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(bottom: 50, right: 100, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      socialMediaButton(
                        logoUri: AppImages.instaLogo,
                        launchUrl: MyData.instaUrl,
                      ),
                      socialMediaButton(
                        logoUri: AppImages.ytLogo,
                        launchUrl: MyData.yturl,
                      ),
                      socialMediaButton(
                        logoUri: AppImages.linkdinLogo,
                        launchUrl: MyData.linkdinUrl,
                      ),
                      socialMediaButton(
                        logoUri: AppImages.twitterLogo,
                        launchUrl: MyData.twitterUrl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget socialMediaButton(
      {required String logoUri, required String launchUrl}) {
    return GestureDetector(
      onTap: () {
        _launchApp(url: launchUrl);
      },
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 59, 161, 224),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          child: Image.asset(logoUri),
        ),
      ),
    );
  }

  Widget mySerchbar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5),
              width: MediaQuery.of(context).size.width * 0.76,
              height: MediaQuery.of(context).size.height * 0.06,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 236, 236, 236),
                  hintText: 'eg. science',
                  hintStyle: const TextStyle(fontSize: 16),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(25, 0, 0, 0),
                      width: 1.3,
                    ),
                  ),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
                searchNews();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.height * 0.055,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 77, 175, 255),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 1,
        ),
      ],
    );
  }

  void searchNews() {
    String searchKeyword = searchController.text.trim();
    if (searchKeyword.isNotEmpty) {
      NewsList.futureArticles = NewsService().searchNews(searchKeyword);
    } else {
      NewsList.futureArticles = NewsService().searchNews("science");
      searchController.text = "science";
    }
    setState(() {});
  }

  Widget getDrawerButtons({
    required IconData icon,
    required String label,
    required int buttonIndex,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
      decoration: BoxDecoration(
        color: (buttonIndex == selectedDrawerButtonIndex)
            ? const Color.fromARGB(39, 24, 170, 248)
            : null,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 31, 175, 253),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: (buttonIndex == selectedDrawerButtonIndex)
                  ? const Color.fromARGB(255, 42, 134, 221)
                  : null,
            ),
          )
        ],
      ),
    );
  }

  void _launchApp({required String url}) async {
    const fallbackUrl =
        'https://www.instagram.com/sharefy.in?igsh=MWI2OHYzcng2Y2UweA==';

    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void onDrawerButtonPressed({
    required int selectedDrawerButtonIndex,
    required String searchkeyword,
  }) {
    Navigator.of(context).pop();
    this.selectedDrawerButtonIndex = selectedDrawerButtonIndex;
    if (selectedDrawerButtonIndex == 0) {
      NewsList.futureArticles = NewsService().searchNews("");
      searchController.text = "";
      appbarName = "News Updates";
    } else {
      searchController.text = searchkeyword;
      appbarName = searchkeyword;
    }
    searchNews();
    setState(() {});
  }

  void _shareApp(BuildContext context) {
    Share.share(MyData.appShareLink);
  }
}
