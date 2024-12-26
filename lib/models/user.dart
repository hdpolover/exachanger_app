import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class User with _$User {
  const User._();
  @JsonSerializable(explicitToJson: true)
  const factory User({
    @Default(Isar.autoIncrement) int id,
    @Default('') String type,
    @Default(0) int page,
    @Default(0) int totalPages,
    @Default(0) int totalResults,
    @Default(false) bool cached,
  }) = _Movies;

  @override
  Id get id;
}
