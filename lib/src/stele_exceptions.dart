class MissingDomainNameExcepetion implements Exception {
  String cause;
  MissingDomainNameExcepetion(this.cause);
}

class UnknowDomainNameExcepetion implements Exception {
  String cause;
  UnknowDomainNameExcepetion(this.cause);
}

class InvalidAccessTokenException implements Exception {
  String cause;
  InvalidAccessTokenException(this.cause);
}

class MissingTimelineException implements Exception {
  String cause;
  MissingTimelineException(this.cause);
}

class AuthorizationException implements Exception {
  String cause;

  AuthorizationException(this.cause);
}
