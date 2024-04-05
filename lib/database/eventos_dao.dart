

import 'package:app8/database/isar_helper.dart';
import 'package:app8/models/evento.dart';
import 'package:isar/isar.dart';

class EventoDao {
  final isar = IsarHelper.instance.isar;


  Future<List<Evento>> getall() async {
    return isar.eventos.where().findAll();
  }

  Future<bool> deleteOne(Evento evento) async {
    return isar.writeTxn(() => isar.eventos.delete(evento.id));
  }

  Future<int> deleteAll(List<int> ids) async {
    return isar.writeTxn(() => isar.eventos.deleteAll(ids));
  }

  Future<int> upsert(Evento evento) async {
    return isar.writeTxn(() => isar.eventos.put(evento));
  }

}