import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../functionality/navigation.dart';
import '../functionality/read_images.dart';
import '../widgets/loading.dart';
import '../widgets/util_card.dart';
import 'view_page.dart';

class ScrollPage extends StatelessWidget {
  const ScrollPage({Key? key, required this.username}) : super(key: key);
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
  const ScrollBody({Key? key, required this.username}) : super(key: key);

  @override
  _ScrollBodyState createState() => _ScrollBodyState(username: username);
}

class _ScrollBodyState extends State<ScrollBody> {
  final String username;

  List<String> _images = <String>[];
  int _lenList = 0;
  int _allImages = 0;
  bool _loaded = false;
  List<bool> _done = <bool>[];
  List<bool> _selectImages = [true, false, false, false];
  bool _filterMode = false;
  int curtoggle = 0;

  _ScrollBodyState({required this.username});

  @override
  void initState() {
    super.initState();
    initImages().then((result) {
      setState(() {
        _images = result;
        _lenList = result.length;
        _allImages = result.length;
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
              child: Row(
                children: [
                  Spacer(),
                  ToggleButtons(
                    children: [
                      Icon(Icons.all_inbox, size: 25),
                      Icon(Icons.category_rounded, size: 25),
                      Icon(Icons.check_box_outlined, size: 25),
                      Icon(Icons.check_box_outline_blank, size: 25),
                    ],
                    isSelected: _selectImages,
                    renderBorder: false,
                    onPressed: (int index) => toggleFunc(index),
                  ),
                  Spacer(),
                  Text(
                      'Items: $_lenList (${((_lenList / _allImages) * 100).floor()}%)'),
                  Spacer(),
                ],
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
    print(index);
    setState(() {
      curtoggle = index;
      _loaded = false;
      _selectImages = [false, false, false, false];
    });
    if (index == 0) {
      if (!_selectImages[0]) {
        setState(() {
          _selectImages = [false, false, false, false];
          _loaded = false;
        });
        initImages().then(
          (result) => setState(
            () {
              _images = result;
              _lenList = result.length;
              _loaded = true;
              _selectImages = [true, false, false, false];
            },
          ),
        );
      }
    } else if (index == 3) {
      setState(() {
        _loaded = false;
      });
      initImages().then((result) {
        // now pick all images, which are modified
        initImagesModified(username, 2, _filterMode).then((filtered) {
          result.removeWhere((element) => filtered.contains(element));
          setState(() {
            _images = result;
            _lenList = result.length;
            _loaded = true;
            _selectImages = [false, false, false, true];
          });
        });
      });
    } else {
      bool save = !_selectImages[index];
      _selectImages = [false, false, false, false];
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
    setState(() {
      _loaded = true;
    });
  }

  Future<void> _resetActiveImages(int select) async {
    List<String> _newImages =
        await initImagesModified(username, select, _filterMode);
    if (_newImages.length == 1 && _newImages[0] == "") {
      _newImages = [];
    }
    setState(() {
      _images = _newImages;
      _lenList = _newImages.length;
      _loaded = true;
    });
  }

  Container buildScrollView(Size size) {
    return _lenList > 0
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
                        ).then((_) {
                          toggleFunc(curtoggle);
                        })
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
}
