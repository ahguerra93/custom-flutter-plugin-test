import 'package:flutter/material.dart';
import 'package:android_multiple_identifier/android_multiple_identifier.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

import 'package:simple_permissions/simple_permissions.dart';
import 'utils/encoder.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _imei = 'Unknown';
  String _serial = 'Unknown';
  String _androidID = 'Unknown';
  String _androidIDChar = '00';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String imei;
    String serial;
    String androidID;
    String androidIDChar;
    // final res = await SimplePermissions.requestPermission(Permission.ReadPhoneState);

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AndroidMultipleIdentifier.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    print(platformVersion[8]);
    if (platformVersion.contains('Android')) {
      if (int.parse(platformVersion[8]) >= 6) {
        print(platformVersion);
        final res = await SimplePermissions.requestPermission(
            Permission.ReadPhoneState);
        print("permission request result is " + res.toString());
      }
    }
    if (platformVersion.contains('iOS')) {
         print(platformVersion);
        final res = await SimplePermissions.requestPermission(
            Permission.ReadPhoneState);
        print("permission request result is " + res.toString());
    }

    try {
      imei = await AndroidMultipleIdentifier.imeiCode;
      serial = await AndroidMultipleIdentifier.serialCode;
      androidID = await AndroidMultipleIdentifier.androidID;
      androidIDChar = Encoder.fromHextoString(androidID);
    } catch (e) {
      imei = 'Failed to get IMEI.';
      serial = 'Failed to get Serial Code.';
      androidID = 'Failed to get Android id.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _imei = imei;
      _serial = serial;
      _androidID = androidID;
      _androidIDChar = androidIDChar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '\nRunning on: $_platformVersion\n',
              textAlign: TextAlign.center,
            ),
            Text('IMEI: $_imei\n'),
            Text(
              'Serial Code: $_serial\n',
              textAlign: TextAlign.center,
            ),
            Text(
              'Android ID: $_androidID\n',
              textAlign: TextAlign.center,
            ),
            // Text('IMEI in HEX:\n ${Encoder.getHexString(_imei)}\n',textAlign:TextAlign.center,),
            Text(
              'Serial Code in HEX:\n ${Encoder.getHexString(_serial)}\n\nUsual size:\n ${Encoder.getHexString("0000000000000000")}',
              textAlign: TextAlign.center,
            ),
            // Text('Android ID in STRING:\n $_androidIDChar\n',textAlign:TextAlign.center,),
          ],
        )),
      ),
    );
  }
}
