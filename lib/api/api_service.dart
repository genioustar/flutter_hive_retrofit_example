import 'package:dio/dio.dart';
import 'package:fastcam_flutter_todo/model/todo.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'http://localhost:3000')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/todo')
  Future<List<Todo>> getTodos();

  @POST('/todo')
  Future<Todo> createTodo(@Body() Todo todo);

  @PATCH('/todo/{id}')
  Future<Todo> updateTodo(@Path('id') String id);
}
