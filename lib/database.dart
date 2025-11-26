import 'package:drift/drift.dart';

import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Routes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get startLocation => text()();
  TextColumn get destLocation => text()();
}

@DriftDatabase(tables: [Routes])
class AppDatabase extends _$AppDatabase {
  // Singleton instance for the db
  static AppDatabase? instance;
  AppDatabase._() : super(_openConnection());

  factory AppDatabase() {
    instance ??= AppDatabase._();
    return instance!;
  }

  @override
  int get schemaVersion => 1;

  Future<int> addRoute(String start, String dest) async {
    try {
      return await into(routes).insert(
        RoutesCompanion(startLocation: Value(start), destLocation: Value(dest)),
      );
    } catch (e) {
      debugPrint('Error adding route: $e');
      rethrow;
    }
  }

  Future<List<Route>> getAllRoutes() {
    try {
      return select(routes).get();
    } catch (e) {
      debugPrint('Error getting all routes: $e');
      return Future.value([]);
    }
  }

  Future<List<Route>> getRecentRoutes() async {
    try {
      return await (select(
        routes,
      )..orderBy([(t) => OrderingTerm.desc(t.id)])).get();
    } catch (e) {
      debugPrint('Error getting recent routes: $e');
      return [];
    }
  }

  Stream<List<Route>> watchRecentRoutes() {
    try {
      return (select(
        routes,
      )..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();
    } catch (e) {
      debugPrint('Error watching recent routes: $e');
      return Stream.value([]);
    }
  }

  Future<int> deleteAllRoutes() {
    try {
      return delete(routes).go();
    } catch (e) {
      debugPrint('Error deleting routes: $e');
      rethrow;
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
