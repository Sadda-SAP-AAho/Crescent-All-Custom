CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.
    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~headerdetails.
    METHODS amendment FOR MODIFY
      IMPORTING keys FOR ACTION head~amendment.

    METHODS setout FOR MODIFY
      IMPORTING keys FOR ACTION head~setout RESULT result.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD headerdetails.
   READ ENTITIES OF zi_lchead IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    FAILED DATA(lt_header_failed).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

    SELECT single * from zcds_po_details
    where PurchaseOrder = @<lfs_header>-po
    INto @data(ls_po_det).
    if sy-subrc = 0.
    <lfs_header>-ekorg = ls_po_det-PurchasingOrganization.
    <lfs_header>-Lifnr = ls_po_det-Supplier.
     <lfs_header>-Div = ls_po_det-Plantname.
     <lfs_header>-Vendor_Name = ls_po_det-SupplierFullName.
    endif.
    if <lfs_header>-Lc_Req_Date is INITIAL.
    <lfs_header>-Lc_Req_Date = sy-datum.
    endif.
    SELECT SINGLE max( lc_refnr ) from zdt_lchead
    into @data(lv_lcref).

    <lfs_header>-Lc_Refnr = lv_lcref + 1.
     <lfs_header>-Version = '1'.

      MODIFY ENTITIES OF zi_lchead IN LOCAL MODE
          ENTITY head
          UPDATE
              FIELDS ( Lc_Refnr status version ekorg lifnr Div Vendor_Name Lc_Req_Date )
              WITH VALUE #(
                             ( %tky   = <lfs_header>-%tky
                              Lc_Refnr = <lfs_header>-Lc_Refnr
                              status   = 'Created'
                              Version = <lfs_header>-Version
                               ekorg  =  <lfs_header>-ekorg
                               lifnr  = <lfs_header>-lifnr
                               Div    = <lfs_header>-Div
                               Vendor_Name = <lfs_header>-Vendor_Name
                               Lc_Req_Date = <lfs_header>-Lc_Req_Date

                                 %control-Lc_Refnr            = if_abap_behv=>mk-on
                                 %control-status            = if_abap_behv=>mk-on
                                 %control-Version      = if_abap_behv=>mk-on
                                 %control-Ekorg         = if_abap_behv=>mk-on
                                 %control-Lifnr        = if_abap_behv=>mk-on
                                 %control-Div              = if_abap_behv=>mk-on
                                 %control-Vendor_Name             = if_abap_behv=>mk-on
                                 %control-lc_req_date             = if_abap_behv=>mk-on
                             ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD Amendment.
  ENDMETHOD.

  METHOD SetOut.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_LCHEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_LCHEAD IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
