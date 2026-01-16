import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/task_filter.dart';

part 'task_filter_provider.g.dart';

@riverpod
class TaskFilterController extends _$TaskFilterController {
  @override
  TaskFilter build() {
    return TaskFilter.empty;
  }

  void setBoat(String? boat) {
    // null veya boş string ise null set et, aksi halde değeri set et
    final boatValue = (boat == null || boat.isEmpty) ? null : boat;
    state = state.copyWith(boatType: boatValue);
  }

  void setTaskType(String? type) {
    // null veya boş string ise null set et, aksi halde değeri set et
    final taskValue = (type == null || type.isEmpty) ? null : type;
    state = state.copyWith(taskType: taskValue);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void setSort(TaskSortType sort) {
    state = state.copyWith(sortType: sort);
  }

  void clear() {
    state = TaskFilter.empty;
  }
}

// All Tasks için ayrı filter
@riverpod
class AllTasksFilterController extends _$AllTasksFilterController {
  @override
  TaskFilter build() {
    return TaskFilter.empty;
  }

  void setBoat(String? boat) {
    final boatValue = (boat == null || boat.isEmpty) ? null : boat;
    state = state.copyWith(boatType: boatValue);
  }

  void setTaskType(String? type) {
    final taskValue = (type == null || type.isEmpty) ? null : type;
    state = state.copyWith(taskType: taskValue);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void setSort(TaskSortType sort) {
    state = state.copyWith(sortType: sort);
  }

  void clear() {
    state = TaskFilter.empty;
  }
}

// Completed Tasks için ayrı filter
@riverpod
class CompletedTasksFilterController extends _$CompletedTasksFilterController {
  @override
  TaskFilter build() {
    return TaskFilter.empty;
  }

  void setBoat(String? boat) {
    final boatValue = (boat == null || boat.isEmpty) ? null : boat;
    state = state.copyWith(boatType: boatValue);
  }

  void setTaskType(String? type) {
    final taskValue = (type == null || type.isEmpty) ? null : type;
    state = state.copyWith(taskType: taskValue);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void setSort(TaskSortType sort) {
    state = state.copyWith(sortType: sort);
  }

  void clear() {
    state = TaskFilter.empty;
  }
}

// Incompleted Tasks için ayrı filter
@riverpod
class IncompletedTasksFilterController extends _$IncompletedTasksFilterController {
  @override
  TaskFilter build() {
    return TaskFilter.empty;
  }

  void setBoat(String? boat) {
    final boatValue = (boat == null || boat.isEmpty) ? null : boat;
    state = state.copyWith(boatType: boatValue);
  }

  void setTaskType(String? type) {
    final taskValue = (type == null || type.isEmpty) ? null : type;
    state = state.copyWith(taskType: taskValue);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void setSort(TaskSortType sort) {
    state = state.copyWith(sortType: sort);
  }

  void clear() {
    state = TaskFilter.empty;
  }
}
