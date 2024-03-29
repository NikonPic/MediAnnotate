import 'dart:io';

import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/flushbars.dart';
import 'scroll_page.dart';
import 'package:path_provider/path_provider.dart';

class LoginWithName extends StatefulWidget {
  @override
  _LoginWithNameState createState() => _LoginWithNameState();
}

class _LoginWithNameState extends State<LoginWithName> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/demo.PNG',
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldContainer(
                  size: size,
                  color: kPrimaryColor.withOpacity(0.15),
                  radius: 10,
                  child: TextFormField(
                    controller: myController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_box,
                        color: kPrimaryColor,
                      ),
                      labelText: 'Please enter name',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {},
                    onFieldSubmitted: (_) {
                      goToScrollPage();
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Developed by M.Sc. Nikolas Wilhelm",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToScrollPage() {
    final String name = myController.text;

    if (name.length > 0) {
      //check if name already exists
      createFolderInAppDocDir(name);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScrollPage(
            username: myController.text,
          ),
        ),
      );
    } else {
      final snackBar = showNoNameFlushbar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

Future<String> createFolderInAppDocDir(String folderName) async {
  //Get this App Document Directory
  final _appDocDir = await getExternalStorageDirectory();
  //App Document Directory + folder name
  final Directory _appDocDirFolder =
      Directory('${_appDocDir?.path}/$folderName/');

  if (await _appDocDirFolder.exists()) {
    //if folder already exists return path
    return _appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    Key? key,
    required this.size,
    required this.child,
    required this.color,
    required this.radius,
  }) : super(key: key);

  final Size size;
  final Widget child;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.7,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
