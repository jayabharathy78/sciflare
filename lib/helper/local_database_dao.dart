import 'package:sciflare/helper/database.dart';
import 'package:sciflare/student_obj.dart';
import 'package:sembast/sembast.dart';

class LocalDatabaseDao {
  final _studentPrefFolder =
  intMapStoreFactory.store("studentPrefFolder");

  Future<Database> get _db async => await AppDatabase.instance.database;

  ///// INSERT BEGIN
  Future insertStudentList(List<StudentObj> value,
      [bool reset = true]) async {
      for (var element in value){
        _studentPrefFolder.add(await _db, element.toJson());
      }
  }

///// INSERT END
//
  ///// SELECT BEGIN
  Future<List<StudentObj>> getStudentFromLocal() async {
// Using a regular expression matching the exact word (no case)

    var recordSnapshot = await _studentPrefFolder.find(await _db);
    var recordList = recordSnapshot.map((snapshot) {
      // print(snapshot.value);
      final data = StudentObj.fromJson(snapshot.value);
      return data;
    }).toList();
    return recordList;
  }

///// SELECT END
//
  ///// DELETE BEGIN
  Future<int> deleteStudent() async =>
      await _studentPrefFolder.delete(await _db);
///// DELETE END
}