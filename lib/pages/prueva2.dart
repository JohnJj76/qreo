import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Prueva2Page extends StatefulWidget {
  @override
  _Prueva2PageState createState() => _Prueva2PageState();
}

class _Prueva2PageState extends State<Prueva2Page> {
  final _nuevasTareasController =
      StreamController<Map<String, dynamic>>.broadcast();
  late RealtimeChannel _canal;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _escucharNuevasTareas();
  }

  void _escucharNuevasTareas() {
    _canal =
        _supabase
            .channel('public:orionqr')
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'orionqr',
              callback: (payload) {
                final nuevaTarea = payload.newRecord;
                _nuevasTareasController.add(nuevaTarea);
              },
            )
            .subscribe();
  }

  @override
  void dispose() {
    _nuevasTareasController.close();
    _supabase.removeChannel(_canal);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevas tareas en tiempo real')),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _nuevasTareasController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Esperando nuevas tareas...'));
          }

          final tarea = snapshot.data!;
          return ListTile(
            title: Text(tarea['concepto'] ?? 'Sin título'),
            subtitle: Text('ID: ${tarea['idx']}'),
          );
        },
      ),
    );
  }
}
