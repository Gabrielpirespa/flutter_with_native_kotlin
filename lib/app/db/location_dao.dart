import 'package:flutter_with_native_kotlin/app/models/location_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocationDao {
  // Criar primeiro para depois criar o database.
  static const String _tablename = "locationTable";
  static const String _latitude = "latitude";
  static const String _longitude = "longitude";

  static const String tableSql = "CREATE TABLE $_tablename("
      "$_latitude REAL, "
      "$_longitude REAL)";

  Future<Database> getDataBase() async { // Criado depois do task_dao pois deve referenciá-lo.
    final databasePath = await getDatabasesPath();
    final String path = join(databasePath, "location.db");
    return openDatabase(path, onCreate: (db, version) {
      db.execute(LocationDao.tableSql);
    }, version: 1);
  }

  Map <String, dynamic> toMap(LocationModel locationModel) {
    print("Convertendo Task em Map: ");
    final Map<String,
        dynamic> locationsMap = Map();
    locationsMap[_latitude] = locationModel.latitude;
    locationsMap[_longitude] = locationModel.longitude;
    print("Mapa de location $locationsMap");
    return locationsMap;
  }

  List<LocationModel> toList(List<Map<String, dynamic>> locationsMap) {
    print("Convertendo to List:");

    final List <LocationModel> locationsList = [];
    print("Coordinates List vazia $locationsList");
    for (Map<String, dynamic> line in locationsMap) {
      final LocationModel location = LocationModel(
        latitude: line[_latitude],
        longitude: line[_longitude],
      );
      locationsList.add(location);
    }
    print(" Lista de Locations preenchida $locationsList. ");
    return locationsList;
  }

  //Create

  save (LocationModel location) async{
    print("Iniciando o save: ");
    final database = await getDataBase();
    Map<String,dynamic> locationsMap = toMap(location);
    return await database.insert(_tablename, locationsMap);
  }

  //Read

  Future<List<LocationModel>> findAll() async{
    print("Acessando o findAll: ");
    final database = await getDataBase();
    final List<Map<String,dynamic>> result = await database.query(_tablename);
    print("Procurando dados no banco de dados ... encontrado: $result");
    return toList(result);
  }

  //Delete

  deleteAll() async{
    print("Deletando locations");
    final database = await getDataBase();
    return database.delete(_tablename);
  }
}