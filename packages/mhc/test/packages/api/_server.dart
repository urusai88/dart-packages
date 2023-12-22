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
  final entity = items.toList().firstWhereOrNull((e) => e.id == id);
  if (entity == null) {
    return null;
  }
  return entity;
}

void _writeJson(HttpResponse response, dynamic data) {
  response.headers.contentType = ContentType.json;
  if (data != null) {
    response.statusCode = HttpStatus.ok;
    response.write(jsonEncode(data));
  } else {
    response.statusCode = HttpStatus.notFound;
  }
}

Future<void> _listener(HttpRequest req) async {
  final response = req.response;
  final method = req.method;
  final path = req.uri.path;
  final segments = req.uri.pathSegments;

  switch (segments) {
    case ['todos', final idSegment]:
      _writeJson(response, _findEntity(todos, idSegment));
    case ['todos']:
      _writeJson(response, todos.map((e) => e.toJson()).toList());
    case ['users', final idSegment]:
      _writeJson(response, _findEntity(users, idSegment));
    case ['bytes']:
      response.headers.contentType = ContentType.binary;
      response.write(jsonEncode(todos.map((e) => e.toJson()).toList()));
  }

  await response.close();
}

Future<HttpServer> starHttpServer() =>
    HttpServer.bind(InternetAddress.loopbackIPv4, serverPort)
        .then((server) => server..listen(_listener));

Future<HttpServer?> stopHttpServer(HttpServer? server) async =>
    server?.close(force: true).then((_) => null);
