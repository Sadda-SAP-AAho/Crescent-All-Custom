CLASS lhc_tmgtableforlabcatall DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR tmgtableforlabcatall RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR tmgtableforlabcatall RESULT result.

    METHODS edit FOR MODIFY
      IMPORTING keys FOR ACTION tmgtableforlabcatall~edit.

    METHODS selectcustomizingtransptreq FOR MODIFY
      IMPORTING keys FOR ACTION tmgtableforlabcatall~selectcustomizingtransptreq RESULT result.

    METHODS validatetransportrequest FOR VALIDATE ON SAVE
      IMPORTING keys FOR tmgtableforlabcatall~validatetransportrequest.

ENDCLASS.

CLASS lhc_tmgtableforlabcatall IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD edit.
  ENDMETHOD.

  METHOD selectcustomizingtransptreq.
  ENDMETHOD.

  METHOD validatetransportrequest.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_tmgtableforlabcat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR tmgtableforlabcat RESULT result.

    METHODS validatetransportrequest FOR VALIDATE ON SAVE
      IMPORTING keys FOR tmgtableforlabcat~validatetransportrequest.

ENDCLASS.

CLASS lhc_tmgtableforlabcat IMPLEMENTATION.

  METHOD get_global_features.
  ENDMETHOD.

  METHOD validatetransportrequest.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_tmgtableforlabcat_s DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_tmgtableforlabcat_s IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
