import 'dart:developer';

import 'package:plants_care/core/error/failures.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_errors.dart';

class ExceptionHandler implements Exception{
  late final Failure failure;

  ExceptionHandler.handle(dynamic error){
    if(error is DatabaseException){
      failure = LocalDatabaseFailure(_getLocalDatabaseError(error));
    }else{
      failure = UnKnownFailure(AppErrors.unKnownError);
    }
  }

  String _getLocalDatabaseError(DatabaseException e){
    if(e.isDatabaseClosedError()){
      return AppLocalDatabaseErrors.isDatabaseClosedError;
    }else if(e.isDuplicateColumnError()){
      return AppLocalDatabaseErrors.isDuplicateColumnError;

    }else if(e.isNoSuchTableError()){
      return AppLocalDatabaseErrors.isNoSuchTableError;

    }else if(e.isNotNullConstraintError()){
      return AppLocalDatabaseErrors.isNotNullConstraintError;

    }else if(e.isOpenFailedError()){
      return AppLocalDatabaseErrors.isOpenFailedError;

    }else if(e.isReadOnlyError()){
      return AppLocalDatabaseErrors.isReadOnlyError;

    }else if(e.isSyntaxError()){
      return AppLocalDatabaseErrors.isSyntaxError;

    }else if(e.isUniqueConstraintError()){
      return AppLocalDatabaseErrors.isUniqueConstraintError;
    }else{
      return AppLocalDatabaseErrors.unKnown;
    }
}
}