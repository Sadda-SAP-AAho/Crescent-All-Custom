CLASS lhc_ZR_appauthotp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

   METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
   IMPORTING keys REQUEST requested_authorizations FOR ZR_appauthotp RESULT result.
   METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
     IMPORTING REQUEST requested_authorizations FOR zr_appauthotp RESULT result.

   METHODS app_name FOR DETERMINE ON SAVE
     IMPORTING keys FOR zr_appauthotp~app_name.

*   METHODS edit FOR MODIFY
*   IMPORTING keys FOR ACTION ZR_appauthotp~edit.

ENDCLASS.

CLASS lhc_ZR_appauthotp IMPLEMENTATION.

   METHOD get_instance_authorizations.

   ENDMETHOD.

* METHOD edit.
* ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD app_name.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_APPAUTHOTP DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_APPAUTHOTP IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
