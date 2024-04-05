import 'package:isar/isar.dart';

part 'evento.g.dart';

@collection
class Evento{
    Id id = Isar.autoIncrement;
    String title = "";
    String fecha = "";
    String descripcion = "";
    String urlfoto = "";
    String urlaudio = ""; 
}