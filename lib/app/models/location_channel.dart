import 'package:flutter/services.dart';

class LocationChannel{
  final MethodChannel _channel = const MethodChannel('my_app/method/location');

  Future<String?> getLocation() async{
    return await _channel.invokeMethod<String>('getNativeLocation');
  }
}