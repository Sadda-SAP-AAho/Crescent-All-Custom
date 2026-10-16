CLASS lhc_ZI_BANKRATE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
     IMPORTING REQUEST requested_authorizations
     FOR zi_bankrate RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bankrate RESULT result.

ENDCLASS.

CLASS lhc_ZI_BANKRATE IMPLEMENTATION.



  METHOD get_instance_features.

    READ ENTITIES OF zi_bankrate IN LOCAL MODE
       ENTITY zi_bankrate
          FIELDS (  Maincharges exp_imp_type )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result)
        FAILED failed.

    LOOP AT lt_result INTO DATA(ls_so).
      result = VALUE #( FOR ls_result IN lt_result
                     ( %key  = ls_result-%key

                       %field-Maincharges      = COND #(
                                                  WHEN ls_so-exp_imp_type = 'IMPORT'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled
                                                )
                        ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
