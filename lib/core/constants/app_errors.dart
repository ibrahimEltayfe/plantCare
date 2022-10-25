class AppErrors{
  static const String unKnownError = 'something went wrong, please try again.';
}

class AppLocalDatabaseErrors{
  static const isDatabaseClosedError = 'Database is closed';
  static const isDuplicateColumnError = 'Duplicate column error';
  static const isNoSuchTableError = 'Data table is not found';
  static const isNotNullConstraintError = 'The value can not be empty';
  static const isOpenFailedError = 'Database open failed';
  static const isReadOnlyError = 'Database is read-only';
  static const isSyntaxError = 'Syntax error';
  static const isUniqueConstraintError = 'Data-type error';
  static const unKnown = 'database error, please try again later';
}