import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground/pages/calendar_page.dart';
import 'package:ui_playground/pages/color_bg_page.dart';
import 'package:ui_playground/pages/custom_volume_page.dart';
import 'package:ui_playground/pages/ec_page.dart';
import 'package:ui_playground/pages/hide_screen_page.dart';
import 'package:ui_playground/pages/interactive_selector_page.dart';
import 'package:ui_playground/pages/line_chart_page.dart';
import 'package:ui_playground/pages/shining_border.dart';
import 'package:ui_playground/pages/matrix4_list_page.dart';
import 'package:ui_playground/pages/particle_page.dart';
import 'package:ui_playground/pages/perspective_page.dart';
import 'package:ui_playground/pages/side_selector.dart';
import 'package:ui_playground/pages/slide_select_page.dart';
import 'package:ui_playground/pages/spin_label_page.dart';
import 'package:ui_playground/pages/tag_selector_page.dart';
import 'package:ui_playground/pages/texture_page.dart';

// 新しいpageを追加する場合は、pagesリストにMapを追加する
List<Map<String, dynamic>> pages = [
  {
    'name': 'line_chart',
    'page': const LineChartPage(),
  },
  {
    'name': 'side_selector',
    'page': const SideSelectorPage(),
  },
  {
    'name': 'shining_border',
    'page': const ShiningBorderPage(),
  },
  {
    'name': 'particle',
    'page': const ParticlePage(),
  },
  {
    'name': 'texture',
    'page': const TexturePage(),
  },
  {
    'name': 'tag_selector',
    'page': const TagSelectorPage(),
  },
  {
    'name': 'spin_label',
    'page': const SpinLabelPage(),
  },
  {
    'name': 'interactive_selector',
    'page': const InteractiveSelector(),
  },
  {
    'name': 'calendar',
    'page': const CalendarPage(),
  },
  {
    'name': 'slide_select',
    'page': const SlideSelectPage(),
  },
  {
    'name': 'perspective',
    'page': const PerspectivePage(),
  },
  {
    'name': 'color_bg',
    'page': const ColorBgPage(),
  },
  {
    'name': 'hide_screen',
    'page': const HideScreenPage(),
  },
  {
    'name': 'ec',
    'page': const EcPage(),
  },
  {
    'name': 'matrix4List',
    'page': const Matrix4ListPage(),
  },
  {
    'name': 'volume_controller',
    'page': const CustomVolumePage(),
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
