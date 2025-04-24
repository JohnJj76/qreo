class Notame {
  int? idx;
  String contenido;
  Notame({this.idx, required this.contenido});
  //
  factory Notame.fromMap(Map<String, dynamic> map) {
    return Notame(
      idx: map['idx'] as int,
      contenido: map['contenido'] as String,
    );
  }
  //
  Map<String, dynamic> toMap() {
    return {'contenido': contenido};
  }
}
