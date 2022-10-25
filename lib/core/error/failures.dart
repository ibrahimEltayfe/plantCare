abstract class Failure{
  final String message;
  Failure(this.message);
}

class LocalDatabaseFailure extends Failure{
  LocalDatabaseFailure(super.message);
}

class UnKnownFailure extends Failure{
  UnKnownFailure(super.message);
}
