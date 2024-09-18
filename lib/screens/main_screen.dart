import 'package:ard_blue_web/screens/info_fragment.dart';
import 'package:ard_blue_web/widgets/soldier_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/models/soldier_model.dart';
import '../utils/themes/color_manager.dart';
import '../utils/themes/text_manager.dart';
import '../utils/widgets/sizedbox_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Stream<List<Soldier>>? _soldiersStream;

  int _selectedSoldierIndex = 0;
  // final int _alertSoldierIndex = 0;
  bool _isAlert = false;
  Soldier? _alertSoldier;

  @override
  void initState() {
    super.initState();
    _soldiersStream = getSoldiers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder(
          stream: _soldiersStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Soldier> soldiers = snapshot.data!;
              if (soldiers.isEmpty) {
                return Center(
                    child: Text('병사 정보가 없습니다.',
                        style: TextManager.second17,
                        overflow: TextOverflow.ellipsis));
              } else {
                return Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: ColorManager.grey,
                                width: 0.2,
                              ),
                            ),
                          ),
                          child:
                              ListView(children: _buildSoldierList(soldiers))),
                    ),
                    Flexible(
                        flex: 3,
                        child: InfoFragment(
                            soldier: soldiers[_selectedSoldierIndex],
                            selectedSoldierIndex: _selectedSoldierIndex))
                  ],
                );
              }
            }
            if (snapshot.hasError) {
              print("Stream Error: ${snapshot.error}");
              return const Center(child: Text("정보를 불러오는 과정에서 문제가 생겼습니다."));
            }
            if (!snapshot.hasData) {
              return _buildProgressIndicator();
            } else {
              return _buildProgressIndicator();
            }
          }),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: ColorManager.highlight,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Text('Soldier Health Monitor', style: TextManager.main19),
      ),
      backgroundColor: _isAlert ? ColorManager.error : ColorManager.background,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: ColorManager.grey,
          height: 0.4,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: Row(
            children: [
              if (_isAlert) ...[
                Text('훈련병 ${_alertSoldier?.name}의 상태에 이상이 있습니다.',
                    style: TextManager.main17),
                const Width(8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAlert = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(color: ColorManager.white, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('확인', style: TextManager.main17),
                ),
              ],
              const Width(16),
              IconButton(
                onPressed: () {
                  final db = FirebaseFirestore.instance;
                  db.collection('soldiers').add({
                    'name': '하지원',
                    'lat': 37.239485,
                    'lng': 127.083531,
                    'temp': 38,
                    'bpm': 130,
                  }).then(
                      (value) => print('Soldier added with ID: ${value.id}'));
                },
                icon: Icon(
                  Icons.notifications,
                  color: ColorManager.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSoldierList(List<Soldier> soldiers) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForAlerts(soldiers);
    });
    return soldiers.map((soldier) {
      return GestureDetector(
          onTap: () => onSoldierTilePressed(soldiers.indexOf(soldier)),
          child: SoldierTile(soldier: soldier));
    }).toList();
  }

  void onSoldierTilePressed(int index) {
    setState(() {
      _selectedSoldierIndex = index;
    });
    // print('Selected soldier: ${_soldiers[_selectedSoldierIndex].name}');
  }

  void checkForAlerts(List<Soldier> soldiers) {
    for (var soldier in soldiers) {
      if (soldier.temp > 37 || (soldier.bpm > 190 || soldier.bpm < 40)) {
        setState(() {
          _isAlert = true;
          _alertSoldier = soldier;
        });
        break;
      } else {
        setState(() {
          _isAlert = false;
          _alertSoldier = null;
        });
      }
    }
  }

  Stream<List<Soldier>> getSoldiers() async* {
    List<Soldier> soldiers = [];

    final snapshot = db.collection('soldiers').snapshots();

    await for (final query in snapshot) {
      soldiers = [];
      for (var doc in query.docs) {
        final soldier = Soldier.fromFirestore(doc.id, doc.data());
        soldiers.add(soldier);
      }
      print('soldiers list: ${soldiers.map((e) => e.name).toList()}');
      yield soldiers;
    }
  }

// dummy data
  // Soldier soldier1 = Soldier(
  //   id: '1',
  //   name: '하지원',
  //   lat: 0.0,
  //   lng: 0.0,
  //   temp: 0.0,
  //   bpm: 72.0,
  // );

  // Soldier soldier2 = Soldier(
  //   id: '2',
  //   name: '오해원',
  //   lat: 0.0,
  //   lng: 0.0,
  //   temp: 0.0,
  //   bpm: 92.0,
  // );
}
