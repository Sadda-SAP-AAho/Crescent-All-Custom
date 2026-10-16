CLASS LHC_ZR_SCHDR DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrSchdr
        RESULT result.

      METHODS ClearError FOR MODIFY
      IMPORTING keys FOR ACTION ZrSchdr~ClearError RESULT result.

ENDCLASS.

CLASS LHC_ZR_SCHDR IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.


  METHOD clearerror.


    MODIFY ENTITIES OF zr_schdr IN LOCAL MODE
      ENTITY ZrSchdr
      UPDATE FIELDS ( ErrorLog )
      WITH VALUE #( FOR ls_concre IN keys ( %tky = ls_concre-%tky ErrorLog = '' ) )
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).


    APPEND VALUE #(
                   %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-success
                     text = | Error Cleared | )
                     ) TO reported-ZrSchdr.

    READ ENTITIES OF zr_schdr IN LOCAL MODE
    ENTITY ZrSchdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gateentryheaders).

    result = VALUE #( FOR gateentryheader IN gateentryheaders
                        ( %tky   = gateentryheader-%tky
                          %param = gateentryheader ) ).

  ENDMETHOD.
ENDCLASS.
