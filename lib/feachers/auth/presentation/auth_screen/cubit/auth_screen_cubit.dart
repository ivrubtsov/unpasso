import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

part 'auth_screen_state.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  AuthScreenCubit({
    required AuthRepo authRepo,
    required SessionRepo sessionRepo,
  })  : _authRepo = authRepo,
        _sessionRepo = sessionRepo,
        super(AuthScreenInitial());

  final AuthRepo _authRepo;
  final SessionRepo _sessionRepo;
}
