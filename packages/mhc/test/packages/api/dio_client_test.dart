import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';

import '_entities.dart';
import '_internal.dart';
import '_server.dart';

Future<void> main() async {
  HttpServer? server;

  setUpAll(() async => server = await starHttpServer());
  tearDownAll(() async => server = await stopHttpServer(server));

  group(
    'one json',
    () {
      test(
        '/todos/1, success',
        () => expect(
          todosService.todo(1),
          completion(
            isA<MyServiceResult<Todo>>().having(
              (r) => r.result,
              'result',
              todos.where((e) => e.id == 1),
            ),
          ),
        ),
      );

      test('/todos/3, failure 404', () async {
        expect(
          todosService.todo(3),
          completion(
            isA<MyServiceError<Todo>>()
                .having((e) => e.extra.response, 'response', isNotNull)
                .having(
                  (e) => e.extra.response?.statusCode,
                  'statusCode',
                  HttpStatus.notFound,
                ),
          ),
        );
      });
    },
  );

  group('many json', () {
    test(
      '/todos, success',
      () => expect(
        todosService.todos(),
        completion(
          isA<MyServiceResult<List<Todo>>>()
              .having((r) => r.result, 'result', unorderedMatches(todos)),
        ),
      ),
    );
  });

  group('bytes', () {
    test(
      'bytes success',
      () => expect(
        todosService.bytes(),
        completion(
          isA<MyServiceResult<Uint8List>>()
              .having((resp) => resp.result, 'bytes length', isNotEmpty),
        ),
      ),
    );
  });

  group('zero', () {
    test(
      'zero success',
      () =>
          expect(todosService.zero(), completion(isA<MyServiceResult<void>>())),
    );
  });
}
