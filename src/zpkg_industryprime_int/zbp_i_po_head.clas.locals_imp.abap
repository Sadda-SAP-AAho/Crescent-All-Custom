CLASS lhc_zi_po_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_po_head RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_po_head.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_po_head.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_po_head.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_po_head RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_po_head.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ zi_po_head\_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE zi_po_head\_item.

ENDCLASS.

CLASS lhc_zi_po_head IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA: gs_head TYPE zdt_po_head.

    DATA(ls_entity) = VALUE #( entities[ 1 ] OPTIONAL ).
    gs_head = CORRESPONDING #( ls_entity ).
    gs_head-createdon = sy-datum.
    gs_head-createdat = sy-timlo.
    MODIFY zdt_po_head FROM @gs_head.

  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_item.
  ENDMETHOD.

  METHOD cba_item.
    DATA: gs_item TYPE zdt_po_item.
    DATA: l_item  TYPE int4.
    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<lfs_cba>).
      LOOP AT <lfs_cba>-%target ASSIGNING FIELD-SYMBOL(<lfs_cba_target>).
        l_item = l_item + 10.
        gs_item = CORRESPONDING #( <lfs_cba_target> ).
        gs_item-itemuuid = l_item.
        gs_item-createdon = sy-datum.
        gs_item-createdat = sy-timlo.
        MODIFY zdt_po_item FROM @gs_item.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_po_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_po_item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_po_item.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_po_item RESULT result.

    METHODS rba_head FOR READ
      IMPORTING keys_rba FOR READ zi_po_item\_head FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_po_item IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_head.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_po_head DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_po_head IMPLEMENTATION.

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
