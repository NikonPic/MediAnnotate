import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

Flushbar showSaveFlushbar() {
  return Flushbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.save,
          color: Colors.greenAccent,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          'Segmentation saved!',
          style: TextStyle(color: kBackgroundColor),
        )
      ],
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: kPrimaryColor,
  );
}

Flushbar showDeleteFlushbar() {
  return Flushbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.delete,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          'Segmentation deleted!',
          style: TextStyle(color: kBackgroundColor),
        )
      ],
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: kPrimaryColor,
  );
}

Flushbar showEmptyFlushbar() {
  return Flushbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.connect_without_contact,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          'Empty!',
          style: TextStyle(color: kBackgroundColor),
        )
      ],
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: kPrimaryColor,
  );
}

Flushbar showNoNameFlushbar() {
  return Flushbar(
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_box_rounded,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          'Please enter name!',
          style: TextStyle(color: kBackgroundColor),
        )
      ],
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: kPrimaryColor,
  );
}
