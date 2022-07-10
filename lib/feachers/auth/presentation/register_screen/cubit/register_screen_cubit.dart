import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repos/auth_repo.dart';
import '../../../domain/repos/session_repo.dart';

part 'register_screen_state.dart';

class RegisterScreenCubit extends Cubit<RegisterScreenState> {
  RegisterScreenCubit({
    required AuthRepo authRepo,
    required SessionRepo sessionRepo,
  })  : _authRepo = authRepo,
        _sessionRepo = sessionRepo,
        super(RegisterScreenState.initial());

  final AuthRepo _authRepo;
  final SessionRepo _sessionRepo;
}
