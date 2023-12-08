import 'package:equatable/equatable.dart';
import 'package:mhc/mhc.dart';

class User with EquatableMixin implements HasId<int>, HasName<String> {
  const User({required this.id, required this.name});

  User.fromJson(JSON json)
      : id = json['id'] as int,
        name = json['name'] as String;

  @override
  final int id;
  @override
  final String name;

  JSON toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class Todo with EquatableMixin implements HasId<int> {
  const Todo({
    required this.id,
    required this.userId,
  });

  Todo.fromJson(JSON json)
      : id = json['id'] as int,
        userId = json['userId'] as int;

  @override
  final int id;
  final int userId;

  JSON toJson() => {'id': id, 'userId': userId};

  @override
  List<Object?> get props => [id, userId];
}

const users = <User>[
  User(id: 1, name: 'Frank'),
  User(id: 2, name: 'Marie'),
];

const todos = <Todo>[
  Todo(id: 1, userId: 2),
  Todo(id: 2, userId: 1),
];
