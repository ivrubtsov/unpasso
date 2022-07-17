import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required SessionRepo sessionRepo})
      : _sessionRepo = sessionRepo,
        super(AuthState.initial());

  final SessionRepo _sessionRepo;

  Future<void> checkAuth() async {
    await _sessionRepo.removeSessionData();
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _sessionRepo.getSessionData();

      emit(state.copyWith(status: AuthStatus.logIn));
    } on SessionDataException {
      emit(state.copyWith(status: AuthStatus.logOut));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.logOut));
    }
  }
}
