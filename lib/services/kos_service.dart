
import 'package:supabase_flutter/supabase_flutter.dart';

class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _uid => _client.auth.currentUser!.id;

  // Mengambil seluruh data kos
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final data = await _client
        .from('kos')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // Menambahkan data kos
  Future<void> add({
    required String name,
    required String address,
    required int price,
  }) async {
    await _client.from('kos').insert({
      'owner_id': _uid,
      'name': name,
      'address': address,
      'price': price,
    });
  }

  // Memperbarui data kos
  Future<bool> update(
    String id,
    Map<String, dynamic> values,
  ) async {
    final rows = await _client
        .from('kos')
        .update(values)
        .eq('id', id)
        .select();

    return rows.isNotEmpty;
  }

  // Menghapus data kos
  Future<bool> delete(String id) async {
    final rows = await _client
        .from('kos')
        .delete()
        .eq('id', id)
        .select();

    return rows.isNotEmpty;
  }
}
