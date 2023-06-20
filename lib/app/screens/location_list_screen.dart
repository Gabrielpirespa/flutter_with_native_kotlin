import 'package:flutter/material.dart';
import 'package:flutter_with_native_kotlin/app/components/loading.dart';
import 'package:flutter_with_native_kotlin/app/models/location_model.dart';
import 'package:flutter_with_native_kotlin/app/provider/locations_provider.dart';
import 'package:provider/provider.dart';
import '../components/location_card.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({Key? key}) : super(key: key);

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationsProvider>(
      builder:
          (BuildContext context, LocationsProvider provider, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext alertContext) =>
                          AlertDialog(
                              title: const Text("Apagando coordenadas", style: TextStyle(fontWeight: FontWeight.bold),),
                              content: const Text(
                                  "Tem certeza que deseja remover todas as coordenadas?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    provider.deleteAllFromDatabase();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          "Coordenadas apagadas com sucesso", textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                    Navigator.pop(alertContext, "Sim");
                                  },
                                  child: const Text(
                                    "Sim",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                          alertContext, "Não"),
                                  child: const Text(
                                    "Não",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent
                                    ),
                                  ),
                                )
                              ]),
                    );
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
              centerTitle: true,
              title: const Text("Localizações percorridas"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<LocationsProvider>(builder: (BuildContext context,
                  LocationsProvider provider, Widget? child) {
                return StreamBuilder<List<LocationModel>>(
                    stream: provider.readFromDatabase(),
                    builder: (context, snapshot) {
                      var items = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          {
                            return const Loading();
                          }
                        case ConnectionState.waiting:
                          {
                            return const Loading();
                          }
                        case ConnectionState.active:
                          {
                            return const Loading();
                          }
                        case ConnectionState.done:
                          {
                            if (snapshot.hasData && items != null) {
                              return ListView.builder(
                                key: const PageStorageKey<String>('page'),
                                  itemCount: items.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return LocationCard(
                                      location: items[index],
                                      index: index,
                                    );
                                  });
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.error_outline,
                                      size: 128,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Não há nenhuma localização.",
                                      style: TextStyle(
                                        fontSize: 32,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          }
                      }
                    });
              }),
            ));
      },
    );
  }
}
