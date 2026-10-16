CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.
    METHODS amendment FOR MODIFY
      IMPORTING keys FOR ACTION head~amendment .
    METHODS determinebgrefno FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~determinebgrefno.
    METHODS setout FOR MODIFY
      IMPORTING keys FOR ACTION head~setout RESULT result.
    METHODS determainebgamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~determainebgamt.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD Amendment.
    DATA:
       position     TYPE TABLE FOR CREATE zi_bgheader\\head.
    DATA: lt_bghead TYPE TABLE FOR CREATE zi_bgheader.

    READ ENTITIES OF zi_bgheader IN LOCAL MODE
      ENTITY head
       ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(header)
    FAILED failed.

    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_header>).
      APPEND VALUE #( %cid = keys[ KEY entity %key = <fs_header>-%key ]-%cid
                        %is_draft = keys[ KEY entity %key = <fs_header>-%key ]-%param-%is_draft
                        %data = CORRESPONDING #( <fs_header> EXCEPT id ) )  TO lt_bghead ASSIGNING FIELD-SYMBOL(<lfs_newStudent>).
*      APPEND VALUE #( %cid     = keys[ 1 ]-%cid_ref
*                       %is_draft = '01'
*                      %data    = CORRESPONDING #( <fs_header> EXCEPT id ) )
*        TO position ASSIGNING FIELD-SYMBOL(<new_head>).

      <lfs_newStudent>-Locallastchangedat    = cl_abap_context_info=>get_system_date( ) + 30.
      <lfs_newStudent>-Version = <lfs_newStudent>-Version + 1 .
*      <new_head>-Id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
    ENDLOOP.

    MODIFY ENTITIES OF zi_bgheader IN LOCAL MODE
      ENTITY head
        CREATE FIELDS (
*         zeximbgrefno
*        version
*  bukrs
*  butxt
*  street
*  city
*  state
*  postcode
*  country
*  bgstat
*  bgcharacter
*  hbkid
*  hktid
*  bankl
*  bgbenfname
*  bankaddr
*  brnch
*  bezei
*  land1
*  lbankpostcode
*  swift
*  vendor
*  vendorname
*  vendorname2
*  bgreqdt
*  bgeffdt
*  bgexpdt
*  bgclaimexpdt
*  bgtype
*  bgcatag
*  bgamt
*  bgtenure
*  bgtenureunit
*  bgbenefcode
*  bgbenefname
*  bgaddress1
*  bgaddress2
*  bgcountry
*  bgstate
*  bgcity
*  bgpostalcode
*  bgpurpose
*  bgexchangerate
*  bgamount
*  bgcreator
*  bgcreditdays
*  chargesrate
*  waers
*  bcopenchrgs
*  bankbcopenchrgs
*  bankminchrgs
*  nontaxamt
*  stampcharges
*  pntcharges
*  taxcode
*  cgst
*  sgst
*  igst
*  totalchrgs
*  bankremarks
*  busplc
*  seccode
*  bgammendcharges
*  bgtendate
*  shiftcharges
*  shiftdate
*  netbgamount
*  bgcleanamount
*  fdamountassigned
*  bgcleanassigned
*  locallastchangedat
*  status
*  criticality
*  amendment
*  setout
zeximbgrefno
      version
      bukrs
      butxt
      street
      city
      Country
       hbkid
      hktid
      bankl
      bgbenfname
   )
          WITH lt_bghead
      MAPPED DATA(mapped_create)
      FAILED DATA(failed_create)
      REPORTED DATA(reported_create).
    mapped-head   =  mapped_create-head.
    READ ENTITIES OF zi_bgheader IN LOCAL MODE
      ENTITY head
      ALL FIELDS WITH CORRESPONDING #( mapped_create-head )
      RESULT DATA(read_created_result).


*    READ ENTITIES OF zi_bgheader IN LOCAL MODE
*           ENTITY head
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(header_1).
*
*    result = VALUE #( FOR ls_header IN header_1
*                      ( %tky   = ls_header-%tky
*                        %param = ls_header ) ).
*
*    result = VALUE #( FOR positieon IN read_created_result ( %tky   = positieon-%tky
*                                                            %param = positieon ) ).
  ENDMETHOD.

  METHOD determinebgrefno.
    READ ENTITIES OF zi_bgheader IN LOCAL MODE
        ENTITY  head
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(header)
        FAILED DATA(header_failed).

**********************************************************************
*==BG number creation on create action
**********************************************************************
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-Hbkid IS NOT INITIAL.
      SELECT SINGLE * FROM zexim_lcim_bnk1
       WHERE bukrs = @gfs_header-Bukrs AND hbkid = @gfs_header-Hbkid AND zaccno = @gfs_header-Bankl
      INTO @DATA(ls_bnk).


      IF gfs_header-Zeximbgrefno IS INITIAL.

        SELECT SINGLE MAX( Zeximbgrefno ) FROM zbg_header INTO @DATA(lv_bghead).
        lv_bghead =   lv_bghead  + 1.
        gfs_header-Zeximbgrefno =   lv_bghead .
        gfs_header-Version = '1'.

        MODIFY ENTITIES OF zi_bgheader IN LOCAL MODE
            ENTITY head
            UPDATE
                FIELDS ( Zeximbgrefno Version status  Bgamt Bgcleanamount Bgcleanassigned )
                WITH VALUE #(
                               (  %tky = gfs_header-%tky
                                Zeximbgrefno = lv_bghead
                                Version = gfs_header-Version
                                 status   = 'Created'
                          Bgamt = ls_bnk-bgcleanavailable
                          Bgcleanamount =  ls_bnk-bglimit
                          Bgcleanassigned = ls_bnk-bgcleanutilised
                 ) ).
      ELSE.

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD SetOut.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_bgheader IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header).

    READ TABLE header ASSIGNING FIELD-SYMBOL(<head>) INDEX 1.
    IF sy-subrc = 0.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <head>-Setout     = 'X'.
      <head>-Status      = 'Completed'.

      MODIFY ENTITIES OF zi_bgheader IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS (  Status )
             WITH VALUE #( FOR key IN keys
                           ( %tky        = key-%tky
                             Status      = <head>-Status ) )
             FAILED failed
             REPORTED reported.

    ENDIF.

    " Fill the response table
    READ ENTITIES OF zi_bgheader IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD determainebgamt.

*    READ ENTITIES OF zi_bgheader IN LOCAL MODE
*      ENTITY  head
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(header)
*      FAILED DATA(header_failed).
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*
*    IF gfs_header-Hbkid IS NOT INITIAL.
*      SELECT SINGLE * FROM zexim_lcim_bnk1
*       WHERE bukrs = @gfs_header-Bukrs AND hbkid = @gfs_header-Hbkid AND zaccno = @gfs_header-Bankl
*      INTO @DATA(ls_bnk).
*
*      MODIFY ENTITIES OF zi_bgheader IN LOCAL MODE
*    ENTITY head
*    UPDATE
*        FIELDS ( Bgamt Bgcleanamount Bgcleanassigned )
*        WITH VALUE #(
*                       (  %tky = gfs_header-%tky
*                        Bgamt = ls_bnk-bglimit
*                        Bgcleanamount = ls_bnk-bgcleanavailable
*                        Bgcleanassigned = ls_bnk-bgcleanutilised
*         ) ).
*
*    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_BGHEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_BGHEADER IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
