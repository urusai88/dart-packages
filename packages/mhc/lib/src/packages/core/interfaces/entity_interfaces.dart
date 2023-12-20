import '../../../../mhc.dart';

abstract interface class HasId<T> {
  T get id;
}

abstract interface class HasName<T> {
  T get name;
}

abstract interface class HasCreatedAt {
  DateTime get createdAt;
}

abstract interface class JSONSerializable {
  JSON toJson();
}
