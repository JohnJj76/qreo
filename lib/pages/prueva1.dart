import 'package:flutter/material.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class Prueva1Page extends StatefulWidget {
  const Prueva1Page({super.key});

  @override
  State<Prueva1Page> createState() => _Prueva1PageState();
}

final supabase = Supabase.instance.client;

final subscription =
    supabase
        .channel('public:orionqr')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orionqr',
          callback: (payload) {
            print('Cambio detectado: ${payload.toString()}');
          },
        )
        .subscribe();

class _Prueva1PageState extends State<Prueva1Page> {
  final authService = AuthService();
  late Stream<List<Map<String, dynamic>>> _stream;
  bool band = false;
  @override
  void initState() {
    super.initState();
    _stream = Supabase.instance.client
        .from('orionqr')
        .stream(primaryKey: ['idx'])
        .eq('empleado', 'karol');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var tamma = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('pruebita'),
      ),
      body: Center(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var listOfData = snapshot.data;
            return ListView.builder(
              itemCount: listOfData!.length,
              itemBuilder: (context, index) {
                var item = listOfData[index];
                return ListTile(
                  key: Key(item['idx'].toString()),
                  title: Text(item['concepto']),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Supabase.instance.client.from('todo').insert({'name': 'hello'});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );

    /*Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: supabase
              .from('orionqr')
              .stream(primaryKey: ['idx'])
              .eq('revisado', false)
              .order('factura', ascending: true),
          builder: (context, snapshot) {
            //
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              var wqr = snapshot.data;
              return ListView.builder(
                itemCount: wqr?.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: tamma.width * 0.05,
                      vertical: tamma.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("${wqr?[index]["concepto"]}")],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );*/
  }
}
