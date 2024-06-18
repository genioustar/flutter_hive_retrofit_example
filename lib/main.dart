import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fastcam_flutter_todo/api/api_service.dart';
import 'package:fastcam_flutter_todo/data/todo_repository.dart';
import 'package:fastcam_flutter_todo/model/todo.dart';
import 'package:fastcam_flutter_todo/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todoBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TodoScreen(
        todoRepository: TodoRepository(
          ApiService(Dio(),
              baseUrl: Platform.isAndroid
                  ? 'http://10.0.2.2:3000'
                  : 'http://localhost:3000'),
          Hive.box<Todo>('todoBox'),
        ),
      ),
    );
  }
}
