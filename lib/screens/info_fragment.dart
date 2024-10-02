import 'dart:async';

import 'package:ard_blue_web/utils/models/soldier_model.dart';
import 'package:ard_blue_web/utils/themes/color_manager.dart';
import 'package:ard_blue_web/utils/themes/text_manager.dart';
import 'package:ard_blue_web/utils/widgets/sizedbox_widget.dart';
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
  StreamSubscription<Soldier>? _subscription;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _initializeHeartRateData();
  }

  void _initializeHeartRateData() {
    if (!mounted) return;

    setState(() {
      _heartRateData.clear();
      // Add initial data point to prevent the 'mostLeftSpot' error
      _heartRateData.add(FlSpot(0, widget._soldier.bpm.toDouble()));
    });

    _subscription?.cancel();
    _subscription = getSoldier(widget._soldier.id).listen((updatedSoldier) {
      if (!mounted) return;
      setState(() {
        if (_heartRateData.length >= 30) {
          _heartRateData.removeAt(0);
          // Shift x-values of remaining data points
          for (int i = 0; i < _heartRateData.length; i++) {
            _heartRateData[i] = FlSpot(i.toDouble(), _heartRateData[i].y);
          }
        }
        _heartRateData.add(FlSpot(
            _heartRateData.length.toDouble(), updatedSoldier.bpm.toDouble()));
      });
    }, onError: (error) {
      print('Error fetching soldier data: $error');
    });
  }

  @override
  void didUpdateWidget(InfoFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._selectedSoldierIndex != oldWidget._selectedSoldierIndex) {
      _subscription?.cancel();
      _initializeHeartRateData();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _mapController?.dispose();
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget._soldier.bpm.toString()} bpm',
                style: TextManager.main23,
              ),
              const Width(12),
              if (widget._soldier.bpm > 190 || widget._soldier.bpm < 40)
                Text(
                  '심박수가 정상 범위 밖입니다.',
                  style: TextManager.error17,
                ),
            ],
          ),
          SizedBox(
            height: 150,
            child: _heartRateData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : LineChart(
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
                      maxX: 29,
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
        if (widget._soldier.temp > 36)
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
