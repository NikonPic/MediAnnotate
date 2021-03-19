import 'package:flutter/material.dart';

class PersonalLoadingWidget extends StatelessWidget {
  const PersonalLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.3,
            ),
            Image.asset('assets/demo.PNG'),
            SizedBox(
              height: 50,
            ),
            Text("Please contact nikolas.wilhelm@tum.de for support."),
            SizedBox(
              height: 50,
            ),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
