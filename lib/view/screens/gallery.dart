import 'package:ainsighter/data/model/response/image_model.dart';
import 'package:ainsighter/localization/language_constrants.dart';
import 'package:ainsighter/provider/images_provider.dart';
import 'package:ainsighter/view/base/lazy_image.dart';
import 'package:ainsighter/view/result_square_screen_liked.dart';
import 'package:ainsighter/view/screens/result_square_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryScreen extends StatefulWidget {
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<ImageModel> _dataList = [];

  bool more = true;
  int page = 0;
  bool loadingMore = false;

  Future _showcaseFuture;
  Future _favouriteFuture;

  ScrollController _controller = ScrollController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _favouriteFuture = getFavs();
      });
    });

    Future.microtask(() async {
      final SharedPreferences prefs = await _prefs;

      setState(() {
        _showcaseFuture = getData(0);
        _showcaseFuture = getData(1);

        _favouriteFuture = getFavs();
      });
    });
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        setState(() {
          _showcaseFuture = getData(page);
        });
      }
    });
  }

  Future<List<ImageModel>> getData(int skip) async {
    if (more) {
      setState(() {
        loadingMore = true;
      });
      Provider.of<ImagesProvider>(context, listen: false)
          .getImageList(context, skip)
          .then((value) async {
        print(value);
        setState(() {
          _dataList.addAll(value);
          page++;
          if (value.length < 5) {
            more = false;
          }
          loadingMore = false;
        });
      });
    }
    return _dataList;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<List<dynamic>> getFavs() async {
    final SharedPreferences prefs = await _prefs;
    List list = prefs.getStringList('favList') ?? [];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff12151B),
      appBar: AppBar(
        backgroundColor: Color(0xff12151B),
        toolbarHeight: 80,
        elevation: 0,
        title: Text(getTranslated('gallery', context)),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [renderLeadingButton()],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Color(0xff1B2029)),
                borderRadius: BorderRadius.circular(
                  22.0,
                ),
              ),
              child: TabBar(
                onTap: (val) {},
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                isScrollable: true,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    gradient: LinearGradient(
                        colors: [Color(0xff898EF8), Color(0xff7269DB)])),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    text: getTranslated('recent', context),
                  ),
                  Tab(
                    text: getTranslated('liked', context),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FutureBuilder<List<ImageModel>>(
                      future: _showcaseFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ImageModel>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isNotEmpty)
                            return Column(
                              children: [
                                Expanded(
                                  child: StaggeredGridView.count(
                                    addRepaintBoundaries: false,
                                    controller: _controller,
                                    addAutomaticKeepAlives: false,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    crossAxisCount:
                                        2, // I only need two card horizontally
                                    padding: const EdgeInsets.all(2.0),
                                    children: snapshot.data.asMap().entries.map(
                                      (item) {
                                        return InkWell(
                                          child: LazyImage(
                                            url: item.value.url,
                                            noCache: true,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ResultSquareScreen(
                                                  imageUrl: item.value.url,
                                                  fromGallery: true,
                                                  galleryItems: snapshot.data,
                                                  initialGalleryIndex: item.key,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ).toList(),
                                    staggeredTiles: snapshot.data
                                        .map<StaggeredTile>(
                                            (_) => StaggeredTile.fit(1))
                                        .toList(),
                                    mainAxisSpacing: 3.0,
                                    crossAxisSpacing: 4.0, // add some space
                                  ),
                                ),
                                loadingMore
                                    ? CircularProgressIndicator()
                                    : SizedBox()
                              ],
                            );
                          else
                            return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Hata');
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  FutureBuilder<List<dynamic>>(
                      future: _favouriteFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.isNotEmpty)
                            return StaggeredGridView.count(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              crossAxisCount:
                                  2, // I only need two card horizontally
                              padding: const EdgeInsets.all(2.0),
                              children:
                                  snapshot.data.asMap().entries.map((item) {
                                return InkWell(
                                  child: LazyImage(
                                    url: item.value,
                                    noCache: true,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ResultSquareLikedScreen(
                                          imageUrl: item.value,
                                          fromGallery: true,
                                          galleryItems: snapshot.data,
                                          initialGalleryIndex: item.key,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),

                              staggeredTiles: snapshot.data
                                  .map<StaggeredTile>(
                                      (_) => StaggeredTile.fit(1))
                                  .toList(),
                              mainAxisSpacing: 3.0,
                              crossAxisSpacing: 4.0, // add some space
                            );
                          else
                            return Container();
                        } else if (snapshot.hasError) {
                          return Text('Hata');
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderLeadingButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            Color(0xff898EF8),
            Color(0xff7269DB),
          ])),
      child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff898EF8),
                Color(0xff7269DB),
              ]),
              borderRadius: BorderRadius.circular(8),
            ),
            height: 38,
            width: 38,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.of(context).pop();
              },
              child:
                  Center(child: SvgPicture.asset('assets/icons/leading.svg')),
            ),
          )),
    );
  }
}
