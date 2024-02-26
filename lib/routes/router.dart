import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground/pages/calendar_page.dart';
import 'package:ui_playground/pages/color_bg.dart';
import 'package:ui_playground/pages/custom_valume_page.dart';
import 'package:ui_playground/pages/drag_list_page.dart';
import 'package:ui_playground/pages/ec_page.dart';
import 'package:ui_playground/pages/hide_screen_page.dart';
import 'package:ui_playground/pages/interactive_selector.dart';
import 'package:ui_playground/pages/matrix4_list.dart';
import 'package:ui_playground/pages/perspective_page.dart';
import 'package:ui_playground/pages/slide_select_page.dart';
import 'package:ui_playground/pages/spin_label_page.dart';

// 新しいpageを追加する場合は、pagesリストにMapを追加する
List<Map<String, dynamic>> pages = [
  {
    'name': 'volume_controller',
    'page': const CustomVolumePage(),
  },
  {
    'name': 'matrix4List',
    'page': const Matrix4ListPage(),
  },
  {
    'name': 'ec',
    'page': const EcPage(),
  },
  {
    'name': 'hide_screen',
    'page': const HideScreenPage(),
  },
  {
    'name': 'color_bg',
    'page': const ColorBgPage(),
  },
  {
    'name': 'perspective',
    'page': const PerspectivePage(),
  },
  {
    'name': 'slide_select',
    'page': const SlideSelectPage(),
  },
  {
    'name': 'calendar',
    'page': const CalendarPage(),
  },
  {
    'name': 'drag_list',
    'page': const DragListPage(),
  },
  {
    'name': 'interactive_selector',
    'page': const InteractiveSelector(),
  },
  {
    'name': 'spin_label',
    'page': const SpinLabelPage(),
  },
];

GoRouter router() {
  final _routes = [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        const BREAKPOINT = 800;
        final w = MediaQuery.sizeOf(context).width;
        return Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            backgroundColor: Colors.red[200],
            title: const Text('UI playground',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 8),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: ListView.builder(
                      itemCount: pages.length,
                      itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.all(8),
                        color: Colors.pink[200],
                        child: ListTile(
                          onTap: () {
                            context.go('/${pages[index]['name']}');
                          },
                          title: Center(
                            child: Text(
                              '${pages[index]['name']}',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: w > BREAKPOINT ? 24 : 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      routes: [
        ...List.generate(
          pages.length,
          (index) => GoRoute(
            path: '${pages[index]['name']}',
            builder: (BuildContext context, GoRouterState state) {
              return pages[index]['page'];
            },
          ),
        ),
      ],
    ),
  ];

  return GoRouter(
    initialLocation: '/',
    routes: _routes,
  );
}
