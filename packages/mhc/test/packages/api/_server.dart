import 'dart:convert';
import 'dart:io';

import 'package:mhc/mhc.dart';

import '_entities.dart';
import '_internal.dart';

T? _findEntity<T extends HasId<int>>(Iterable<T> items, String idSegment) {
  final id = int.tryParse(idSegment);
  if (id == null) {
    return null;
  }
  final entity = ListXHasId<int, T>(items.toList()).whereIdOrNull(id);
  if (entity == null) {
    return null;
  }
  return entity;
}

Future<void> _listener(HttpRequest req) async {
  final resp = req.response;
  final method = req.method;
  final path = req.uri.path;
  final segments = req.uri.pathSegments;

  switch (segments) {
    case ['todos', final idSegment]:
      resp.headers.set(HttpHeaders.contentTypeHeader, '${ContentType.json}');
      final todo = _findEntity(todos, idSegment);
      if (todo == null) {
        resp.statusCode = 404;
        break;
      }
      resp.statusCode = 200;
      resp.write(jsonEncode(todo.toJson()));
    case ['users', final idSegment]:
      resp.headers.set(HttpHeaders.contentTypeHeader, '${ContentType.json}');
      final user = _findEntity(users, idSegment);
      if (user == null) {
        resp.statusCode = 404;
        break;
      }
      resp.statusCode = 200;
      resp.write(jsonEncode(user.toJson()));
    case ['zero']:
      break;
    case ['422']:
      resp.headers.set(HttpHeaders.contentTypeHeader, '${ContentType.json}');
      resp.statusCode = 422;
      resp.write(jsonEncode({'message': 'validation error'}));
    case ['error_string']:
      resp.headers.set(HttpHeaders.contentTypeHeader, '${ContentType.json}');
      resp.statusCode = 400;
      resp.write(jsonEncode('error1'));
    case ['error_json']:
      resp.headers.set(HttpHeaders.contentTypeHeader, '${ContentType.json}');
      resp.statusCode = 400;
      resp.write(jsonEncode({'message': 'error1'}));
  }

  await resp.close();
}

Future<HttpServer> starHttpServer() =>
    HttpServer.bind(InternetAddress.loopbackIPv4, serverPort)
        .then((server) => server..listen(_listener));

Future<HttpServer?> stopHttpServer(HttpServer? server) async =>
    server?.close(force: true).then((_) => null);
