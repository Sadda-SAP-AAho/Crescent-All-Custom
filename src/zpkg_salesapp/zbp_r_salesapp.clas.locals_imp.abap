CLASS lhc_zr_salesapp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_salesapp RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zr_salesapp.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zr_salesapp.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zr_salesapp.

    METHODS read FOR READ
      IMPORTING keys FOR READ zr_salesapp RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zr_salesapp.

ENDCLASS.

CLASS lhc_zr_salesapp IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA ls_head TYPE zdt_salesapp.

    DATA(lt_entities) = entities.
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs>).
      ls_head = CORRESPONDING #( <fs> ).

      TRY.
          FINAL(lv_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      ls_head-id = lv_id.
      MODIFY zdt_salesapp FROM @ls_head.
    ENDLOOP.

  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_salesapp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zr_salesapp IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
