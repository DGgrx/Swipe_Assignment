import 'dart:io';
import 'package:flutter/material.dart';
import 'package:swipe/common/constants.dart';

class SelectedImage extends StatelessWidget {
  const SelectedImage(
      {required this.image,
      required this.index,
      super.key,
      required this.callback});

  final File image;
  final int index;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingGeneric,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 80,
                maxHeight: 80,
                maxWidth: 80,
                minWidth: 80,
              ),
              child: Image.file(
                image,
                fit: BoxFit.fitWidth,
              )),
          Positioned(
            right: -5,
            top: -10,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: const BorderRadius.all(Radius.circular(300)),
                border: Border.all(width: 0, color: Colors.transparent),
              ),
              child: IconButton(
                /// This is used to uniquely Identify the picked image so that
                /// when the [remove] function that is passed as a callback to
                /// this widget is called. the respective image from the list
                /// of images is removed.
                key: UniqueKey(),
                padding: EdgeInsets.zero,
                onPressed: callback,
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
