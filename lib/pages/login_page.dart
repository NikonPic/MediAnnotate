import 'package:flutter/material.dart';
import 'package:local_segmenter/core/constants.dart';
import 'package:local_segmenter/widgets/flushbars.dart';
import 'package:local_segmenter/pages/scroll_page.dart';

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
                  ),
                ),
                TextFieldContainer(
                  size: size,
                  color: kPrimaryColor.withOpacity(1),
                  radius: 30,
                  child: FlatButton(
                    onPressed: goToScrollPage,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: kBackgroundColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Please contact nikolas.wilhelm@tum.de for support.",
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScrollPage(
            username: myController.text,
          ),
        ),
      );
    } else {
      showNoNameFlushbar().show(context);
    }
  }
}

class TextFieldContainer extends StatelessWidget {
  const TextFieldContainer({
    Key key,
    @required this.size,
    @required this.child,
    @required this.color,
    @required this.radius,
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
