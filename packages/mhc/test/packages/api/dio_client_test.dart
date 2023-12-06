import 'dart:io';

import 'package:mhc/mhc.dart';
import 'package:test/test.dart';

import '_entities.dart';
import '_internal.dart';
import '_server.dart';

Future<void> main() async {
  HttpServer? server;

  setUpAll(() async => server = await starHttpServer());
  tearDownAll(() async => server = await stopHttpServer(server));

  group('get one', () {
    test('/todos/1, success', () async {
      final future = todosService.getTodo(1);
      expect(future, completes);
      final value = await future;
      expect(value, isA<MyServiceResult<Todo, JSON>>());
      // final result = value as MyServiceResult<Todo, JSON>;
      // expect(result.result.id, 1);
    });

    test('/todos/3, 404', () async {
      final future = todosService.getTodo(3);
      expect(future, completes);
      final value = await future;
      expect(value, isA<MyServiceError<Todo, JSON>>());
      final result = value as MyServiceError<Todo, JSON>;
      expect(result.extra.response, isNotNull);
      expect(result.extra.response!.statusCode, 404);
    });

    test('/todos/1, wrong factory', () async {
      expect(
        todosService.wrongReturnType(1),
        throwsA(
          allOf([
            isA<ClientError>(),
            predicate<ClientError>(
              (error) => error.type == ClientErrorType.middlewareError,
            ),
          ]),
        ),
      );
    });

    test('/zero', () async {
      expect(
        todosService.emptyResponse(),
        completion(isA<MyServiceResult<void, dynamic>>()),
      );
    });

    test('/422', () async {
      expect(
        todosService.validationError(),
        completion(
          allOf([
            isA<MyServiceError<void, dynamic>>(),
            predicate<MyServiceError<void, dynamic>>(
              (error) => error.error == 'validation error',
            ),
          ]),
        ),
      );
    });

    test('/error_string', () async {
      expect(
        todosService.errorString(),
        completion(
          allOf([
            isA<MyServiceError<void, dynamic>>(),
            predicate<MyServiceError<void, dynamic>>(
              (error) => error.error == 'error1',
            ),
          ]),
        ),
      );
    });

    test('/error_json', () async {
      expect(
        todosService.errorJson(),
        completion(
          allOf([
            isA<MyServiceError<void, dynamic>>(),
            predicate<MyServiceError<void, dynamic>>(
              (error) => error.error == 'error1',
            ),
          ]),
        ),
      );
    });
  });
}
