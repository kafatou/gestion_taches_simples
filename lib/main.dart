import 'package:flutter/material.dart';
import 'package:gestion_taches/app.dart';
import 'package:gestion_taches/features/tasks/providers/task_provider.dart';
import 'package:gestion_taches/hive_registrar.g.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapters();

  runApp(
    MultiProvider( 
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
