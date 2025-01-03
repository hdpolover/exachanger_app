// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get totalResults => throw _privateConstructorUsedError;
  bool get cached => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int id,
      String type,
      int page,
      int totalPages,
      int totalResults,
      bool cached});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? page = null,
    Object? totalPages = null,
    Object? totalResults = null,
    Object? cached = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalResults: null == totalResults
          ? _value.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoviesImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$MoviesImplCopyWith(
          _$MoviesImpl value, $Res Function(_$MoviesImpl) then) =
      __$$MoviesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String type,
      int page,
      int totalPages,
      int totalResults,
      bool cached});
}

/// @nodoc
class __$$MoviesImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$MoviesImpl>
    implements _$$MoviesImplCopyWith<$Res> {
  __$$MoviesImplCopyWithImpl(
      _$MoviesImpl _value, $Res Function(_$MoviesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? page = null,
    Object? totalPages = null,
    Object? totalResults = null,
    Object? cached = null,
  }) {
    return _then(_$MoviesImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      totalResults: null == totalResults
          ? _value.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
      cached: null == cached
          ? _value.cached
          : cached // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MoviesImpl extends _Movies {
  const _$MoviesImpl(
      {this.id = Isar.autoIncrement,
      this.type = '',
      this.page = 0,
      this.totalPages = 0,
      this.totalResults = 0,
      this.cached = false})
      : super._();

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final int totalResults;
  @override
  @JsonKey()
  final bool cached;

  @override
  String toString() {
    return 'User(id: $id, type: $type, page: $page, totalPages: $totalPages, totalResults: $totalResults, cached: $cached)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoviesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults) &&
            (identical(other.cached, cached) || other.cached == cached));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, page, totalPages, totalResults, cached);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoviesImplCopyWith<_$MoviesImpl> get copyWith =>
      __$$MoviesImplCopyWithImpl<_$MoviesImpl>(this, _$identity);
}

abstract class _Movies extends User {
  const factory _Movies(
      {final int id,
      final String type,
      final int page,
      final int totalPages,
      final int totalResults,
      final bool cached}) = _$MoviesImpl;
  const _Movies._() : super._();

  @override
  int get id;
  @override
  String get type;
  @override
  int get page;
  @override
  int get totalPages;
  @override
  int get totalResults;
  @override
  bool get cached;
  @override
  @JsonKey(ignore: true)
  _$$MoviesImplCopyWith<_$MoviesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
