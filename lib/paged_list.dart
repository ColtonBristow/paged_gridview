import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class BookNamePicker extends StatefulWidget {
  final void Function(String) onTap;
  final List<String> bookNames;
  final String correctBookName;
  final Function(int)? onPageChange;
  final double height;

  const BookNamePicker({
    Key? key,
    required this.bookNames,
    required this.onTap,
    required this.correctBookName,
    this.onPageChange,
    required this.height,
  }) : super(key: key);

  @override
  State<BookNamePicker> createState() => _BookNamePickerState();
}

class _BookNamePickerState extends State<BookNamePicker> {
  late ScrollController scrollController;
  bool stopNudging = false;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final Size screenSize = MediaQuery.of(context).size;

    final pageHeight = MediaQuery.of(context).size.height * .35;
    final pageWidth = screenSize.width;
    final pagePadding = 10;

    final buttonHeight = screenSize.width * .15;
    final buttonWidth = screenSize.width * .3;
    final buttonRunSpacing = 10;
    final buttonSpacing = 10;

    // find how many buttons we can fit into the page by determining the area of the buttons with buttonRunSpacing and buttonSpacing and dividing by the area of the page and giving back an integer
    final int numButtons = math
        .min(
          widget.bookNames.length,
          ((pageWidth - (pagePadding * 2)) * (pageHeight - (pagePadding * 2))) / ((buttonWidth + buttonRunSpacing) * (buttonHeight + buttonSpacing)),
        )
        .floor();
    //then calculate how many pages we need for the buttons
    final int numPages = (widget.bookNames.length / numButtons).ceil();
    // we give the max amount of buttons to each page list, then give a page with the remaining buttons
    final List<List<String>> pages = [];
    for (int i = 0; i < numPages; i++) {
      final page = widget.bookNames.sublist(i * numButtons, math.min((i + 1) * numButtons, widget.bookNames.length));
      pages.add(page);
    }

    log("we have a total of ${widget.bookNames.length} we can only fit ${numButtons} buttons we will need $numPages page/s");

    return PageView.builder(
      itemCount: pages.length,
      scrollDirection: Axis.horizontal,
      scrollBehavior: ScrollBehavior(),
      controller: pageController,
      onPageChanged: widget.onPageChange,
      itemBuilder: (context, index) {
        return Container(
          height: widget.height,
          width: pageWidth,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(10),
          child: Wrap(
            runSpacing: buttonRunSpacing.toDouble(),
            spacing: buttonSpacing.toDouble(),
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.down,
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            children: pages[index].map((bookName) {
              return GestureDetector(
                onTap: () {
                  widget.onTap(bookName);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
