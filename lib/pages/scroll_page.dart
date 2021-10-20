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
  bool loaded = false;
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
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double fontS = 10;
    if (loaded) {
      final Size size = MediaQuery.of(context).size;
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height * 0.06,
              child: Row(
                children: [
                  Spacer(),
                  ToggleButtons(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.all_inbox, size: 25),
                            Text('All', style: TextStyle(fontSize: fontS))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.category_rounded, size: 25),
                            Text('Segmented', style: TextStyle(fontSize: fontS))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.check_box_outlined, size: 25),
                            Text('Classified',
                                style: TextStyle(fontSize: fontS))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.check_box_outline_blank, size: 25),
                            Text('Empty Annotation',
                                style: TextStyle(fontSize: fontS))
                          ],
                        ),
                      ),
                    ],
                    isSelected: _selectImages,
                    renderBorder: false,
                    onPressed: (int index) => toggleFunc(index),
                    borderWidth: 10,
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

  void toggleFunc(int index) async {
    // ensure updating
    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
          loaded = false;
          curtoggle = index;
          _selectImages = [false, false, false, false];
        }));
    setState(() {});
    if (index == 0) {
      if (!_selectImages[0]) {
        List<String> result = await initImages();
        setState(
          () {
            _images = result;
            _lenList = result.length;
            loaded = true;
          },
        );
      }
    } else if (index == 3) {
      List<String> result = await initImages();
      // now pick all images, which are modified
      List<String> filtered =
          await initImagesModified(username, 2, _filterMode);
      result.removeWhere((element) => filtered.contains(element));
      setState(() {
        _images = result;
        _lenList = result.length;
        loaded = true;
      });
    } else {
      // set to loading
      setState(() {
        _selectImages[index] = true;
      });
      if (_selectImages[index]) {
        await _resetActiveImages(index - 1);
      } else {
        List<String> result = await initImages();
        setState(
          () {
            _images = result;
            _lenList = result.length;
          },
        );
      }
    }
    // ensure updating
    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {
          loaded = true;
          _selectImages[index] = true;
        }));
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
      loaded = true;
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
                  // get trimmed name
                  String name = _images[index].split('/')[2];
                  if (name.length > 24) {
                    name = name.substring(0, 24);
                  }

                  return Center(
                    child: RecommendUtilCard(
                      imagePath: _images[index],
                      category: _images[index].split('/')[1],
                      percent: '',
                      name: name,
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
