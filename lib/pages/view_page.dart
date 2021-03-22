import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../functionality/categories.dart';
import '../functionality/navigation.dart';
import '../functionality/paths.dart';
import '../functionality/signature.dart';
import '../widgets/custom_flat_button.dart';
import '../widgets/flushbars.dart';
import '../widgets/loading.dart';
import '../widgets/points_info.dart';
import '../widgets/zoom_window.dart';
import '../widgets/dropdownbutton.dart';

class ViewPage extends StatelessWidget {
  final int counter;
  final String username;
  final List<String> images;

  const ViewPage({
    Key? key,
    required this.counter,
    required this.username,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.view_column_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          title: CustomNavigationAppBarViewPage(),
          backgroundColor: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: DrawView(
        username: username,
        counter: counter,
        images: images,
      ),
    );
  }
}

/// body of main Page as stateful Widget
class DrawView extends StatefulWidget {
  final int counter;
  final String username;
  final List<String> images;

  const DrawView({
    Key? key,
    required this.counter,
    required this.username,
    required this.images,
  }) : super(key: key);

  @override
  _DrawViewState createState() =>
      _DrawViewState(count: counter, username: username, images: images);
}

/// Main State Management and widget building
class _DrawViewState extends State<DrawView> {
  List<Offset?> _points = <Offset?>[];
  List<Offset?> _pointsSaved = <Offset>[];
  int _lenList = 1;
  int count;
  String dropdownValue = classCategoryList[0];
  TransformationController? controller;
  late Matrix4 prevControllerValue;

  //scale tacking
  bool watchScale = false;
  bool scaleChange = false;
  int updateCount = 0;

  final double widthFac = 1;
  final double heightFac = 0.68;
  final String username;
  final List<String> images;
  final double maxScale = 6.0;

