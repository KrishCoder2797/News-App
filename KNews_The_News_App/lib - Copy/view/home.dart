import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pnews/controller/session_login.dart';
import 'package:pnews/model/drawer_search_category_button.dart';
import 'package:pnews/view/database_connection.dart';
import 'package:pnews/view/news_card.dart';
import 'package:pnews/view/simpener.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/news_service.dart';
import '../model/news_list.dart';
import '../model/newsinfo_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'aboutus.dart';
import 'login_page.dart';

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
  bool _isAbouUsPressed = false;

  List<Map> drawerCategaoryButtonInfo =
      CategoryButtonInfo.drawerCategaoryButtonInfo;

  List lastSerch = [
    'india',
    'cricket',
    'ipl',
    'election',
    'weather',
    'bollywood',
    'trending',
    'election',
  ];

  late BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    NewsList.futureArticles = NewsService().searchNews("wold");
    _initGoogleMobileAds();
  }

  void _initGoogleMobileAds() {
    MobileAds.instance.initialize().then((InitializationStatus status) {
      loadAd();
    });
  }

  void loadAd() async {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3485483358656293/3597449053',
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _isAdLoaded = true;
        });
      }, onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
      }),
      request: const AdRequest(),
    )..load();
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
    _bannerAd!.dispose();
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
                            (index == 0) ? mysearchBar() : const SizedBox(),
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
                              mysearchBar(),
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
                              mysearchBar(),
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
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final article = snapshot.data![index];
                        try {
                          article.urlToImage!;
                        } catch (e) {
                          article.urlToImage =
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png";
                        }
                        try {
                          article.description!;
                        } catch (e) {
                          article.description = "No description avaleable";
                        }

                        return Column(
                          children: [
                            (index == 0) ? mysearchBar() : const SizedBox(),
                            (article.title != "[Removed]")
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
                      height: _bannerAd!.size.height.toDouble() + 2,
                      child: AdWidget(ad: _bannerAd!),
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
                // GestureDetector(
                //   onTap: () {
                //     onDrawerButtonPressed(
                //       selectedDrawerButtonIndex: 0,
                //       searchkeyword: 'World',
                //     );
                //   },
                //   child: getDrawerButtons(
                //     icon: Icons.home,
                //     label: "Home",
                //     buttonIndex: 0,
                //   ),
                // ),
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
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                  onTap: () {
                    _shareApp(context);
                    setState(() {});
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
                  height: 7,
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    setState(() {
                      _isAbouUsPressed = true;
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    setState(() {
                      _isAbouUsPressed = false;
                    });
                  },
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AboutUs();
                    }));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isAbouUsPressed
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
                          Icons.group,
                          color: Color.fromARGB(255, 31, 175, 253),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          "About us",
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
                GestureDetector(
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isAbouUsPressed
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
                          Icons.logout,
                          color: Color.fromARGB(255, 31, 175, 253),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          "Logout",
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
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(bottom: 50, right: 100, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _launchApp(
                              url:
                                  "https://www.instagram.com/_prasadpatil.?igsh=MTV5ZXF1bnVsdjlkZA==");
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 86, 78, 58),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(60),
                            ),
                            child: Image.asset("assets/images/insta_logo.jpg"),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchApp(
                              url:
                                  "https://www.youtube.com/channel/UCQRjYSyYW-8Pl9P1zX9RSRw");
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 189, 7, 7),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60)),
                              child: Image.asset("assets/images/yt_logo.png")),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchApp(
                              url:
                                  "https://www.linkedin.com/in/prasad-zadokar?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app");
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 7, 85, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60)),
                              child: Image.asset(
                                  "assets/images/linkdin_logo.png")),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final Uri whatsappUri = Uri(
                            scheme: 'https',
                            host: 'wa.me',
                            path: '/+918956652382',
                          );
                          _launchApp(url: whatsappUri.toString());
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(60)),
                            child:
                                Image.asset("assets/images/whatapp_logo.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget mysearchBar() {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.76,
              // height: MediaQuery.of(context).size.height * 0.06,
              height: 48,
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
                      color: Color.fromARGB(255, 224, 224, 224),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 101, 100, 100),
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
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
                searchNews();
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.18,
                height: 46,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const Text("last search's: "),
            /* FutureBuilder(
                future: querys,
                builder: (context, snapshort) {
                  log(querys);
                  return*/
            SizedBox(
              //margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 40,
              width: MediaQuery.of(context).size.width - 5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lastSerch.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      log("ppp");
                      searchController.text = lastSerch[index];
                      NewsList.futureArticles =
                          NewsService().searchNews(lastSerch[index]);
                      setState(() {});
                    },
                    child: LastSearchCard(
                      searchKeyword: lastSerch[index],
                    ),
                  );
                },
              ),
            )
            // }),
          ],
        )
      ],
    );
  }

  var querys;
  Future<dynamic>? isUserLoggedIn() async {
    querys = await UserInfo.getObject().getUserSearchHistory();
    print(querys);
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
      //height: ,
      //width: 186,
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
        'https://www.instagram.com/_prasadpatil.?igsh=MTV5ZXF1bnVsdjlkZA==';

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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void onDrawerButtonPressed({
    required int selectedDrawerButtonIndex,
    required String searchkeyword,
  }) {
    Navigator.of(context).pop();
    this.selectedDrawerButtonIndex = selectedDrawerButtonIndex;
    if (selectedDrawerButtonIndex == 0) {
      NewsList.futureArticles = NewsService().searchNews("world");
      searchController.text = "";
      appbarName = "News Updates";
    } else {
      searchController.text = searchkeyword;
      appbarName = searchkeyword;
    }
    searchNews();
    setState(() {});
  }

  void _logout() async {
    await SessionLogin().logout();
    //UserInfo.getObject().removeCurrentUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        //transitionDuration: const Duration(milliseconds: 150),
        builder: (context) {
          return const Login();
        },
      ),
    );
  }

  void _shareApp(BuildContext context) {
    const String text =
        "Link for the app Comming soon, stil for apk massage on 8956652382 or \n insta:  https://www.instagram.com/_prasadpatil.?igsh=MTV5ZXF1bnVsdjlkZA== ";
    Share.share(text);
  }
}

class LastSearchCard extends StatefulWidget {
  final String searchKeyword;
  const LastSearchCard({super.key, required this.searchKeyword});

  @override
  State createState() => _LastSearchState();
}

class _LastSearchState extends State<LastSearchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Text(widget.searchKeyword),
    );
  }
}
