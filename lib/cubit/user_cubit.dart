import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  int selectedIndex = 0;

  changeIndex(x) {
    selectedIndex = x;
  }
}
