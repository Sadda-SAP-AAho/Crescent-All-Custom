CLASS lhc_zr_fgbomlist DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
     METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR fgbomlist RESULT result.

     METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR fgbomlist RESULT result.


  ENDCLASS.

CLASS lhc_zr_fgbomlist IMPLEMENTATION.

    METHOD get_global_authorizations.
    ENDMETHOD.


    METHOD get_instance_authorizations.
    ENDMETHOD.

ENDCLASS.
