import 'package:flutter/material.dart';
import '../widgets/page_pageView_widget.dart';

class pageViewElement extends StatefulWidget {
  const pageViewElement({super.key});

  @override
  State<pageViewElement> createState() => _pageViewElementState();
}

class _pageViewElementState extends State<pageViewElement> {
  final List<Map<String, dynamic>> _pageData = [
    {
      'title': 'Welcome to Iron Pulse',
      'body': 'Your journey to strength and discipline starts here.',
      'image': 'assets/page1.jpg',
    },
    {
      'title': 'Track Your Progress',
      'body': 'Log your workouts and see your growth, rep by rep.',
      'image': 'assets/page2.jpg',
    },
    {
      'title': 'Stay Motivated',
      'body': 'Challenge yourself and keep the pulse alive.',
      'image': 'assets/page3.jpg',
    },
    {
      'title': 'Join Iron Pulse Community Now',
      'body': 'Sign in or create an account to start your fitness journey',
      'image': 'assets/lastPage.png',
    },
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 650,
          // width: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            child: PageView.builder(
              onPageChanged: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemCount: _pageData.length,
              itemBuilder: (BuildContext context, int index) {
                return PageInPageView(
                  title: _pageData[index]['title']!,
                  body: _pageData[index]['body']!,
                  image: _pageData[index]['image']!,
                  index: index,
                  totalPages: _pageData.length,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < _pageData.length; i++) {
      indicators.add(
        Container(
          width: 20,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPageIndex == i
                ? Color.fromARGB(199, 252, 112, 70)
                : Colors.grey,
          ),
        ),
      );
    }

    return indicators;
  }
}
