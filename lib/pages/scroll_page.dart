import 'package:flutter/material.dart';
import 'package:local_segmenter/core/constants.dart';
import 'package:local_segmenter/functionality/navigation.dart';
import 'package:local_segmenter/functionality/paths.dart';
import 'package:local_segmenter/functionality/read_images.dart';
import 'package:local_segmenter/widgets/util_card.dart';
import 'package:local_segmenter/pages/view_page.dart';
import 'package:local_segmenter/functionality/categories.dart';

import '../core/constants.dart';
import '../widgets/loading.dart';

class ScrollPage extends StatelessWidget {
  const ScrollPage({Key key, @required this.username}) : super(key: key);
  final String username;

  get kBackgroundColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          title: CustomNavigationAppBarScrollPage(),
          backgroundColor: kPrimaryColor,
        ),
      ),
      body: ScrollBody(
        username: username,
      ),
    );
  }
}

class ScrollBody extends StatefulWidget {
  final String username;
  const ScrollBody({Key key, @required this.username}) : super(key: key);

  @override
  _ScrollBodyState createState() => _ScrollBodyState(username: username);
}

class _ScrollBodyState extends State<ScrollBody> {
  final String username;

  List<String> _images = <String>[];
  int _lenList = 1;
  bool _loaded = false;
  List<bool> _done = <bool>[];
  List<bool> _selectImages = [true, false, false];
  bool _filterMode = false;

  _ScrollBodyState({@required this.username});

  @override
  void initState() {
    super.initState();
    initImages().then((result) {
      setState(() {
        _images = result;
        _lenList = result.length;
        _done = result.map((e) => false).toList();
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) {
      final Size size = MediaQuery.of(context).size;
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height * 0.05,
              child: ToggleButtons(
                children: [
                  Icon(Icons.all_inbox, size: 25),
                  Icon(Icons.category_rounded, size: 25),
                  Icon(Icons.check_box_outlined, size: 25),
                ],
                isSelected: _selectImages,
                renderBorder: false,
                onPressed: (int index) => toggleFunc(index),
              ),
            ),
            buildScrollView(size),
          ],
        ),
      );
    } else {
      return PersonalLoadingWidget();
    }
  }

  void toggleFunc(int index) {
    if (index == 0) {
      if (!_selectImages[0]) {
        setState(() {
          _selectImages = [true, false, false];
          _loaded = false;
        });
        initImages().then(
          (result) => setState(
            () {
              _images = result;
              _lenList = result.length;
              _loaded = true;
            },
          ),
        );
      }
    } else {
      bool save = !_selectImages[index];
      _selectImages = [false, false, false];
      // set to loading
      setState(() {
        _loaded = false;
        _selectImages[index] = save;
      });
      if (_selectImages[index]) {
        _resetActiveImages(index - 1);
      } else {
        initImages().then(
          (result) => setState(
            () {
              _images = result;
              _lenList = result.length;
              _loaded = true;
            },
          ),
        );
      }
    }
  }

  Future<void> _resetActiveImages(int select) async {
    List<String> _newImages =
        await initImagesModified(username, select, _filterMode);
    setState(() {
      _images = _newImages;
      _lenList = _newImages.length;
      _loaded = true;
    });
  }

  Container buildScrollView(Size size) {
    return _lenList > 1
        ? Container(
            height: size.height * 0.88,
            child: Scrollbar(
              child: GridView.builder(
                itemCount: _lenList,
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  return Center(
                    child: RecommendUtilCard(
                      imagePath: _images[index],
                      category: _images[index].split('/')[1],
                      percent: '',
                      name: _images[index].split('/')[2],
                      press: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPage(
                              counter: index,
                              username: username,
                              images: _images,
                            ),
                          ),
                        ).then((_) => setState(() {}))
                      },
                      done: _done[index],
                      username: username,
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300),
              ),
            ),
          )
        : Container(
            height: size.height * 0.88,
            child: Center(
              child: Text('Empty'),
            ),
          );
  }

  FutureBuilder<String> buildFutureBuilder(int index) {
    return FutureBuilder(
      future: readContent(
        formatFileName(_images[index], username),
      ),
      builder: (content, snapshot) {
        final String data = snapshot.data.toString();
        bool cl = false;
        bool cl2 = false;
        bool sh = false;
        if (data.length > 0) {
          if ((data.split('///')[0]).length > 0) {
            sh = true;
          }
          if (data.split('///').length > 2) {
            if (data.split('///')[2] != classCategoryList[0]) {
              cl = true;
            }
          }
          if (data.split('///').length > 3) {
            if (data.split('///')[3] != classCategoryList2[0]) {
              cl2 = true;
            }
          }
        }
        if (sh) {
          return RecommendUtilCard(
            imagePath: _images[index],
            category: _images[index].split('/')[1],
            percent: '',
            name: _images[index].split('/')[2],
            press: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPage(
                    counter: index,
                    username: username,
                    images: _images,
                  ),
                ),
              ).then((_) => setState(() {}))
            },
            done: _done[index],
            username: username,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
