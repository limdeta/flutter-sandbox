/// Base class for all failures in the domain layer
abstract class Failure {
  final String message;
  
  const Failure(this.message);
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  String toString() => 'Failure(message: $message)';
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class EntityCreationFailure extends Failure {
  const EntityCreationFailure(super.message);
}

class EntityUpdateFailure extends Failure {
  const EntityUpdateFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}