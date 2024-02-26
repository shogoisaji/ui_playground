import 'dart:ui';

import 'package:flutter/material.dart';

class DragListPage extends StatefulWidget {
  const DragListPage({super.key});

  @override
  State<DragListPage> createState() => _DragListPageState();
}

class _DragListPageState extends State<DragListPage> {
  final items = List.generate(20, (index) => 'Item $index');

  final reorderableController = ScrollController();
  final singleChildScrollController = ScrollController();
  bool _isScrollable = false;
  bool _isShowListView = false;
  double _listViewHeight = 0.0;

  double _listViewUpperPosition = 0.0;
  final _listViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenHeight = MediaQuery.sizeOf(context).height;

      final RenderBox? renderBox = _listViewKey.currentContext?.findRenderObject() as RenderBox?;
      final position = renderBox?.localToGlobal(Offset.zero);
      setState(() {
        _listViewUpperPosition = position?.dy ?? 0.0;
        _listViewHeight = screenHeight - _listViewUpperPosition - 100;
      });
      if (reorderableController.hasClients) {
        reorderableController.position.isScrollingNotifier.addListener(() {
          if (reorderableController.offset < 0 && _isShowListView) {
            setState(() {
              _isScrollable = false;
            });
          } else if (reorderableController.offset > reorderableController.position.maxScrollExtent) {
            setState(() {
              _isScrollable = false;
            });
          }
        });
      }
      if (singleChildScrollController.hasClients) {
        singleChildScrollController.position.isScrollingNotifier.addListener(() {
          if (singleChildScrollController.offset > _listViewUpperPosition) {
            setState(() {
              _isShowListView = true;
            });
          }
        });
      }
      singleChildScrollController.position.addListener(() {
        setState(() {
          _listViewUpperPosition = singleChildScrollController.offset;
          if (_listViewUpperPosition > 250) {
            _isScrollable = false;
            _listViewHeight = screenHeight - _listViewUpperPosition - 100;
          } else {
            _listViewHeight = screenHeight + _listViewUpperPosition;
            _isScrollable = true;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Drag List'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              controller: singleChildScrollController,
              child: Column(children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    )),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // height: 500,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _listViewHeight,
                        child: ReorderableListView(
                          key: _listViewKey,
                          scrollController: reorderableController,
                          onReorderStart: (index) {
                            setState(() {
                              _isScrollable = true;
                            });
                          },
                          onReorderEnd: (index) {
                            setState(() {
                              _isScrollable = false;
                            });
                          },
                          physics: _isScrollable
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: true,
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final item = items.removeAt(oldIndex);
                              items.insert(newIndex, item);
                            });
                          },
                          children: [
                            ...{
                              for (var i = 0; i < items.length; i++)
                                ListTile(key: ValueKey(i), title: Text('Item ${i + 1}'))
                            }
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            //
                          },
                          child: const Text('add'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    )),
              ])),
        ));
  }
}
