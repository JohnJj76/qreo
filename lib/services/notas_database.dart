import 'package:qreo/models/notame.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class NotasDatabase {
  final database = Supabase.instance.client.from('notas');

  // Crear
  Future crearNota(Notame nuevaNota) async {
    await database.insert(nuevaNota.toMap());
  }

  final data = Supabase.instance.client
      .from('notas')
      .select()
      .eq('contenido', 'hola');

  // Leer
  final medida = Supabase.instance.client
      .from('notas')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((notaMap) => Notame.fromMap(notaMap)).toList());

  // editar
  Future editarNota(Notame viejaNota, String nuevaNota) async {
    await database.update({'contenido': nuevaNota}).eq('idx', viejaNota.idx!);
  }

  // Borrar
  Future borrarNota(Notame nota) async {
    await database.delete().eq('idx', nota.idx!);
  }
}
