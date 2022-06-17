import 'dart:async';
import 'dart:math';

import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.ref();
double _dataAccelX = 0.0;
double _dataAccelY = 0.0;
double _dataAccelZ = 0.0;

class TimeChartAccelPage extends StatefulWidget {
  const TimeChartAccelPage({Key? key}) : super(key: key);

  @override
  _TimeChartAccelPage createState() => _TimeChartAccelPage();
}

class _TimeChartAccelPage extends State<TimeChartAccelPage> {
  final limitCount = 50;
  final accelXPoints = <FlSpot>[];
  final accelYPoints = <FlSpot>[];
  final accelZPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.5;

  late Timer timer;
  // Generate some dummy data for the cahrt
  // This will be used to draw the red line

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (accelXPoints.length > limitCount) {
        accelXPoints.removeAt(0);
        accelYPoints.removeAt(0);
        accelZPoints.removeAt(0);
      }
      setState(() {
        readData();
        accelXPoints.add(FlSpot(xValue, _dataAccelX));
        accelYPoints.add(FlSpot(xValue, _dataAccelY));
        accelZPoints.add(FlSpot(xValue, _dataAccelZ));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: double.infinity,
                child: Stack(children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Accelerometer Time Chart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                '___ X Axis',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '___ Y Axis',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '___ Z Axis',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                // The red line
                                LineChartBarData(
                                  spots: accelXPoints,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[0],
                                ),
                                // The green line
                                LineChartBarData(
                                  spots: accelYPoints,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[1],
                                ),
                                // The blue line
                                LineChartBarData(
                                  spots: accelZPoints,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[2],
                                )
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text('Accelero [g]',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 0,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                    reservedSize: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                        const Text(
                          'Time [s]',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ])
                ]))));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void readData() {
    databaseReference.child("Data").onValue.listen((event) {
      print('Data : ${event.snapshot.value}');
    });
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   print('Data : ${snapshot.value}');
    // });
    databaseReference.child('Data/AccelX').onValue.listen((event) {
      final data = event.snapshot.value;
      final accelX = data as double;
      _dataAccelX = accelX;
    });

    databaseReference.child('Data/AccelY').onValue.listen((event) {
      final data = event.snapshot.value;
      final accelY = data as double;
      _dataAccelY = accelY;
    });

    databaseReference.child('Data/AccelZ').onValue.listen((event) {
      final data = event.snapshot.value;
      final accelZ = data as double;
      _dataAccelZ = accelZ;
    });
  }
}

class FreqChartAccelPage extends StatefulWidget {
  const FreqChartAccelPage({Key? key}) : super(key: key);

  @override
  _FreqChartAccelPage createState() => _FreqChartAccelPage();
}

class _FreqChartAccelPage extends State<FreqChartAccelPage> {
  final limitCount = 50;
  var spotsSGAccelX = <FlSpot>[];
  var spotsSGAccelY = <FlSpot>[];
  var spotsSGAccelZ = <FlSpot>[];

  var accelXArray = Array([]);
  var accelYArray = Array([]);
  var accelZArray = Array([]);

  double xValue = 0;
  double step = 0.5;

  late Timer timer;
  // Generate some dummy data for the cahrt
  // This will be used to draw the red line

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (accelXArray.length > limitCount) {
        accelXArray.removeAt(0);
        accelYArray.removeAt(0);
        accelZArray.removeAt(0);
      }

      setState(() {
        _TimeChartAccelPage().readData();
        accelXArray.add(_dataAccelX);
        accelYArray.add(_dataAccelY);
        accelZArray.add(_dataAccelZ);
      });
      xValue += step;

//      // generate the signals for test
//      // 1Hz sine wave
      //  var N = 10.0
      // var n = limitCount.toDouble();
      // var n = 100.0;
      // var fs = 10.0; //sampling freq
      // var nDomain = linspace(0, n, num: (n * fs).toInt(), endpoint: false);
      // var f1 = 0.1; // 1Hz
      // var sg1 = arraySin(arrayMultiplyToScalar(nDomain, 2 * pi * f1));
      // print(sg1);
      // print(accelXArray);
      // var fEstAccelX = freqFromFft(sg1, fs);
      // var swFr = rfft(sg1);
      // print(swFr);

      // var swFScale = fftFreq(sg1.length, d: 1 / fs);
      // print(swFScale);
      // print(spots);
      // var fEstAccelX = freqFromFft(sg1, fs);
      // var fEstAccelY = freqFromFft(sg1, fs);
      // var fEstAccelZ = freqFromFft(sg1, fs);
      // var fEstAccelZ = freqFromFft(accelXArray, fs);
      var windowedAccelX = accelXArray * blackmanharris(accelXArray.length);
      var fAccelX = rfft(windowedAccelX);
      var fAbsAccelX = arrayComplexAbs(fAccelX);

      var windowedAccelY = accelYArray * blackmanharris(accelYArray.length);
      var fAccelY = rfft(windowedAccelY);
      var fAbsAccelY = arrayComplexAbs(fAccelY);

      var windowedAccelZ = accelZArray * blackmanharris(accelZArray.length);
      var fAccelZ = rfft(windowedAccelZ);
      var fAbsAccelZ = arrayComplexAbs(fAccelZ);

      // print('fAbs : $fAbs');
      // print(
      //     'The original and estimated frequency need be very close each other');
      // print('Estimated frequency Accel X: $fEstAccelX');
      // print('Estimated frequency Accel X: $fEstAccelY');
      // print('Estimated frequency Accel X: $fEstAccelZ');

      // print(rifft(swFr)); // inverse FFT of a real FFT

      // print(dbfft(sg1, fs)); // Return the frequency and fft in DB scale

      spotsSGAccelX = fAbsAccelX.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      spotsSGAccelY = fAbsAccelY.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      spotsSGAccelZ = fAbsAccelZ.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value);
      }).toList();

      // spotsSGY = fEstAccelY.asMap().entries.map((e) {
      //   return FlSpot(e.key.toDouble(), e.value);
      // }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: double.infinity,
                child: Stack(children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Accelerometer Spectogram',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                '___ X Axis',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                '___ Y Axis',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '___ Z Axis',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ]),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                            child: Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, left: 6.0),
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                // The red line
                                LineChartBarData(
                                  spots: spotsSGAccelX,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[0],
                                ),
                                // The green line
                                LineChartBarData(
                                  spots: spotsSGAccelY,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[1],
                                ),
                                // The blue line
                                LineChartBarData(
                                  spots: spotsSGAccelZ,
                                  isCurved: true,
                                  barWidth: 2,
                                  color: colors[2],
                                )
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  axisNameWidget: const Text('Gain [dB]',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 0,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                    reservedSize: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                        const Text(
                          'Frequency [Hz]',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ])
                ]))));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  double freqFromFft(Array sig, double fs) {
    // Estimate frequency from peak of FFT

    // Compute Fourier transform of windowed signal
    // Avoid spectral leakage: https://en.wikipedia.org/wiki/Spectral_leakage
    var windowed = sig * blackmanharris(sig.length);
    var f = rfft(windowed);

    var fAbs = arrayComplexAbs(f);

    // Find the peak and interpolate to get a more accurate peak
    var i = arrayArgMax(fAbs); // Just use this for less-accurate, naive version

    // Parabolic approximation is necessary to get the exactly frequency of a discrete signal
    // since the frequency can be in some point between the samples.
    var trueI = parabolic(arrayLog(fAbs), i)[0];

    // Convert to equivalent frequency
    return fs * trueI / windowed.length;
  }
}
