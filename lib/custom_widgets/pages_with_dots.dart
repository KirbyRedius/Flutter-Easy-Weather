import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class PagesWithDots extends StatefulWidget {
  final List<Widget> children;
  final PageController? pageController;
  const PagesWithDots({super.key, required this.children, this.pageController});

  @override
  State<PagesWithDots> createState() => _PagesWithDotsState();
}

class _PagesWithDotsState extends State<PagesWithDots> {
  PageController? controller;

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      if (widget.pageController != null) {
        setState(() {
          controller = widget.pageController;
        });
      } else {
        setState(() {
          controller = PageController();
        });
      }
    }

    return InkWell(
      onTap: () {
        int _newSelectedPage = _selectedPage + 1;
        if (_newSelectedPage >= widget.children.length) {
          _newSelectedPage = 0;
        }
        controller!.animateToPage(
          _newSelectedPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );

        // print(_newSelectedPage);
        // setState(() {
        //   _selectedPage = _newSelectedPage;
        // });
      },
      child: Column(
        children: <Widget>[
          Flexible(
            child: PageView(
              controller: controller,
              children: widget.children,
              onPageChanged: (index) {
                setState(() {
                  _selectedPage = index;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageViewDotIndicator(
              currentItem: _selectedPage,
              count: widget.children.length,
              unselectedColor: const Color.fromARGB(255, 123, 123, 123),
              selectedColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
