import 'dart:io';

import 'package:dio/dio.dart';

extension ResponseX<T> on Response<T> {
  ContentType? get contentType {
    final value = headers[Headers.contentTypeHeader]?.firstOrNull;
    if (value != null) {
      return ContentType.parse(value);
    }
    return null;
  }
}
