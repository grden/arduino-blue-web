import 'dart:async';

import 'package:ard_blue_web/utils/models/soldier_model.dart';
import 'package:ard_blue_web/utils/themes/color_manager.dart';
import 'package:ard_blue_web/utils/themes/text_manager.dart';
import 'package:ard_blue_web/utils/widgets/sizedbox_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/constants.dart';

class InfoFragment extends StatefulWidget {
  const InfoFragment({
    super.key,
    required Soldier soldier,
    required int selectedSoldierIndex,
  })  : _soldier = soldier,
        _selectedSoldierIndex = selectedSoldierIndex;

  final Soldier _soldier;
  final int _selectedSoldierIndex;

  @override
  State<InfoFragment> createState() => _InfoFragmentState();
}

class _InfoFragmentState extends State<InfoFragment> {
  final List<FlSpot> _heartRateData = [];
  // late Timer _timer;
  late StreamSubscription<Soldier> _subscription;

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // Initialize with current BPM
    _heartRateData.add(FlSpot(0, widget._soldier.bpm.toDouble()));

    // Update data every second
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     if (_heartRateData.length >= 60) _heartRateData.removeAt(0);
    //     _heartRateData.add(FlSpot(
    //         _heartRateData.length.toDouble(), widget._soldier.bpm.toDouble()));
    //   });
    // });

    _subscription = getSoldier(widget._soldier.id).listen((updatedSoldier) {
      setState(() {
        if (_heartRateData.length >= 60) _heartRateData.removeAt(0);
        _heartRateData.add(FlSpot(
            _heartRateData.length.toDouble(), updatedSoldier.bpm.toDouble()));
      });
    });
  }

  @override
  void dispose() {
    // _timer.cancel();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Height(32),
            Text(
              widget._soldier.name,
              style: TextManager.main29,
            ),
            const Height(32),
            _buildBPMTile(),
            const Height(16),
            Divider(
              color: ColorManager.grey,
              height: 1,
              thickness: 0.2,
            ),
            const Height(16),
            _buildTempTile(),
            const Height(16),
            Divider(
              color: ColorManager.grey,
              height: 1,
              thickness: 0.2,
            ),
            const Height(16),
            _buildGPSTile(),
            const Height(24),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              height: 320,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildMapTile()),
            ),
            const Height(32),
          ],
        ),
      ),
    );
  }

  Widget _buildBPMTile() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '심박수',
            style: TextManager.second17,
          ),
          Text(
            '${widget._soldier.bpm.toString()} bpm',
            style: TextManager.main23,
          ),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _heartRateData,
                    isCurved: true,
                    color: ColorManager.highlight,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.highlight.withOpacity(0.1),
                          ColorManager.highlight.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                minX: 0,
                maxX: 59,
                minY: 0,
                maxY: 200, // Assuming max heart rate of 200 bpm
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempTile() {
    return Row(
      children: [
        Text('체온', style: TextManager.second17),
        const Width(86),
        Text('${widget._soldier.temp.toString()} °C',
            style: TextManager.inverse17),
        const Width(12),
        if (widget._soldier.temp > 37)
          Text(
            '체온이 정상보다 높습니다.',
            style: TextManager.error17,
          ),
      ],
    );
  }

  Widget _buildGPSTile() {
    return Column(
      children: [
        Row(
          children: [
            Text('위도, 경도', style: TextManager.second17),
            const Width(48),
            Text(
                '${widget._soldier.lat.toString()}, ${widget._soldier.lng.toString()}',
                style: TextManager.inverse17),
          ],
        ),
      ],
    );
  }

  void _updateMapLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(widget._soldier.lat, widget._soldier.lng),
        ),
      );
    }
  }

  Widget _buildMapTile() {
    Stream<Soldier> soldierStream = getSoldier(widget._soldier.id);

    return StreamBuilder<Soldier>(
      stream: soldierStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final updatedSoldier = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateMapLocation();
          });
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(updatedSoldier.lat, updatedSoldier.lng),
              zoom: 16,
            ),
            markers: {
              Marker(
                markerId: MarkerId(updatedSoldier.name),
                position: LatLng(updatedSoldier.lat, updatedSoldier.lng),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Stream<Soldier> getSoldier(String id) async* {
    final snapshot = db.collection('soldiers').doc(id).snapshots();

    await for (final query in snapshot) {
      final soldier = Soldier.fromFirestore(query.id, query.data()!);
      yield soldier;
    }
  }
}
