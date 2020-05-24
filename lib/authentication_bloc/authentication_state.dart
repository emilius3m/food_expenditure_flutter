part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String displayName;
  final String uid;

  const Authenticated(this.displayName,this.uid);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'Authenticated { user_auth: $displayName $uid }';
}

class Unauthenticated extends AuthenticationState {}
