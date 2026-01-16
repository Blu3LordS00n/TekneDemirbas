import 'package:flutter/material.dart';

enum TaskSortType { none }

class TaskFilter {
  final String? boatType;
  final String? taskType;
  final DateTimeRange? dateRange;

  final TaskSortType sortType;

  const TaskFilter({
    this.boatType,
    this.taskType,
    this.dateRange,
    this.sortType = TaskSortType.none,
  });

  TaskFilter copyWith({
    Object? boatType = _undefined,
    Object? taskType = _undefined,
    Object? dateRange = _undefined,
    TaskSortType? sortType,
  }) {
    return TaskFilter(
      boatType: boatType == _undefined ? this.boatType : boatType as String?,
      taskType: taskType == _undefined ? this.taskType : taskType as String?,
      dateRange: dateRange == _undefined ? this.dateRange : dateRange as DateTimeRange?,
      sortType: sortType ?? this.sortType,
    );
  }
  
  static const _undefined = Object();

  static const empty = TaskFilter();
}
