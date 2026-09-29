import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  Future<Set<String>> likedIds() async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList('liked_ids') ?? const <String>[]).toSet();
  }
  Future<void> setLiked(String id, bool value) async {
    final p = await SharedPreferences.getInstance();
    final ids = (p.getStringList('liked_ids') ?? <String>[]).toSet();
    value ? ids.add(id) : ids.remove(id);
    await p.setStringList('liked_ids', ids.toList());
  }
  Future<void> saveQueue(List<String> ids) async {
    final p = await SharedPreferences.getInstance();
    await p.setStringList('queue', ids);
  }
  Future<List<String>> queue() async {
    final p = await SharedPreferences.getInstance();
    return p.getStringList('queue') ?? [];
  }
}