  _DrawViewState(
      {required this.images, required this.username, required this.count});

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    prevControllerValue = controller!.value;
    setSavedPoints().then(
      (_) => setState(() {
        _lenList = images.length;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _lenList > 0 ? buildLoadedView(context) : PersonalLoadingWidget();
  }

  Widget buildLoadedView(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double drawWidth = size.width * widthFac;
    final double drawHeight = size.height - 300;
    final String imageName = _lenList > 0 ? images[count] : 'assets/demo.PNG';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildDrawImageScreen(drawWidth, drawHeight, context, size, imageName),
          SizedBox(height: size.height * 0.025),
          MyDropDownButton(
            doIt: _setEntity,
            locList: classCategoryList,
            locValue: dropdownValue,
          ),
          SizedBox(height: size.height * 0.02),
          buildButtonRow(),
          SizedBox(height: size.height * 0.01),
          buildBottomSlider(),
        ],
      ),
    );
  }

  Slider buildBottomSlider() {
    return Slider(
      activeColor: kPrimaryColor,
      inactiveColor: kPrimaryColor.withOpacity(0.4),
      value: count.toDouble(),
      onChanged: (newCount) {
        _decreaseIncreaseWithAlertDialog(_setNewCountValue, newCount: newCount);
      },
      min: 0,
      max: (_lenList - 1).toDouble(),
      label: "$count",
    );
  }

  _setNewCountValue(double newCount) {
    _points.clear();

    dropdownValue = classCategoryList[0];
    count = newCount.toInt();
    setSavedPoints();
    setState(() {
      controller!.value = Matrix4.identity();
    });
  }

  /// Load Image from repo and display a Canvas to draw above
  SizedBox buildDrawImageScreen(double drawWidth, double drawHeight,
      BuildContext context, Size size, String imageName) {
    return SizedBox(
      width: drawWidth,
      height: drawHeight,
      child: Stack(children: [
        buildContainerWithGesture(
            context, drawHeight, drawWidth, size, imageName),
        Row(
          children: [
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.undo_outlined,
                color: kPrimaryColor.withOpacity(0.8),
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  _points = redoPoints(_points);
                });
              },
            ),
          ],
        )
      ]),
    );
  }

  /*
  Undo The Panning Movement
  */
  void _resetPan() {
    double curScale = controller!.value[0];
    double oldScale = prevControllerValue[0];

    if (curScale == oldScale) {
      Matrix4 newValue = controller!.value.clone();
      newValue[12] = prevControllerValue[12];
      newValue[13] = prevControllerValue[13];
      controller!.value = newValue;
    }
  }

  void _interactiveStart(ScaleStartDetails details) {
    setState(
      () {
        prevControllerValue = controller!.value;
        updateCount = 0;
        watchScale = true;
        scaleChange = false;
      },
    );
  }

  void _interactiveUpdate(ScaleUpdateDetails details) {
    if (!scaleChange) {
      _resetPan();

      if (details.scale != 1.0) {
        setState(() {
          scaleChange = true;
        });
      }
      if (updateCount > 7) {
        Offset _localPosition = details.localFocalPoint;
        _localPosition = _localPosition.translate(
            -controller!.value[12], -controller!.value[13]);
        _localPosition /= controller!.value[0];

        _points = List.from(_points)..add(_localPosition);
      }

      setState(
        () {
          _points = _points;
          prevControllerValue = controller!.value;
          updateCount += 1;
        },
      );
    }
  }

  void _interactiveEnd(_) {
    setState(
      () {
        _points.add(null);

        if (scaleChange) {
          _points = redoPoints(_points);
        }
        _points = redoShortPoints(_points);
      },
    );
  }

  Container buildContainerWithGesture(BuildContext context, double drawHeight,
      double drawWidth, Size size, String imageName) {
    return Container(
      alignment: Alignment.center,
      child: InteractiveViewer(
        transformationController: controller,
        clipBehavior: Clip.none,
        panEnabled: true,
        scaleEnabled: true,
        constrained: true,
        alignPanAxis: true,
        minScale: 1.0,
        maxScale: maxScale,
        onInteractionStart: _interactiveStart,
        onInteractionUpdate: _interactiveUpdate,
        onInteractionEnd: _interactiveEnd,
        child: Stack(
          children: [
            ImageChild(imageName: imageName),
            CustomPaint(
              painter: Signature(
                points: _pointsSaved,
                color: kSecondaryColor,
                strokeWidth: 2,
              ),
              size: size,
            ),
            CustomPaint(
              painter: Signature(
                points: _points,
                color: Colors.deepOrange,
                strokeWidth: 1,
              ),
              size: size,
            ),
          ],
        ),
      ),
    );
  }

  /// Display the 4 Buttons and their functionality
  Row buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: kPrimaryColor.withOpacity(0.8),
          onPressed: () => _decreaseIncreaseWithAlertDialog(_decrease),
        ),
        Spacer(),
        TitleWithCustomButton(
          buttonName: 'Save',
          press: _saveFunc,
        ),
        Spacer(),
        TitleWithCustomButton(
          buttonName: 'Clear',
          press: _clearFunc,
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: kPrimaryColor.withOpacity(0.8),
          ),
          onPressed: () => _decreaseIncreaseWithAlertDialog(_increase),
        ),
        Spacer(),
      ],
    );
  }

  void _setEntity(String newValue) async {
    setState(() {
      dropdownValue = newValue;
      _saveFunc();
    });

    // if empty and no value selected delete file
    if (dropdownValue == classCategoryList[0]) {
      if (_pointsSaved.length == 1) {
        final String fileName = formatFileName(images[count], username);
        await deleteContent(fileName);
      }
    }
  }

  /// Define the string to save
  Future<String> generateSaveString() async {
    final Size size = MediaQuery.of(context).size;
    final int drawWidth = (size.width * widthFac).toInt();
    final int drawHeight = (size.height * heightFac).toInt();

    final int imgWidth = 5;
    final int imgHeight = 5;

    String generatedData = formatPoints(_points);
    generatedData =
        '$generatedData///$drawWidth, $drawHeight, $imgWidth, $imgHeight///$dropdownValue///';
    return generatedData;
  }

  /// load the points from disk
  Future setSavedPoints() async {
    try {
      final String fileName = formatFileName(images[count], username);
      final String savedData = await readContent(fileName);
      final String pointsData = savedData.split('///')[0];
      _pointsSaved = getPointsFromData(pointsData);
      if (savedData.split('///').length > 2) {
        dropdownValue = savedData.split('///')[2];
      }
    } on Exception catch (_) {
      _pointsSaved.clear();
      dropdownValue = classCategoryList[0];
    }
  }

  /// Switch image, reduce int and clear points
  void _decreaseIncreaseWithAlertDialog(Function performFunction,
      {double newCount = 0}) async {
    if (_points.length > 1) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Do you want to save?"),
          actions: [
            TextButton(
                onPressed: () {
                  _saveFunc();
                  performFunction(newCount);
                  Navigator.pop(context);
                },
                child: Text('Yes')),
            TextButton(
              onPressed: () {
                performFunction(newCount);
                Navigator.pop(context);
              },
              child: Text('No'),
            )
          ],
        ),
      );
    } else {
      performFunction(newCount);
    }
  }

  void _decrease(double newCount) async {
    if (count - 1 >= 0) {
      count--;
    }
    controller!.value = Matrix4.identity();
    _points.clear();
    dropdownValue = classCategoryList[0];
    await setSavedPoints();
    setState(() {});
  }

  void _increase(double newCount) async {
    if (count + 1 < _lenList) {
      count++;
    }
    controller!.value = Matrix4.identity();
    _points.clear();
    dropdownValue = classCategoryList[0];
    await setSavedPoints();
    setState(() {});
  }

  /// Save the current segmentation in local repo
  void _saveFunc() async {
    controller!.value = Matrix4.identity();
    final String fileName = formatFileName(images[count], username);
    if (_points.length > 0) {
      //points and possibly category
      _pointsSaved = List.from(_points);
      await writeContent(fileName, await generateSaveString());
      await setSavedPoints();
      _points.clear();
      setState(() {});
    } else if (_pointsSaved.length > 0) {
      // only category
      _points = List.from(_pointsSaved);
      await writeContent(fileName, await generateSaveString());
      await setSavedPoints();
      _points.clear();
      setState(() {});
    } else if (dropdownValue != classCategoryList[0]) {
      // only category
      _points = List.from(_pointsSaved);
      await writeContent(fileName, await generateSaveString());
      await setSavedPoints();
      _points.clear();
      setState(() {});
    } else {
      final snackBar = showEmptyFlushbar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Clear the current segmentation
  void _clearFunc() async {
    final String fileName = formatFileName(images[count], username);
    if (_points.length > 0) {
      _points.clear();
      setState(() {});
    } else if (dropdownValue != classCategoryList[0]) {
      if (_pointsSaved.length > 0) {
        _points = List.from(_pointsSaved);
      }
      dropdownValue = classCategoryList[0];
      await writeContent(fileName, await generateSaveString());
      _points.clear();
      setState(() {});
    } else if (_pointsSaved.length > 0) {
      _pointsSaved.clear();
      dropdownValue = classCategoryList[0];
      await deleteContent(fileName);
      setState(() {});
    } else {
      final snackBar = showEmptyFlushbar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
