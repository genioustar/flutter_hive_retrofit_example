import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable() // fromJson, toJson을 만들어주는 어노테이션
@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  @JsonKey(name: '_id') // 서버에서 받아오는 이름과 다를 경우 사용
  String id;
  @HiveField(1)
  String text;
  @HiveField(2)
  bool done;

  Todo({
    required this.id,
    required this.text,
    this.done = false,
  });

  // JSON 데이터를 Todo 객체로 변환하는 팩토리 생성자
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  // Todo 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
