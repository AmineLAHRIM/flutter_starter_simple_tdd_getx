import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_starter/core/error/errors.dart';

part 'loading_state.freezed.dart';

@freezed
abstract class LoadingState with _$LoadingState {
  const factory LoadingState.loading() = LOADING;

  const factory LoadingState.empty() = EMPTY;

  const factory LoadingState.error({String? message, MessageType? type}) = ERROR;

  const factory LoadingState.loaded() = LOADED;
}
