import 'dart:developer';
import 'package:plants_care/features/home/data/models/plant_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSource();
});

class LocalDataSource{
  final String  _dbName = 'plants_database';
  final String _plantsTable = 'plants';

  late Database database;

  openDB() async{
     database = await openDatabase(
          _dbName,
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
              'CREATE TABLE $_plantsTable (id INTEGER PRIMARY KEY, plantName TEXT, waterTime INTEGER)'
             );

            log("Database created : ${db.path}");
         },
         onOpen: (db){
            log("Database opened : ${db.path}");
         }
       );
  }

  Future<int> deleteRecord(String id) async{
    return await database.rawDelete(
        'DELETE FROM $_plantsTable WHERE id = ?',
        [id]
    );
  }

  Future<List<Map<String,dynamic>>> getAllRecords() async{
    List<Map<String,dynamic>> list = await database.rawQuery('SELECT * FROM $_plantsTable');
    log(list.toString());
    return list;
  }

  Future<int> updateDB(PlantModel plantModel) async{
    return await database.rawUpdate(
        'UPDATE $_plantsTable SET id = ?, plantName = ? WHERE waterTime = ?',
        [
          plantModel.id,
          plantModel.plantName,
          plantModel.waterTime
        ]);

  }

  Future<int> insertToDB(PlantModel plantModel) async{
    return await database.insert(_plantsTable, plantModel.toMap());
  }

  Future deleteDB() async{
    var databasesPath = await getDatabasesPath();
    await deleteDatabase("$databasesPath/$_dbName");
  }

}
