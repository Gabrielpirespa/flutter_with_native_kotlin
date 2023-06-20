import 'package:flutter/material.dart';

import '../models/location_model.dart';

class LocationCard extends StatelessWidget {
  final LocationModel? location;
  final int? index;

  const LocationCard({
    Key? key,
    required this.location,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: mediaQuery.height * 0.095,
        decoration: BoxDecoration(
            boxShadow: kElevationToShadow[3],
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (index != null)
                ? Text(
                    "Localização $index",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text("Localização",
                    style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text.rich(
                    TextSpan(
                        text: "Latitude",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: ": ${location?.latitude}", style: const TextStyle(fontWeight: FontWeight.normal)),
                        ]),
                  ),
                  Text.rich(
                    TextSpan(
                        text: "Longitude",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: ": ${location?.longitude}", style: const TextStyle(fontWeight: FontWeight.normal)),
                        ]),
                  ),
                  // Text("Longitude: ${location?.longitude}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
