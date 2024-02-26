import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with SingleTickerProviderStateMixin {
  Offset calendarPosition = const Offset(0, 0);
  late AnimationController? _controller;
  late Animation<double>? _animation;
  String selectListString = '';

  final double _range = 100;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    void _onDragUpdate(double deltaY) {
      _controller!.value -= deltaY / _range;
    }

    void _resetCalendarPosition() {
      setState(() {
        print("resetCalendarPosition:${_controller!.value}");
        _controller!.animateTo(0);
        // _calendarPosition = const Offset(0, 0);
      });
    }

    void _selectList(String selectList) {
      setState(() {
        selectListString = selectList;
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFB2FF36),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.sizeOf(context).width * 0.85 * 1.52 - 70,
            left: 30,
            child: Column(
              children: [
                Text(
                  "12/20 12:20",
                  style: TextStyle(color: Colors.grey[700], fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "東京駅集合",
                  style: TextStyle(color: Colors.grey[700], fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).width * 0.85 * 1.52 + 12,
            left: 30,
            child: Text(
              selectListString,
              style: TextStyle(color: Colors.grey[700], fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 55,
            right: 10,
            child: SizedBox(
              height: h * 0.7,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Icon(
                  Icons.ac_unit,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.access_alarm,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.accessibility_sharp,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.factory_sharp,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.garage,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.eco,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.thumb_up,
                  size: 40,
                  color: Colors.grey[500],
                ),
                Icon(
                  Icons.edit,
                  size: 40,
                  color: Colors.grey[500],
                ),
              ]),
            ),
          ),
          AnimatedBuilder(
            animation: _animation!,
            builder: (context, child) {
              final double nextLeft = -(_animation!.value < 0.5 ? 0 : _animation!.value - 0.5) * 50;
              return Positioned(
                top: -_animation!.value * 100,
                left: nextLeft,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.85 - nextLeft / 3,
                      height: MediaQuery.sizeOf(context).width * 0.85 * 1.52 - nextLeft,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5 + nextLeft / 4,
                            blurRadius: 7 - nextLeft / 1.5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    CalendarWidget(
                      onDragUpdate: _onDragUpdate,
                      onDragEnd: _resetCalendarPosition,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
              top: MediaQuery.sizeOf(context).width * 0.85 * 1.52 + 70,
              left: 0,
              child: ListWidget(selectList: _selectList)),
          // Positioned(
          //   top: 50,
          //   left: 5,
          //   child: IconButton(
          //       icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          //       onPressed: () {
          //         context.go('/');
          //       }),
          // ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final Function onDragUpdate;
  final Function onDragEnd;
  const CalendarWidget({super.key, required this.onDragUpdate, required this.onDragEnd});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  double calendarPositionY = 0.0;

  @override
  Widget build(BuildContext context) {
    final double _calenderWidth = MediaQuery.sizeOf(context).width * 0.85;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueGrey[800]!,
            Colors.blueGrey[900]!,
          ],
        ),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
      ),
      child: SizedBox(
        width: _calenderWidth,
        height: _calenderWidth * 1.52,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        context.go('/');
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.circleChevronLeft, color: Colors.green[100]),
                      onPressed: () {
                        //
                      },
                    ),
                    InkWell(
                      onTap: () {
                        //
                      },
                      child: Text(
                        '2024/3',
                        style: TextStyle(color: Colors.green[100], fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.circleChevronRight, color: Colors.green[100]),
                      onPressed: () {
                        //
                      },
                    ),
                  ],
                ),
              ),
              // 曜日表示
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(
                    7,
                    (index) => Container(
                      width: _calenderWidth / 7.5,
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.white),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                          child: Text(
                              [
                                "日",
                                "月",
                                "火",
                                "水",
                                "木",
                                "金",
                                "土",
                              ][index],
                              style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // カレンダー表示
              Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.only(top: 12.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: 30,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: _calenderWidth / 7.5,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.white),
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text((index + 1).toString(),
                                style: TextStyle(color: Colors.green[900], fontSize: _calenderWidth / 25))),
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Draggable(
                      onDragUpdate: (details) {
                        widget.onDragUpdate(details.delta.dy);
                        setState(() {
                          calendarPositionY += details.delta.dy;
                        });
                      },
                      onDragEnd: (details) {
                        widget.onDragEnd();
                        setState(() {
                          calendarPositionY = 0;
                        });
                      },
                      feedback: const Icon(Icons.drag_handle, color: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.drag_handle, color: Colors.green[100]),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListWidget extends StatefulWidget {
  final Function selectList;
  const ListWidget({super.key, required this.selectList});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      width: w,
      height: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueGrey[900]!,
            Colors.blueGrey[800]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -75,
            top: -25,
            child: Transform.rotate(
              angle: -3.14 / 2,
              child: Image.asset(
                'assets/images/schedule.png',
                color: Colors.green[100],
                width: 200,
                height: 300,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: w * 0.75,
              height: 500,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 66, 88, 67),
              ),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.all(8),
                        color: Colors.green[50],
                        child: ListTile(
                          onTap: () {
                            widget.selectList('party ${index + 1}');
                          },
                          title: Center(
                            child: Text(
                              'party ${index + 1}',
                              style: TextStyle(color: Colors.grey[800], fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
