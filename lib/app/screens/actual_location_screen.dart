import 'package:flutter/material.dart';
import 'package:flutter_with_native_kotlin/app/components/location_card.dart';
import 'package:flutter_with_native_kotlin/app/provider/locations_provider.dart';
import 'package:provider/provider.dart';
import 'package:refreshable_widget/refreshable_widget.dart';
import '../models/location_model.dart';

class ActualLocationScreen extends StatefulWidget {
  const ActualLocationScreen({Key? key}) : super(key: key);

  @override
  State<ActualLocationScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<ActualLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationsProvider>(builder:
        (BuildContext context, LocationsProvider provider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Localização atual",
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RefreshableWidget<LocationModel?>(
                builder: (context, value) {
                  return LocationCard(location: value);
                },
                refreshCall: () {
                  print("provider chamado");
                  return provider.getLocation();
                },
                refreshRate: const Duration(seconds: 6),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'list');
                  },
                  child: const Text(
                    "Monitorar a rota",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
