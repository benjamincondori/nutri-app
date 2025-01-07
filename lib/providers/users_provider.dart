import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

final usersProvider = StateNotifierProvider<UserProvider, List<User>>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<List<User>> {
  UserProvider() : super([]);

  void setUsers(List<User> users) {
    state = users;
  }

  void removeFoods() {
    state = [];
  }
  
}