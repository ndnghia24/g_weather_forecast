import 'package:localstore/localstore.dart';

class MyLocalStore {
  final _db = Localstore.instance;

  Future<void> saveData(String key, dynamic value) async {
    final docRef = _db.collection('data').doc(key);
    await docRef.set({'value': value});
  }

  Future<dynamic> getData(String key) async {
    final docRef = _db.collection('data').doc(key);
    final doc = await docRef.get();
    return doc?['value'];
  }
}
