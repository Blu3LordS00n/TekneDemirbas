import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_room_provider.g.dart';

@riverpod
class SelectedRoom extends _$SelectedRoom {
  @override
  String? build() {
    return null;
  }

  void setRoom(String? roomId) {
    state = roomId;
  }

  void clear() {
    state = null;
  }
}
