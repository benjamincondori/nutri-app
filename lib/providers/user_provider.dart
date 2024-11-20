import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/models/user.dart';

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);

  void setUser(User user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }
}
