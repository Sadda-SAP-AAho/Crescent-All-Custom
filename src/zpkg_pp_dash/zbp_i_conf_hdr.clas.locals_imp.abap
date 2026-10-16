CLASS lhc_zi_conf_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_conf_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_conf_hdr RESULT result.

    METHODS simu FOR MODIFY
      IMPORTING keys FOR ACTION zi_conf_hdr~simu RESULT result.

    METHODS alloc FOR MODIFY
      IMPORTING keys FOR ACTION zi_conf_hdr~alloc RESULT result.

    METHODS genser FOR MODIFY
      IMPORTING keys FOR ACTION zi_conf_hdr~genser RESULT result.

    METHODS confdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_conf_hdr~confdetails.

    METHODS contdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_conf_hdr~contdetails.

    METHODS updatedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_conf_hdr~updatedata.

    METHODS checkval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_hdr~checkval.

*    METHODS checkcomb1 FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zi_conf_hdr~checkcomb1.
*
*    METHODS checkcomb2 FOR VALIDATE ON SAVE
*      IMPORTING keys FOR zi_conf_hdr~checkcomb2.

    METHODS scanitem FOR MODIFY
      IMPORTING keys FOR ACTION zi_conf_hdr~scan RESULT result.

    METHODS get_mat_by_fgopplnt
      IMPORTING mat           TYPE matnr
                op            TYPE zi_conf_hdr-opr
                plant         TYPE werks_d
      RETURNING VALUE(lt_mat) TYPE matnr.

    METHODS getcid RETURNING VALUE(cid) TYPE abp_behv_cid.

ENDCLASS.

CLASS lhc_zi_conf_hdr IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    IF <head>-shpflrno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_conf_hdr WHERE shpflrno = @<head>-shpflrno INTO @DATA(ls_head).

      SELECT SINGLE * FROM zdt_conf_itm WHERE shpflrno = @<head>-shpflrno AND ( status = 'C' OR status = 'P' )  INTO @DATA(ls_c_itm).

      SELECT SINGLE * FROM zdt_confpost_hdr WHERE shpflrno = @<head>-shpflrno AND status = 'Completed' INTO @DATA(ls_cpost_hdr).

      SELECT SINGLE * FROM zdt_pp_delusr WHERE userid = @sy-uname INTO @DATA(ls_usr).

      SELECT SINGLE * FROM zdt_confpost_hdr WHERE shpflrno = @<head>-shpflrno INTO @DATA(ls_confpost).
      SELECT SINGLE * FROM zdr_confpost_hdr WHERE shpflrno = @<head>-shpflrno INTO @DATA(ls_confpost_d).
      IF ls_confpost_d IS NOT INITIAL OR ls_confpost IS NOT INITIAL.
        DATA(lv_flag_del) = 'X'.
      ENDIF.

      SELECT * FROM zdt_conf_itm WHERE shpflrno = @<head>-shpflrno INTO TABLE @DATA(lt_item).
      LOOP AT lt_item INTO DATA(ls_item).
        IF ls_item-balqty IS NOT INITIAL.
          DATA(lv_flag) = 'X'.
        ENDIF.
        IF ls_item-status = 'C'.
        ELSE.
          lv_flag = 'X'.
        ENDIF.
      ENDLOOP.
    ENDIF.

    READ ENTITY zi_conf_hdr
           BY \_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord).

    LOOP AT ord INTO DATA(ls_ord) WHERE serial IS INITIAL.
      DATA(lv_flag1) = 'X'.
      CLEAR : ls_ord.
    ENDLOOP.

    LOOP AT ord INTO ls_ord WHERE status = 'C'.
      DATA(lv_flag2) = 'X'.
      CLEAR : ls_ord.
    ENDLOOP.

    result = VALUE #(
        FOR gs_header IN header
        ( %tky                            = gs_header-%tky
          %assoc-_ord                     = COND #( WHEN <head>-shpflrno IS INITIAL THEN
                                                         if_abap_behv=>fc-o-disabled
                                                    WHEN <head>-shpflrno IS NOT INITIAL THEN
                                                         if_abap_behv=>fc-o-disabled )

         %assoc-_item                     = COND #( WHEN ls_c_itm IS INITIAL THEN
                                                         if_abap_behv=>fc-o-enabled
                                                    WHEN ls_c_itm IS NOT INITIAL THEN
                                                         if_abap_behv=>fc-o-disabled )

         %delete                          = COND #( WHEN ls_usr IS NOT INITIAL AND lv_flag_del <> 'X' THEN "ls_c_itm IS INITIAL THEN
                                                         if_abap_behv=>fc-o-enabled
                                                    WHEN ls_usr IS NOT INITIAL AND lv_flag_del = 'X' THEN "ls_c_itm IS INITIAL THEN
                                                         if_abap_behv=>fc-o-disabled
                                                    WHEN ls_usr IS INITIAL THEN "ls_c_itm is NOT INITIAL THEN
                                                         if_abap_behv=>fc-o-disabled )

         %action-edit                     = COND #( WHEN ls_cpost_hdr IS INITIAL THEN
                                                         if_abap_behv=>fc-o-enabled
                                                    WHEN ls_c_itm IS NOT INITIAL THEN
                                                         if_abap_behv=>fc-o-disabled )

         %field-skilab                    = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-sskilab                    = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-uskilab                    = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-cont                       = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-shpflrdt                  = COND #( WHEN ls_head-shpflrno IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-arpacharg                 = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    WHEN gs_header-opr <> '0010'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-handmochrg                 = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    WHEN gs_header-opr <> '0010'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-rhinocharg                = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    WHEN gs_header-opr <> '0010'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %field-lostfmchrg                 = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    WHEN gs_header-opr <> '0010'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )

       %field-excwtadj                   = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    WHEN gs_header-opr <> '0040'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled  )


        %action-simu                     = COND #( WHEN ls_head-shpflrno IS INITIAL
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    WHEN lv_flag <> 'X'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %action-alloc                    = COND #( WHEN ls_head-shpflrno IS INITIAL
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    WHEN lv_flag <> 'X'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled  )

        %action-genser                   = COND #( WHEN ls_head-shpflrno IS INITIAL
                                                   THEN if_abap_behv=>fc-o-disabled
                                                   WHEN
                                                   " <head>-plant = '1100'  OR
                                                   <head>-plant = '1400' "Commented by SP on 1.9.25
                                                   THEN if_abap_behv=>fc-o-disabled
                                                   WHEN <head>-opr <> '0040'
                                                   THEN if_abap_behv=>fc-o-disabled
                                                   WHEN lv_flag1 <> 'X'
                                                   THEN if_abap_behv=>fc-o-disabled
                                                   WHEN lv_flag2 <> 'X'
                                                   THEN if_abap_behv=>fc-o-disabled
                                                   ELSE if_abap_behv=>fc-o-enabled  )

        %action-scan                   = COND #( WHEN ls_head-opr EQ '0050' OR ls_head-opr EQ '0060' OR ls_head-opr EQ '0070' OR ls_head-opr EQ '0080'
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled  )

        ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD confdetails.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-dept IS NOT INITIAL.
      gfs_header-plantid = gfs_header-dept+0(2).
      gfs_header-dept = |{ gfs_header-dept ALPHA = IN }|.
      SELECT SINGLE cname FROM zi_dept_f4 WHERE kostl = @gfs_header-dept
      INTO @gfs_header-deptname.
    ENDIF.

    IF gfs_header-opr IS NOT INITIAL.
      SELECT SINGLE zopd FROM zi_opr_f4 WHERE zopn = @gfs_header-opr
      INTO @gfs_header-oprname.
    ENDIF.

    IF gfs_header-cont IS NOT INITIAL.
      SELECT SINGLE zcod FROM zi_contractor_f4 WHERE zcon = @gfs_header-cont
      INTO @gfs_header-contname.
    ENDIF.

    IF gfs_header-plantid IS NOT INITIAL.
      gfs_header-plant = gfs_header-plantid && '00'.
    ENDIF.

    gfs_header-header = 'Shop Floor Production Dashboard'.

    MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             UPDATE FIELDS ( deptname oprname contname plantid header plant )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             deptname      = gfs_header-deptname
                             oprname       = gfs_header-oprname
                             contname      = gfs_header-contname
                             plantid       = gfs_header-plantid
                             header        = gfs_header-header
                             plant         = gfs_header-plant
                         ) ).
  ENDMETHOD.


  METHOD contdetails.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-cont IS NOT INITIAL.
      SELECT SINGLE zcod FROM zi_contractor_f4 WHERE zcon = @gfs_header-cont
      INTO @gfs_header-contname.
    ELSE.
      CLEAR : gfs_header-contname.
    ENDIF.

    MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             UPDATE FIELDS ( contname )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             contname      = gfs_header-contname
                         ) ).
  ENDMETHOD.

  METHOD updatedata.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-shpflrno IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-creby = sy-uname.
      gfs_header-creon = lv_date.

      SELECT MAX( keyid ) AS keyid FROM zdt_conf_hdr WHERE creon = @lv_date
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-shpflrno = lv_date+6(2) && lv_date+4(2) && lv_date+2(2) && gfs_header-opr && lv_keyid.

      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             UPDATE FIELDS ( shpflrno keyid creby creon  )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             shpflrno      = gfs_header-shpflrno
                             keyid         = gfs_header-keyid
                             creon         = gfs_header-creon
                             creby         = gfs_header-creby
                         ) ).

    ENDIF.

    READ ENTITY zi_conf_hdr
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item).

    LOOP AT item INTO DATA(ls_item).

      IF ls_item-shpflrno IS INITIAL.

        ls_item-shpflrno = gfs_header-shpflrno.

        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                    ENTITY zi_conf_itm
                    UPDATE FIELDS ( shpflrno )
                    WITH VALUE #( id = ls_item-id
                                  ( %tky         = ls_item-%tky
                                    shpflrno     = ls_item-shpflrno
                                   ) ).
      ENDIF.
      CLEAR : ls_item.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkval.
    DATA : lv_msg TYPE char100.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-shpflrdt IS INITIAL.
      lv_msg = |Shop Floor Date is mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_conf_hdr.

    ENDIF.

    IF gfs_header-opr = '0010' OR gfs_header-opr = '0020' OR gfs_header-opr = '0030'.
    ELSE.
      IF gfs_header-cont IS INITIAL.
        lv_msg = |Contractor is mandatory|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_conf_hdr.
      ENDIF.
    ENDIF.

  ENDMETHOD.

*  METHOD checkcomb1.
*
*    " Header
*    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
*          ENTITY zi_conf_hdr
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT DATA(header).
*
*    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).
*
*    " All Items
*    READ ENTITY zi_conf_hdr
*         BY \_item
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_item).
*
*    LOOP AT lt_item INTO DATA(ls_item).
*
*      " Get Profit Center from Product-Plant
*      SELECT SINGLE profitcenter
*        FROM i_productplantbasic
*        WHERE product = @ls_item-matnr
*          AND plant   = @ls_header-plant
*        INTO @DATA(lv_pc_mat).
*
*      " Get Profit Center from Cost Center mapping
*      SELECT SINGLE a~profitcenter
*        FROM zi_cc_pc_comb AS a
*        INNER JOIN i_productplantbasic AS b ON a~profitcenter = b~profitcenter
*        WHERE costcenter = @ls_header-dept
*        AND product = @ls_item-matnr
*        AND plant   = @ls_header-plant
*        INTO @DATA(lv_pc_cc).
*
*      " Validation
*      IF lv_pc_mat IS NOT INITIAL
*         AND lv_pc_cc IS NOT INITIAL
*         AND lv_pc_mat <> lv_pc_cc.
*
*        DATA(lv_msg) = |{ ls_item-matnr } - PC & CC not matching|.
*
*        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-zi_conf_hdr.
*
*        APPEND VALUE #(
*                       %tky        = ls_header-%tky
*                       %state_area = 'VALIDATE_HEAD'
*                       %msg        = new_message_with_text(
*                       severity = if_abap_behv_message=>severity-error
*                       text     = lv_msg )
*) TO reported-zi_conf_hdr.
*
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDMETHOD.
*
*  METHOD checkcomb2.
*
*  " Header
*    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
*          ENTITY zi_conf_hdr
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT DATA(header).
*
*    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).
*
*    " All Items
*    READ ENTITY zi_conf_hdr
*         BY \_item
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_item).
*
*    LOOP AT lt_item INTO DATA(ls_item).
*
*      " Get Material Group from Operation Mapping
*      SELECT SINGLE MATKL
*        FROM zdt_opr_mgrp_tmg
*        WHERE zopn = @ls_header-Opr
*        INTO @DATA(lv_mg_mat).
*
*        " Get Profit Group from Product Mapping
*      SELECT SINGLE a~ProductGroup
*        FROM i_product AS a
*        WHERE product = @ls_item-matnr
*        INTO @DATA(lv_pg_mat).
*
*      " Validation
*      IF lv_mg_mat IS NOT INITIAL
*         AND lv_pg_mat IS NOT INITIAL
*         AND lv_mg_mat <> lv_pg_mat.
*
*        DATA(lv_msg) = |{ ls_item-matnr } - Mat. Group not match with Oprn.|.
*
*        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-zi_conf_hdr.
*
*        APPEND VALUE #(
*                       %tky        = ls_header-%tky
*                       %state_area = 'VALIDATE_HEAD'
*                       %msg        = new_message_with_text(
*                       severity = if_abap_behv_message=>severity-error
*                       text     = lv_msg )
*) TO reported-zi_conf_hdr.
*
*      ENDIF.
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD simu.
    DATA : ls_ord TYPE zdt_cont_ord.
    DATA : lv_item TYPE zi_conf_itm-item.
    DATA : lv_p TYPE p.
    DATA : ls_item2 TYPE zi_conf_itm,
           lt_item  TYPE STANDARD TABLE OF zi_conf_itm.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_conf_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item_1).


    READ ENTITY zi_conf_hdr
           BY \_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord_1).

    TYPES : BEGIN OF ty_data,
              matnr   TYPE matnr,
              prodord TYPE zdt_cont_ord-prodord,
              qty     TYPE zdt_conf_itm-balqty,
            END OF ty_data.
    DATA : lt_data TYPE STANDARD TABLE OF ty_data,
           ls_data TYPE ty_data.

    SELECT SINGLE * FROM zdr_conf_hdr WHERE shpflrno = @gfs_header-shpflrno INTO @DATA(ls_shp).

    IF ls_shp IS NOT INITIAL.

      DATA(lv_msg) = |Please save or discard then click on Simulate Button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_conf_hdr.

    ELSE.
      LOOP AT ord_1 INTO DATA(ls_ordu).
        READ TABLE item_1 INTO DATA(ls_check) WITH KEY id = ls_ordu-id item = ls_ordu-item.
        IF ls_ordu-status = 'C'.
          ls_data-matnr = ls_ordu-matnr.
          ls_data-prodord = ls_ordu-prodord.
          ls_data-qty = ls_ordu-pendprqty.
          APPEND ls_data TO lt_data.
          CLEAR ls_data.
          " ELSEIF ls_check-status = 'P' OR ls_check-status = 'C'.
        ELSE.
          MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                ENTITY zi_conf_ord
                DELETE FROM VALUE #( ( id   = ls_ordu-id
                                       item = ls_ordu-item
                                       ord  = ls_ordu-ord ) ).

        ENDIF.
        CLEAR : ls_ordu, ls_check.
      ENDLOOP.

      SELECT a~matnr, SUM( a~qty ) AS qty FROM @lt_data AS a GROUP BY a~matnr INTO TABLE @DATA(lt_data_1).
      SELECT a~matnr, a~prodord, SUM( a~qty ) AS qty FROM @lt_data AS a GROUP BY a~matnr, a~prodord INTO TABLE @DATA(lt_data_2).

      LOOP AT item_1 INTO DATA(ls_item_1).

        READ TABLE lt_data_1 INTO DATA(ls_data_1) WITH KEY matnr = ls_item_1-matnr.
        ls_item_1-allocqty = ls_data_1-qty.
        ls_item_1-balqty = ls_item_1-totcast - ls_item_1-allocqty.
        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                    ENTITY zi_conf_itm
                    UPDATE FIELDS ( allocqty balqty )
                    WITH VALUE #( id = ls_item_1-id
                                  ( %tky         = ls_item_1-%tky
                                    allocqty     = ls_item_1-allocqty
                                    balqty       = ls_item_1-balqty
                                ) ).

        CLEAR : ls_item_1, ls_data_1.
      ENDLOOP.

      READ ENTITY zi_conf_hdr
             BY \_ord
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(ord).

      READ ENTITY zi_conf_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item).


      SELECT a~* FROM zi_ord_mat_det_1 AS a
      INNER JOIN @item AS b ON b~matnr = a~product
      WHERE a~openyieldquantity IS NOT INITIAL AND a~productionplant = @gfs_header-plant
      INTO TABLE @DATA(lt_mat).

      SELECT b~prodord, b~matnr, b~plant, SUM( b~qty ) AS qty  FROM @lt_mat AS a
      INNER JOIN zi_mat_ord_dash_det_2 AS b ON b~matnr = a~product AND b~prodord = a~manufacturingorder AND b~plant = a~productionplant
      AND ( ( b~shpflrno <> @gfs_header-shpflrno ) ) "OR ( b~shpflrno = @gfs_header-shpflrno AND ( status = 'C' OR status = 'P' )  )  )
      GROUP BY b~prodord, b~matnr, b~plant
      INTO TABLE @DATA(lt_mat_1).

      LOOP AT lt_mat ASSIGNING FIELD-SYMBOL(<fs_mat1>).
        READ TABLE lt_mat_1 INTO DATA(ls_mat_1) WITH KEY prodord = <fs_mat1>-manufacturingorder matnr = <fs_mat1>-product plant = <fs_mat1>-productionplant.
        IF ls_mat_1 IS NOT INITIAL.
          <fs_mat1>-openyieldquantity = <fs_mat1>-openyieldquantity - ls_mat_1-qty.
        ENDIF.
        READ TABLE lt_data_2 INTO DATA(ls_data_1_1) WITH KEY matnr = <fs_mat1>-product prodord = <fs_mat1>-manufacturingorder.
        IF ls_data_1_1 IS NOT INITIAL.
          <fs_mat1>-openyieldquantity = <fs_mat1>-openyieldquantity - ls_data_1_1-qty.
        ENDIF.
        CLEAR : ls_mat_1, ls_data_1_1.
      ENDLOOP.

      DELETE lt_mat WHERE openyieldquantity IS INITIAL.
      DELETE lt_mat WHERE openyieldquantity LE 0.

      LOOP AT item INTO DATA(ls_itemd).
        IF ( ls_itemd-status = 'C' OR ls_itemd-status = 'P' ).
          IF ls_itemd-balqty IS NOT INITIAL.
            IF ls_itemd-rejqty1 IS NOT INITIAL OR ls_itemd-rejqty2 IS NOT INITIAL OR ls_itemd-rejqty3 IS NOT INITIAL OR
               ls_itemd-rejqty4 IS NOT INITIAL OR ls_itemd-rejqty5 IS NOT INITIAL OR ls_itemd-rejqty6 IS NOT INITIAL OR
               ls_itemd-rejqty7 IS NOT INITIAL OR ls_itemd-rejqty8 IS NOT INITIAL OR ls_itemd-rejqty9 IS NOT INITIAL.
              IF ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty7 +
                   ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) GT ls_itemd-allocqty.
                ls_item2 = CORRESPONDING #( ls_itemd ).
                ls_item2-balqty = ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                                    ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) - ls_itemd-allocqty.
                ls_item2-status = 'R'.
                APPEND ls_item2 TO lt_item.
                CLEAR : ls_item2.
              ENDIF.
            ENDIF.
            IF ls_itemd-goodcast IS NOT INITIAL.
              ls_item2 = CORRESPONDING #( ls_itemd ).
              IF ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                   ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) GT ls_itemd-allocqty.
                ls_item2-balqty = ls_itemd-balqty - ( ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 +
                                                        ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                                                        ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) - ls_itemd-allocqty ).
              ELSE.
                ls_item2-balqty = ls_itemd-balqty.
              ENDIF.
              APPEND ls_item2 TO lt_item.
              CLEAR : ls_item2.
            ENDIF.
          ENDIF.
        ELSE.
          IF ls_itemd-rejqty1 IS NOT INITIAL OR ls_itemd-rejqty2 IS NOT INITIAL OR ls_itemd-rejqty3 IS NOT INITIAL OR
             ls_itemd-rejqty4 IS NOT INITIAL OR ls_itemd-rejqty5 IS NOT INITIAL OR ls_itemd-rejqty6 IS NOT INITIAL OR
             ls_itemd-rejqty7 IS NOT INITIAL OR ls_itemd-rejqty8 IS NOT INITIAL OR ls_itemd-rejqty9 IS NOT INITIAL.
            ls_item2 = CORRESPONDING #( ls_itemd ).
            ls_item2-balqty = ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                              ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9.
            ls_item2-status = 'R'.
            APPEND ls_item2 TO lt_item.
            CLEAR : ls_item2.
          ENDIF.
          IF ls_itemd-goodcast IS NOT INITIAL.
            ls_item2 = CORRESPONDING #( ls_itemd ).
            ls_item2-balqty = ls_itemd-goodcast.
            APPEND ls_item2 TO lt_item.
            CLEAR : ls_item2.
          ENDIF.
        ENDIF.

      ENDLOOP.

      SORT lt_mat BY product openyieldquantity ASCENDING "DESCENDING "Changed by SP on 10.09.2025
                     manufacturingorder DESCENDING.
      IF gfs_header-shpflrno IS NOT INITIAL.
        LOOP AT lt_item INTO DATA(ls_item) WHERE item IS NOT INITIAL.
          DATA(lv_quan) = ls_item-balqty.
          LOOP AT lt_mat ASSIGNING FIELD-SYMBOL(<ls_mat>) WHERE product = ls_item-matnr.
            ls_ord-matnr = ls_item-matnr.
            ls_ord-plant = gfs_header-plant.
            ls_ord-meins = ls_item-meins.
            ls_ord-shpflrno = ls_item-shpflrno.
            ls_ord-item = ls_item-item.
            ls_ord-prodord = <ls_mat>-manufacturingorder.
            IF lv_quan GT <ls_mat>-openyieldquantity.
              ls_ord-pendprqty =  <ls_mat>-openyieldquantity.
              lv_quan = lv_quan - ls_ord-pendprqty.
              <ls_mat>-openyieldquantity = 0.
            ELSE.
              ls_ord-pendprqty = lv_quan.
              <ls_mat>-openyieldquantity = <ls_mat>-openyieldquantity - lv_quan.
              lv_quan = 0.
            ENDIF.
            IF ls_item-status = 'R'.
              ls_ord-rej = 'X'.
            ENDIF.

            SELECT SINGLE serialnumberprofile FROM i_productplantbasic
            WHERE product = @ls_ord-matnr AND plant = @ls_ord-plant
            INTO @DATA(lv_ser).

            IF ls_ord-pendprqty IS NOT INITIAL.
              IF ( gfs_header-opr = '0040' OR gfs_header-opr = '0050' OR gfs_header-opr = '0060' OR gfs_header-opr = '0080' OR gfs_header-opr = '0070' ) AND
                 ( gfs_header-plant = '1200' OR gfs_header-plant = '1300' OR gfs_header-plant = '1100' ) AND lv_ser = 'Z001'. "Changed by SP on 1.9.25

                DATA : lv_qty TYPE zde_numc10.
                lv_qty = ls_ord-pendprqty.
                DO lv_qty TIMES.

                  lv_p += 1.

                  TRY.
                      lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                    CATCH cx_uuid_error.
                  ENDTRY.
                  lv_item = lv_p && lv_item.
                  ls_ord-pendprqty = 1.
                  MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                  ENTITY zi_conf_hdr
                  CREATE BY \_ord
                  FROM VALUE #( ( id      = gfs_header-id
                                 %target = VALUE #( (     %cid                = lv_item
                                                          item                = ls_ord-item
                                                          ord                 = lv_item
                                                          shpflrno            = ls_ord-shpflrno
                                                          matnr               = ls_ord-matnr
                                                          meins               = ls_ord-meins
                                                          prodord             = ls_ord-prodord
                                                          pendprqty           = ls_ord-pendprqty
                                                          rej                 = ls_ord-rej
                                                          plant               = ls_ord-plant

                                                          %control-item         = if_abap_behv=>mk-on
                                                          %control-ord          = if_abap_behv=>mk-on
                                                          %control-matnr        = if_abap_behv=>mk-on
                                                          %control-meins        = if_abap_behv=>mk-on
                                                          %control-shpflrno     = if_abap_behv=>mk-on
                                                          %control-prodord      = if_abap_behv=>mk-on
                                                          %control-pendprqty    = if_abap_behv=>mk-on
                                                          %control-rej          = if_abap_behv=>mk-on
                                                          %control-plant          = if_abap_behv=>mk-on

                                                   ) ) ) )
                                 MAPPED FINAL(ls_mapped1)
                                 FAILED FINAL(ls_failed1)
                                 REPORTED FINAL(ls_reported1).
                ENDDO.


              ELSE.

                lv_p += 1.

                TRY.
                    lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                  CATCH cx_uuid_error.
                ENDTRY.
                lv_item = lv_p && lv_item.

                MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                ENTITY zi_conf_hdr
                CREATE BY \_ord
                FROM VALUE #( ( id      = gfs_header-id
                               %target = VALUE #( (     %cid                = lv_item
                                                        item                = ls_ord-item
                                                        ord                 = lv_item
                                                        shpflrno            = ls_ord-shpflrno
                                                        matnr               = ls_ord-matnr
                                                        meins               = ls_ord-meins
                                                        prodord             = ls_ord-prodord
                                                        pendprqty           = ls_ord-pendprqty
                                                        rej                 = ls_ord-rej
                                                        plant               = ls_ord-plant

                                                        %control-item         = if_abap_behv=>mk-on
                                                        %control-ord          = if_abap_behv=>mk-on
                                                        %control-matnr        = if_abap_behv=>mk-on
                                                        %control-meins        = if_abap_behv=>mk-on
                                                        %control-shpflrno     = if_abap_behv=>mk-on
                                                        %control-prodord      = if_abap_behv=>mk-on
                                                        %control-pendprqty    = if_abap_behv=>mk-on
                                                        %control-rej          = if_abap_behv=>mk-on
                                                        %control-plant        = if_abap_behv=>mk-on

                                                 ) ) ) )
                               MAPPED FINAL(ls_mapped)
                               FAILED FINAL(ls_failed)
                               REPORTED FINAL(ls_reported).

              ENDIF.
            ENDIF.

            CLEAR : ls_ord, lv_ser.
            IF lv_quan IS INITIAL.
              EXIT.
            ENDIF.
          ENDLOOP.
          CLEAR : ls_item, lv_quan.
        ENDLOOP.
      ENDIF.

      READ ENTITY zi_conf_hdr
             BY \_ord
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(ord1).

      DATA : lv_qty1 TYPE menge_d.
      LOOP AT item INTO DATA(ls_itmu).
        LOOP AT ord1 INTO DATA(ls_ord_u) WHERE id = ls_itmu-id AND item = ls_itmu-item.
          lv_qty1 = lv_qty1 + ls_ord_u-pendprqty.
          CLEAR : ls_ord_u.
        ENDLOOP.
        ls_itmu-allocqty = lv_qty1.
        ls_itmu-balqty = ls_itmu-totqty - ls_itmu-allocqty.

        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                  ENTITY zi_conf_itm
                  UPDATE FIELDS ( allocqty balqty )
                  WITH VALUE #( id = ls_itmu-id
                                ( %tky         = ls_itmu-%tky
                                  allocqty     = ls_itmu-allocqty
                                  balqty       = ls_itmu-balqty
                              ) ).
        CLEAR : ls_itmu, lv_qty1.
      ENDLOOP.

    ENDIF.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

  METHOD alloc.
    DATA : ls_item2 TYPE zi_conf_itm,
           lt_item  TYPE STANDARD TABLE OF zi_conf_itm.
    DATA : ls_ord TYPE zdt_cont_ord.
    DATA : lv_item TYPE zi_packlist_itm-item.
    DATA : lv_p TYPE p.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
              ENTITY zi_conf_hdr
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_conf_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item_1).


    READ ENTITY zi_conf_hdr
           BY \_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord_1).

    TYPES : BEGIN OF ty_data,
              matnr   TYPE matnr,
              prodord TYPE zdt_cont_ord-prodord,
              qty     TYPE zdt_conf_itm-balqty,
            END OF ty_data.
    DATA : lt_data TYPE STANDARD TABLE OF ty_data,
           ls_data TYPE ty_data.

    SELECT SINGLE * FROM zdr_conf_hdr WHERE shpflrno = @gfs_header-shpflrno INTO @DATA(ls_shp).

    IF ls_shp IS NOT INITIAL.

      DATA(lv_msg) = |Please save or discard then click on Allocate Button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_conf_hdr.

    ELSE.

      LOOP AT ord_1 INTO DATA(ls_ordu).
        READ TABLE item_1 INTO DATA(ls_check) WITH KEY id = ls_ordu-id item = ls_ordu-item.
        IF ls_ordu-status = 'C'.
          ls_data-matnr = ls_ordu-matnr.
          ls_data-prodord = ls_ordu-prodord.
          ls_data-qty = ls_ordu-pendprqty.
          APPEND ls_data TO lt_data.
          CLEAR ls_data.
          " ELSEIF ls_check-status = 'P' OR ls_check-status = 'C'.
        ELSE.
          MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                ENTITY zi_conf_ord
                DELETE FROM VALUE #( ( id   = ls_ordu-id
                                       item = ls_ordu-item
                                       ord  = ls_ordu-ord ) ).

        ENDIF.
        CLEAR : ls_ordu, ls_check.
      ENDLOOP.

      SELECT a~matnr, SUM( a~qty ) AS qty FROM @lt_data AS a GROUP BY a~matnr INTO TABLE @DATA(lt_data_1).
      SELECT a~matnr, a~prodord, SUM( a~qty ) AS qty FROM @lt_data AS a GROUP BY a~matnr, a~prodord INTO TABLE @DATA(lt_data_2).

      LOOP AT item_1 INTO DATA(ls_item_1).

        READ TABLE lt_data_1 INTO DATA(ls_data_1) WITH KEY matnr = ls_item_1-matnr.
        ls_item_1-allocqty = ls_data_1-qty.
        ls_item_1-balqty = ls_item_1-totcast - ls_item_1-allocqty.
        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                    ENTITY zi_conf_itm
                    UPDATE FIELDS ( allocqty balqty )
                    WITH VALUE #( id = ls_item_1-id
                                  ( %tky         = ls_item_1-%tky
                                    allocqty     = ls_item_1-allocqty
                                    balqty       = ls_item_1-balqty
                                ) ).

        CLEAR : ls_item_1, ls_data_1.
      ENDLOOP.

      READ ENTITY zi_conf_hdr
             BY \_ord
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(ord).

      READ ENTITY zi_conf_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item).


      SELECT a~* FROM zi_ord_mat_det_1 AS a
      INNER JOIN @item AS b ON b~matnr = a~product
      WHERE a~openyieldquantity IS NOT INITIAL AND a~productionplant = @gfs_header-plant
      INTO TABLE @DATA(lt_mat).

      SELECT b~prodord, b~matnr, b~plant, SUM( b~qty ) AS qty  FROM @lt_mat AS a
      INNER JOIN zi_mat_ord_dash_det_2 AS b ON b~matnr = a~product AND b~prodord = a~manufacturingorder AND b~plant = a~productionplant
      AND ( b~shpflrno <> @gfs_header-shpflrno ) " OR ( b~shpflrno = @gfs_header-shpflrno AND ( status = 'C' OR status = 'P' )  )  )
      GROUP BY b~prodord, b~matnr, b~plant
      INTO TABLE @DATA(lt_mat_1).

      LOOP AT lt_mat ASSIGNING FIELD-SYMBOL(<fs_mat1>).
        READ TABLE lt_mat_1 INTO DATA(ls_mat_1) WITH KEY prodord = <fs_mat1>-manufacturingorder matnr = <fs_mat1>-product plant = <fs_mat1>-productionplant.
        IF ls_mat_1 IS NOT INITIAL.
          <fs_mat1>-openyieldquantity = <fs_mat1>-openyieldquantity - ls_mat_1-qty.
        ENDIF.
        READ TABLE lt_data_2 INTO DATA(ls_data_1_1) WITH KEY matnr = <fs_mat1>-product prodord = <fs_mat1>-manufacturingorder.
        IF ls_data_1_1 IS NOT INITIAL.
          <fs_mat1>-openyieldquantity = <fs_mat1>-openyieldquantity - ls_data_1_1-qty.
        ENDIF.
        CLEAR : ls_mat_1, ls_data_1_1.
      ENDLOOP.

      DELETE lt_mat WHERE openyieldquantity IS INITIAL.
      DELETE lt_mat WHERE openyieldquantity LE 0.


      LOOP AT item INTO DATA(ls_itemd).
        IF ( ls_itemd-status = 'C' OR ls_itemd-status = 'P' ).
          IF ls_itemd-balqty IS NOT INITIAL.
            IF ls_itemd-rejqty1 IS NOT INITIAL OR ls_itemd-rejqty2 IS NOT INITIAL OR ls_itemd-rejqty3 IS NOT INITIAL OR
               ls_itemd-rejqty4 IS NOT INITIAL OR ls_itemd-rejqty5 IS NOT INITIAL OR ls_itemd-rejqty6 IS NOT INITIAL OR
               ls_itemd-rejqty7 IS NOT INITIAL OR ls_itemd-rejqty8 IS NOT INITIAL OR ls_itemd-rejqty9 IS NOT INITIAL.
              IF ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                   ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) GT ls_itemd-allocqty.
                ls_item2 = CORRESPONDING #( ls_itemd ).
                ls_item2-balqty = ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                                    ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) - ls_itemd-allocqty.
                ls_item2-status = 'R'.
                APPEND ls_item2 TO lt_item.
                CLEAR : ls_item2.
              ENDIF.
            ENDIF.
            IF ls_itemd-goodcast IS NOT INITIAL.
              ls_item2 = CORRESPONDING #( ls_itemd ).
              IF ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                   ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) GT ls_itemd-allocqty.
                ls_item2-balqty = ls_itemd-balqty - ( ( ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 +
                                                        ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                                                        ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9 ) - ls_itemd-allocqty ).
              ELSE.
                ls_item2-balqty = ls_itemd-balqty.
              ENDIF.
              APPEND ls_item2 TO lt_item.
              CLEAR : ls_item2.
            ENDIF.
          ENDIF.
        ELSE.
          IF ls_itemd-rejqty1 IS NOT INITIAL OR ls_itemd-rejqty2 IS NOT INITIAL OR ls_itemd-rejqty3 IS NOT INITIAL OR
             ls_itemd-rejqty4 IS NOT INITIAL OR ls_itemd-rejqty5 IS NOT INITIAL OR ls_itemd-rejqty6 IS NOT INITIAL OR
             ls_itemd-rejqty7 IS NOT INITIAL OR ls_itemd-rejqty8 IS NOT INITIAL OR ls_itemd-rejqty9 IS NOT INITIAL.
            ls_item2 = CORRESPONDING #( ls_itemd ).
            ls_item2-balqty = ls_itemd-rejqty1 + ls_itemd-rejqty2 + ls_itemd-rejqty3 + ls_itemd-rejqty4 + ls_itemd-rejqty5 + ls_itemd-rejqty6 +
                              ls_itemd-rejqty7 + ls_itemd-rejqty8 + ls_itemd-rejqty9.
            ls_item2-status = 'R'.
            APPEND ls_item2 TO lt_item.
            CLEAR : ls_item2.
          ENDIF.
          IF ls_itemd-goodcast IS NOT INITIAL.
            ls_item2 = CORRESPONDING #( ls_itemd ).
            ls_item2-balqty = ls_itemd-goodcast.
            APPEND ls_item2 TO lt_item.
            CLEAR : ls_item2.
          ENDIF.
        ENDIF.

      ENDLOOP.

      SORT lt_mat BY product openyieldquantity ASCENDING " DESCENDING "Changed by SP on 10.09.2025
                     manufacturingorder DESCENDING.
      IF gfs_header-shpflrno IS NOT INITIAL.
        LOOP AT lt_item INTO DATA(ls_item) WHERE item IS NOT INITIAL.
          DATA(lv_quan) = ls_item-balqty.
          LOOP AT lt_mat ASSIGNING FIELD-SYMBOL(<ls_mat>) WHERE product = ls_item-matnr.
            ls_ord-matnr = ls_item-matnr.
            ls_ord-plant = gfs_header-plant.
            ls_ord-meins = ls_item-meins.
            ls_ord-shpflrno = ls_item-shpflrno.
            ls_ord-item = ls_item-item.
            ls_ord-prodord = <ls_mat>-manufacturingorder.
            IF lv_quan GT <ls_mat>-openyieldquantity.
              ls_ord-pendprqty =  <ls_mat>-openyieldquantity.
              lv_quan = lv_quan - ls_ord-pendprqty.
              <ls_mat>-openyieldquantity = 0.
            ELSE.
              ls_ord-pendprqty = lv_quan.
              <ls_mat>-openyieldquantity = <ls_mat>-openyieldquantity - lv_quan.
              lv_quan = 0.
            ENDIF.
            IF ls_item-status = 'R'.
              ls_ord-rej = 'X'.
            ENDIF.

            SELECT SINGLE serialnumberprofile FROM i_productplantbasic
            WHERE product = @ls_ord-matnr AND plant = @ls_ord-plant
            INTO @DATA(lv_ser).

            IF ls_ord-pendprqty IS NOT INITIAL.
              IF ( gfs_header-opr = '0040' OR gfs_header-opr = '0050' OR gfs_header-opr = '0060' OR gfs_header-opr = '0080' OR gfs_header-opr = '0070' ) AND
                 ( gfs_header-plant = '1200' OR gfs_header-plant = '1300' OR gfs_header-plant = '1100' ) AND lv_ser = 'Z001'. "Changed by SP on 1.9.25

                DATA : lv_qty TYPE zde_numc10.
                lv_qty = ls_ord-pendprqty.
                DO lv_qty TIMES.

                  lv_p += 1.

                  TRY.
                      lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                    CATCH cx_uuid_error.
                  ENDTRY.
                  lv_item = lv_p && lv_item.

                  ls_ord-pendprqty = 1.
                  MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                  ENTITY zi_conf_hdr
                  CREATE BY \_ord
                  FROM VALUE #( ( id      = gfs_header-id
                                 %target = VALUE #( (     %cid                = lv_item
                                                          item                = ls_ord-item
                                                          ord                 = lv_item
                                                          shpflrno            = ls_ord-shpflrno
                                                          matnr               = ls_ord-matnr
                                                          meins               = ls_ord-meins
                                                          prodord             = ls_ord-prodord
                                                          pendprqty           = ls_ord-pendprqty
                                                          rej                 = ls_ord-rej
                                                          plant               = ls_ord-plant

                                                          %control-item         = if_abap_behv=>mk-on
                                                          %control-ord          = if_abap_behv=>mk-on
                                                          %control-matnr        = if_abap_behv=>mk-on
                                                          %control-meins        = if_abap_behv=>mk-on
                                                          %control-shpflrno     = if_abap_behv=>mk-on
                                                          %control-prodord      = if_abap_behv=>mk-on
                                                          %control-pendprqty    = if_abap_behv=>mk-on
                                                          %control-rej          = if_abap_behv=>mk-on
                                                          %control-plant          = if_abap_behv=>mk-on

                                                   ) ) ) )
                                 MAPPED FINAL(ls_mapped1)
                                 FAILED FINAL(ls_failed1)
                                 REPORTED FINAL(ls_reported1).
                ENDDO.
              ELSE.
                lv_p += 1.

                TRY.
                    lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                  CATCH cx_uuid_error.
                ENDTRY.
                lv_item = lv_p && lv_item.

                MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                ENTITY zi_conf_hdr
                CREATE BY \_ord
                FROM VALUE #( ( id      = gfs_header-id
                               %target = VALUE #( (     %cid                = lv_item
                                                        item                = ls_ord-item
                                                        ord                 = lv_item
                                                        shpflrno            = ls_ord-shpflrno
                                                        matnr               = ls_ord-matnr
                                                        meins               = ls_ord-meins
                                                        prodord             = ls_ord-prodord
                                                        pendprqty           = ls_ord-pendprqty
                                                        rej                 = ls_ord-rej
                                                        plant               = ls_ord-plant

                                                        %control-item         = if_abap_behv=>mk-on
                                                        %control-ord          = if_abap_behv=>mk-on
                                                        %control-matnr        = if_abap_behv=>mk-on
                                                        %control-meins        = if_abap_behv=>mk-on
                                                        %control-shpflrno     = if_abap_behv=>mk-on
                                                        %control-prodord      = if_abap_behv=>mk-on
                                                        %control-pendprqty    = if_abap_behv=>mk-on
                                                        %control-rej          = if_abap_behv=>mk-on
                                                        %control-plant          = if_abap_behv=>mk-on

                                                 ) ) ) )
                               MAPPED FINAL(ls_mapped)
                               FAILED FINAL(ls_failed)
                               REPORTED FINAL(ls_reported).


              ENDIF.
            ENDIF.

            CLEAR : ls_ord, lv_ser.
            IF lv_quan IS INITIAL.
              EXIT.
            ENDIF.
          ENDLOOP.
          CLEAR : ls_item, lv_quan.
        ENDLOOP.
      ENDIF.

      READ ENTITY zi_conf_hdr
             BY \_ord
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(ord1).

      DATA : lv_qty1 TYPE menge_d.
      LOOP AT item INTO DATA(ls_itmu).
        LOOP AT ord1 INTO DATA(ls_ord_u) WHERE id = ls_itmu-id AND item = ls_itmu-item.
          lv_qty1 = lv_qty1 + ls_ord_u-pendprqty.
          CLEAR : ls_ord_u.
        ENDLOOP.
        ls_itmu-allocqty = lv_qty1.
        ls_itmu-balqty = ls_itmu-totqty - ls_itmu-allocqty.

        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                  ENTITY zi_conf_itm
                  UPDATE FIELDS ( allocqty balqty )
                  WITH VALUE #( id = ls_itmu-id
                                ( %tky         = ls_itmu-%tky
                                  allocqty     = ls_itmu-allocqty
                                  balqty       = ls_itmu-balqty
                              ) ).
        CLEAR : ls_itmu, lv_qty1.
      ENDLOOP.

      READ ENTITY zi_conf_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item_u).


      READ ENTITY zi_conf_hdr
             BY \_ord
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(ord_u).

      LOOP AT item_u INTO DATA(ls_item_u).
        IF ls_item_u-balqty IS INITIAL.
          ls_item_u-status = 'C'.
        ELSE.
          ls_item_u-status = 'P'.
        ENDIF.
        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                 ENTITY zi_conf_itm
                 UPDATE FIELDS ( status )
                 WITH VALUE #( id = ls_item_u-id
                               ( %tky         = ls_item_u-%tky
                                 status       = ls_item_u-status
                             ) ).

        CLEAR : ls_item_u.
      ENDLOOP.

      LOOP AT ord_u INTO DATA(ls_ord_u1).
        ls_ord_u1-status = 'C'.
        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                 ENTITY zi_conf_ord
                 UPDATE FIELDS ( status )
                 WITH VALUE #( id = ls_ord_u1-id
                               ( %tky         = ls_ord_u1-%tky
                                status        = ls_ord_u1-status
                             ) ).

        CLEAR : ls_ord_u1.
      ENDLOOP.
    ENDIF.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
          ENTITY zi_conf_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header_upd).

    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

  METHOD scanitem.

    DATA: lv_fg       TYPE matnr,
          lv_serial   TYPE string,
          fflag       TYPE abap_bool VALUE abap_false,
          insertorder TYPE aufnr,
          um          TYPE meins,
          lv_msg      TYPE string.

    ASSIGN keys[ 1 ] TO FIELD-SYMBOL(<ls_key>).
    SPLIT <ls_key>-%param-scanmaterial AT ':::' INTO lv_fg lv_serial.

    READ ENTITY zi_conf_hdr
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT FINAL(lt_current_record).

    ASSIGN lt_current_record[ 1 ] TO FIELD-SYMBOL(<ls_current_record>).

    READ ENTITY zi_conf_hdr
       BY \_item
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT FINAL(lt_current_record_1).

    READ ENTITY zi_conf_hdr
     BY \_ord
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT FINAL(lt_ord_record_1).

*       If same serial number comes it removes the existing record and updates the stock back
*       and then revalidates the new serial number with the stock and other records and then creates new record with same serial number.
    LOOP AT lt_ord_record_1 INTO DATA(ls_ord_record_1) WHERE serial = lv_serial.
      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
            ENTITY zi_conf_ord
            DELETE FROM VALUE #( ( id   = ls_ord_record_1-id
                                   item = ls_ord_record_1-item
                                   ord  = ls_ord_record_1-ord ) ).

      READ TABLE lt_current_record_1 INTO DATA(ls_current_record_11) WITH KEY item = ls_ord_record_1-item.
      IF ls_current_record_11 IS NOT INITIAL.
        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_itm
           UPDATE FIELDS ( goodcast allocqty )
           WITH VALUE #( ( %tky         = ls_current_record_11-%tky
                       allocqty     = ls_current_record_11-allocqty - 1
                       balqty       = 1
                       status       = 'P'
               ) ).
      ENDIF.
    ENDLOOP.



    SELECT SINGLE FROM zr_fgbomlist
    FIELDS operation
    WHERE fg = @lv_fg AND opno IN (
                        SELECT ( opno - 1 ) AS  opno FROM zr_fgbomlist
                            WHERE fg = @lv_fg AND operation = @<ls_current_record>-opr )
    INTO @DATA(prev_op).

    DATA(prev_mat) = get_mat_by_fgopplnt( op = prev_op mat = lv_fg plant = <ls_current_record>-plant ).
    DATA(consump_mat) = get_mat_by_fgopplnt( op = <ls_current_record>-opr mat = lv_fg plant = <ls_current_record>-plant ).
    LOOP AT lt_current_record_1 INTO DATA(ls_current_record_1).


      IF consump_mat IS INITIAL.
        CONTINUE.
      ELSEIF ls_current_record_1-matnr = consump_mat.
        fflag = abap_true.

*       Validations

        SELECT SINGLE FROM zi_conf_ord
                  FIELDS prodord, shpflrno
                  WHERE serial = @lv_serial AND matnr = @ls_current_record_1-matnr
                        AND status = 'C'
*                AND id = @<ls_current_record>-id AND item = @ls_current_record_1-item
                  INTO @DATA(ls_conf_ord).

        IF ls_conf_ord IS NOT INITIAL.
          lv_msg = |Stock { ls_current_record_1-matnr } with serial { lv_serial } is already entered in Production no. { ls_conf_ord-shpflrno }”.|.
          APPEND VALUE #( %tky = <ls_current_record>-%tky ) TO failed-zi_conf_hdr.

          APPEND VALUE #( %tky        = <ls_current_record>-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_conf_hdr.
          RETURN.
        ENDIF.

        SELECT SINGLE FROM i_stockquantitycurrentvalue_2( p_displaycurrency = 'INR' ) AS a
        INNER JOIN i_serialnumberstocksegment AS b ON a~product = b~material AND a~plant = b~plant AND a~batch = b~batch
                                                        AND a~storagelocation = b~storagelocation
        FIELDS a~matlwrhsstkqtyinmatlbaseunit
        WHERE a~product = @prev_mat
          AND a~plant = @<ls_current_record>-plant
          AND b~serialnumber = @lv_serial
          AND a~inventorystocktype = '01'
          AND a~valuationareatype = '1'
          INTO @DATA(stock_with_batch).

        IF stock_with_batch  LT ( ls_current_record_1-goodcast + 1 ).
          lv_msg = |Stock { ls_current_record_1-matnr } with serial { lv_serial } is not available|.
          APPEND VALUE #( %tky = <ls_current_record>-%tky ) TO failed-zi_conf_hdr.

          APPEND VALUE #( %tky        = <ls_current_record>-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_conf_hdr.
          RETURN.
        ENDIF.

        READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_ord
             ALL FIELDS
             WITH VALUE #( ( id = <ls_current_record>-id
                            item = ls_current_record_1-item ) )
             RESULT DATA(ord).

        SELECT FROM zi_ord_mat_det_1 AS a
        FIELDS manufacturingorder, openyieldquantity, productionunit
        WHERE a~product = @consump_mat AND a~productionplant = @<ls_current_record>-plant
              AND a~openyieldquantity IS NOT INITIAL
        INTO TABLE @DATA(lt_ord_mat).

        LOOP AT lt_ord_mat INTO DATA(ls_ord_mat).

          SELECT SINGLE FROM zi_conf_ord
          FIELDS SUM( pendprqty ) AS pendprqty
          WHERE id = @<ls_current_record>-id AND item = @ls_current_record_1-item
                AND prodord = @ls_ord_mat-manufacturingorder
                AND matnr = @consump_mat
                AND meins = @ls_ord_mat-productionunit
          INTO  @DATA(lv_pendprqty).

          IF lv_pendprqty LT ls_ord_mat-openyieldquantity.
            insertorder = ls_ord_mat-manufacturingorder.
            um = ls_ord_mat-productionunit.
            EXIT.
          ENDIF.

        ENDLOOP.

        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
        ENTITY zi_conf_itm
        UPDATE FIELDS ( goodcast allocqty )
        WITH VALUE #( ( %tky         = ls_current_record_1-%tky
                    goodcast     = ls_current_record_1-goodcast + 1
                    totqty       = ls_current_record_1-totqty + 1
*                    allocqty     = 1
*                    balqty       = 0
*                    status       = 'C'
                    allocqty     = COND #( WHEN insertorder IS INITIAL THEN ls_current_record_1-allocqty ELSE ls_current_record_1-allocqty + 1 )
                    balqty       = COND #( WHEN insertorder IS INITIAL THEN 1 ELSE 0 )
                    status       = COND #( WHEN insertorder IS INITIAL THEN 'P' ELSE 'C' )
                ) ).

        MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                 ENTITY zi_conf_hdr
                 CREATE BY \_ord
                 FROM VALUE #( ( id      = <ls_current_record>-id
                                %target = VALUE #( (     %cid                = getcid( )
                                                         item                = ls_current_record_1-item
                                                         ord                 = getcid( )
                                                         shpflrno            = <ls_current_record>-shpflrno
                                                         matnr               = consump_mat
                                                         meins               = um
                                                         prodord             = insertorder
                                                         pendprqty           = 1
                                                         plant               = <ls_current_record>-plant
                                                         serial              = lv_serial
*                                                         status              = 'C'
                                                         status              = COND #( WHEN insertorder IS INITIAL THEN '' ELSE 'C' )

                                                     %control-item         = if_abap_behv=>mk-on
                                                     %control-ord          = if_abap_behv=>mk-on
                                                     %control-matnr        = if_abap_behv=>mk-on
                                                     %control-meins        = if_abap_behv=>mk-on
                                                     %control-shpflrno     = if_abap_behv=>mk-on
                                                     %control-prodord      = if_abap_behv=>mk-on
                                                     %control-pendprqty    = if_abap_behv=>mk-on
                                                     %control-rej          = if_abap_behv=>mk-on
                                                     %control-plant          = if_abap_behv=>mk-on
                                                     %control-serial         = if_abap_behv=>mk-on
                                                     %control-status         = if_abap_behv=>mk-on

                                                  ) ) ) )
                MAPPED DATA(ls_mapped1)
                FAILED DATA(ls_failed1)
                REPORTED DATA(ls_reported1).

      ENDIF.

    ENDLOOP.

*   Case for inserting new Item
    IF fflag = abap_false.
*       Validations

      SELECT SINGLE FROM i_stockquantitycurrentvalue_2( p_displaycurrency = 'INR' ) AS a
         INNER JOIN i_serialnumberstocksegment AS b ON a~product = b~material AND a~plant = b~plant AND a~batch = b~batch
                                                         AND a~storagelocation = b~storagelocation
         FIELDS a~matlwrhsstkqtyinmatlbaseunit
         WHERE a~product = @prev_mat
           AND a~plant = @<ls_current_record>-plant
           AND b~serialnumber = @lv_serial
           AND a~inventorystocktype = '01'
           AND a~valuationareatype = '1'
           INTO @stock_with_batch.

      IF stock_with_batch  LT ( ls_current_record_1-goodcast + 1 ).
        lv_msg = |Stock { ls_current_record_1-matnr } with serial { lv_serial } is not available|.
        APPEND VALUE #( %tky = <ls_current_record>-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = <ls_current_record>-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_conf_hdr.
        RETURN.
      ENDIF.

      SELECT SINGLE FROM zi_conf_ord
      FIELDS prodord, shpflrno
      WHERE serial = @lv_serial AND matnr = @ls_current_record_1-matnr
*            AND id = @<ls_current_record>-id AND item = @ls_current_record_1-item
      INTO @ls_conf_ord.

      IF ls_conf_ord IS NOT INITIAL.
        lv_msg = |Stock { ls_current_record_1-matnr } with serial { lv_serial } is already entered in Production no. { ls_conf_ord-shpflrno }.|.
        APPEND VALUE #( %tky = <ls_current_record>-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = <ls_current_record>-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_conf_hdr.
        RETURN.
      ENDIF.

      READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_ord
           ALL FIELDS
           WITH VALUE #( ( id = <ls_current_record>-id
                          item = ls_current_record_1-item ) )
           RESULT ord.

      SELECT FROM zi_ord_mat_det_1 AS a
      FIELDS manufacturingorder, openyieldquantity, productionunit
      WHERE a~product = @consump_mat AND a~productionplant = @<ls_current_record>-plant
            AND a~openyieldquantity IS NOT INITIAL
      INTO TABLE @lt_ord_mat.

      LOOP AT lt_ord_mat INTO ls_ord_mat.

        SELECT SINGLE FROM zi_conf_ord
        FIELDS SUM( pendprqty ) AS pendprqty
        WHERE id = @<ls_current_record>-id AND item = @ls_current_record_1-item
              AND prodord = @ls_ord_mat-manufacturingorder
              AND matnr = @consump_mat
              AND meins = @ls_ord_mat-productionunit
        INTO  @lv_pendprqty.

        IF lv_pendprqty LT ls_ord_mat-openyieldquantity.
          insertorder = ls_ord_mat-manufacturingorder.
          um = ls_ord_mat-productionunit.
          EXIT.
        ENDIF.

      ENDLOOP.


      SELECT SINGLE FROM i_product
      FIELDS netweight
      WHERE product = @consump_mat
      INTO @DATA(lv_netweight).

      DATA(itemcid) = getcid( ).


      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
               ENTITY zi_conf_hdr
               CREATE BY \_item
                FROM VALUE #( ( id = <ls_current_record>-id
                              %target = VALUE #( (     %cid                = getcid( )
                                                       item                = itemcid
                                                       goodcast            = 1
                                                       matnr               = consump_mat
                                                       stdwt               = lv_netweight
                                                       actwt               = lv_netweight
                                                       totqty              = 1
*                                                       allocqty            = 1
*                                                       balqty              = 0
*                                                       status              = 'C'
                                                       allocqty            = COND #( WHEN insertorder IS INITIAL THEN 0 ELSE 1 )
                                                       balqty              = COND #( WHEN insertorder IS INITIAL THEN 1 ELSE 0 )
                                                       status              = COND #( WHEN insertorder IS INITIAL THEN 'P' ELSE 'C' )

                                                         %control-item          = if_abap_behv=>mk-on
                                                         %control-goodcast      = if_abap_behv=>mk-on
                                                         %control-matnr         = if_abap_behv=>mk-on
                                                         %control-stdwt         = if_abap_behv=>mk-on
                                                         %control-actwt         = if_abap_behv=>mk-on
                                                         %control-allocqty      = if_abap_behv=>mk-on
                                                         %control-status        = if_abap_behv=>mk-on

                                                ) ) ) )
              MAPPED DATA(ls_mapped2)
              FAILED DATA(ls_failed2)
              REPORTED DATA(ls_reported2).

      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             CREATE BY \_ord
             FROM VALUE #( ( id      = <ls_current_record>-id
                            %target = VALUE #( (     %cid                = getcid( )
                                                     item                = itemcid
                                                     ord                 = getcid( )
                                                     shpflrno            = <ls_current_record>-shpflrno
                                                     matnr               = consump_mat
                                                     meins               = um
                                                     prodord             = insertorder
                                                     pendprqty           = 1
                                                     plant               = <ls_current_record>-plant
                                                     serial              = lv_serial
*                                                     status              = 'C'
                                                     status              = COND #( WHEN insertorder IS INITIAL THEN '' ELSE 'C' )

                                                     %control-item         = if_abap_behv=>mk-on
                                                     %control-ord          = if_abap_behv=>mk-on
                                                     %control-matnr        = if_abap_behv=>mk-on
                                                     %control-meins        = if_abap_behv=>mk-on
                                                     %control-shpflrno     = if_abap_behv=>mk-on
                                                     %control-prodord      = if_abap_behv=>mk-on
                                                     %control-pendprqty    = if_abap_behv=>mk-on
                                                     %control-rej          = if_abap_behv=>mk-on
                                                     %control-plant          = if_abap_behv=>mk-on
                                                     %control-serial         = if_abap_behv=>mk-on
                                                     %control-status         = if_abap_behv=>mk-on

                                              ) ) ) )
            MAPPED ls_mapped1
            FAILED ls_failed1
            REPORTED ls_reported1.
    ENDIF.

    READ ENTITY zi_conf_hdr
              BY \_ord
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(ord1).

    READ ENTITY zi_conf_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item).

    DATA : lv_qty1 TYPE menge_d.
    LOOP AT item INTO DATA(ls_itmu).
      LOOP AT ord1 INTO DATA(ls_ord_u) WHERE id = ls_itmu-id AND item = ls_itmu-item AND status = 'C'.
        lv_qty1 = lv_qty1 + ls_ord_u-pendprqty.
        CLEAR : ls_ord_u.
      ENDLOOP.
      ls_itmu-allocqty = lv_qty1.
      ls_itmu-balqty = ls_itmu-totqty - ls_itmu-allocqty.

      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                ENTITY zi_conf_itm
                UPDATE FIELDS ( allocqty balqty )
                WITH VALUE #( id = ls_itmu-id
                              ( %tky         = ls_itmu-%tky
                                allocqty     = ls_itmu-allocqty
                                balqty       = ls_itmu-balqty
                            ) ).
      CLEAR : ls_itmu, lv_qty1.
    ENDLOOP.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).

    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

  METHOD getcid.
    TRY.
        cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
  ENDMETHOD.

  METHOD get_mat_by_fgopplnt.
    SELECT SINGLE FROM zr_fgbomlist
         FIELDS material
         WHERE fg = @mat
             AND plant = @plant
             AND operation = @op
         INTO @lt_mat.

  ENDMETHOD.

  METHOD genser.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
                ENTITY zi_conf_hdr
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zdr_conf_hdr WHERE shpflrno = @gfs_header-shpflrno INTO @DATA(ls_shp).

    IF ls_shp IS NOT INITIAL.

      DATA(lv_msg) = |Please save or discard then click on Generate Serial Button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_conf_hdr.

    ELSE.

      READ ENTITY zi_conf_hdr
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item).


      READ ENTITY zi_conf_hdr
             BY \_ord
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(ord).

      SELECT a~matnr, MAX( a~serial ) AS serial
      FROM zdt_cont_ord AS a
      INNER JOIN zdt_conf_hdr AS b ON b~id = a~id
      WHERE b~shpflrdt = @gfs_header-shpflrdt
      GROUP BY a~matnr
      INTO TABLE @DATA(lt_sl).

      DATA(ord_1) = ord[].
      SORT ord_1 BY matnr.
      DELETE ADJACENT DUPLICATES FROM ord_1 COMPARING matnr.

      DATA : lv_num TYPE numc3.

      LOOP AT ord_1 INTO DATA(ls_ord).
        SELECT SINGLE serialnumberprofile FROM i_productplantbasic
          WHERE product = @ls_ord-matnr AND plant = @ls_ord-plant
          INTO @DATA(lv_ser).
        IF lv_ser = 'Z001'.
          READ TABLE lt_sl INTO DATA(ls_sl) WITH KEY matnr = ls_ord-matnr.
          IF ls_sl-serial IS NOT INITIAL.
            DATA(lv_sl) = ls_sl-serial.
          ENDIF.
          IF lv_sl IS INITIAL.
            lv_num = 0.
          ELSE.
            lv_num = lv_sl+7(3).
          ENDIF.

          LOOP AT ord INTO DATA(ls_ord_1) WHERE matnr = ls_ord-matnr AND serial IS INITIAL.
            lv_num = lv_num + 1.
            ls_ord_1-serial = gfs_header-shpflrdt+6(2) && gfs_header-shpflrdt+4(2) && gfs_header-shpflrdt+2(2) && '-' && lv_num.

            MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
                   ENTITY zi_conf_ord
                   UPDATE FIELDS ( serial )
                   WITH VALUE #( id = ls_ord_1-id
                                 ( %tky         = ls_ord_1-%tky
                                  serial        = ls_ord_1-serial
                               ) ).


            CLEAR : ls_ord_1.
          ENDLOOP.
        ENDIF.
        CLEAR : ls_ord, ls_sl, lv_sl, lv_num, lv_ser.
      ENDLOOP.

    ENDIF.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
            ENTITY zi_conf_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header_upd).

    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_conf_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_conf_itm RESULT result.

    METHODS matdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_conf_itm~matdetails.

    METHODS cal_totqty FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_conf_itm~cal_totqty.

    METHODS getmouqty FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_conf_itm~getmouqty.

    METHODS valitem FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_itm~valitem.

    METHODS deleteval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_itm~deleteval.

    METHODS checkcomb1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_itm~checkcomb1.

    METHODS checkcomb2 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_itm~checkcomb2.

    METHODS checkcomb3 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_itm~checkcomb3.


ENDCLASS.

CLASS lhc_zi_conf_itm IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_itm
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(item_failed).

    READ ENTITY zi_conf_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord).

    IF <head>-shpflrno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_conf_itm WHERE shpflrno = @<head>-shpflrno AND ( status = 'C' OR status = 'P' ) INTO @DATA(ls_c_itm).
    ENDIF.

    SELECT SINGLE * FROM zdt_pp_delusr WHERE userid = @sy-uname INTO @DATA(ls_usr).

    DATA(itm_tmp) = item[].
    LOOP AT itm_tmp ASSIGNING FIELD-SYMBOL(<fs_tmp>).
      READ TABLE ord INTO DATA(ls_ord) WITH KEY matnr = <fs_tmp>-matnr.
      IF ls_ord IS NOT INITIAL.
        <fs_tmp>-checkdel = 'X'.
      ENDIF.
      IF <fs_tmp>-item IS NOT INITIAL.
        SELECT SINGLE * FROM zdt_conf_itm WHERE id = @<fs_tmp>-id AND item = @<fs_tmp>-item
        INTO @DATA(ls_check_mat).
        IF ls_check_mat IS INITIAL.
          <fs_tmp>-checkcrt = 'X'.
        ENDIF.
      ENDIF.
      CLEAR : ls_ord, ls_check_mat.
    ENDLOOP.

    result = VALUE #(
          FOR gs_item IN itm_tmp
          ( %tky                       = gs_item-%tky
            %field-actwt               = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-goodcast            = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-noofhead            = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty1             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty2             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty3             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty4             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty5             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty6             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty7             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty8             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejqty9             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea1             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea2             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea3             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea4             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea5             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea6             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea7             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea8             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-rejrea9             = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-totmou              = COND #( WHEN ls_c_itm IS NOT INITIAL
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-pattern             = COND #( WHEN ls_c_itm IS NOT INITIAL OR <head>-opr <> '0040'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-so                  = COND #( WHEN ls_c_itm IS NOT INITIAL OR <head>-opr <> '0110'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-soitm               = COND #( WHEN ls_c_itm IS NOT INITIAL OR <head>-opr <> '0110'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %field-sofg                = COND #( WHEN ls_c_itm IS NOT INITIAL OR <head>-opr <> '0110'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )
            %features-%delete          = COND #(
                                                 "WHEN ls_c_itm IS NOT INITIAL
                                                 "THEN if_abap_behv=>fc-o-disabled
                                                 WHEN gs_item-checkcrt = 'X'
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 WHEN ls_usr IS INITIAL
                                                 THEN if_abap_behv=>fc-o-disabled
                                                 WHEN gs_item-checkdel = 'X'
                                                 THEN if_abap_behv=>fc-o-disabled
                                                 ELSE if_abap_behv=>fc-o-enabled  )

          ) ).
  ENDMETHOD.

  METHOD matdetails.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
         ENTITY zi_conf_itm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item).

    LOOP AT item INTO DATA(ls_item).

      ls_item-shpflrno = gfs_header-shpflrno.

      SELECT SINGLE productname FROM i_producttext
      WHERE product = @ls_item-matnr AND language = 'E'
      INTO @ls_item-maktx.

      SELECT SINGLE * FROM i_product WHERE product = @ls_item-matnr
      INTO @DATA(ls_mara).

      ls_item-meins  = ls_mara-baseunit.
      ls_item-wtunit = ls_mara-weightunit.
      ls_item-stdwt  = ls_mara-netweight. "grossweight  .

      SELECT SINGLE * FROM zdt_pp_matinffld WHERE product = @ls_item-matnr INTO @DATA(ls_info).

      ls_item-qtyperbox = ls_info-qtyperbox.
      ls_item-machloss  = ls_info-machloss.

      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
               ENTITY zi_conf_itm
               UPDATE FIELDS ( shpflrno maktx meins wtunit stdwt qtyperbox machloss )
               WITH VALUE #( id = ls_item-id
                             ( %tky         = ls_item-%tky
                               shpflrno     = ls_item-shpflrno
                               maktx        = ls_item-maktx
                               meins        = ls_item-meins
                               wtunit       = ls_item-wtunit
                               stdwt        = ls_item-stdwt
                               qtyperbox    = ls_item-qtyperbox
                               machloss     = ls_item-machloss
                           ) ).

      CLEAR : ls_item.
    ENDLOOP.
  ENDMETHOD.

  METHOD cal_totqty.
    DATA : lv_qty TYPE menge_d.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
         ENTITY zi_conf_itm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item).

    READ ENTITY zi_conf_hdr
           BY \_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord).

    LOOP AT item INTO DATA(ls_item).

      LOOP AT ord INTO DATA(ls_ord_u) WHERE id = ls_item-id AND item = ls_item-item.
        lv_qty = lv_qty + ls_ord_u-pendprqty.
        CLEAR : ls_ord_u.
      ENDLOOP.

      ls_item-totcast = ls_item-goodcast + ls_item-rejqty1 + ls_item-rejqty2 + ls_item-rejqty3
                        + ls_item-rejqty4 + ls_item-rejqty5 + ls_item-rejqty6
                        + ls_item-rejqty7 + ls_item-rejqty8 + ls_item-rejqty9.
      ls_item-totqty = ls_item-totcast.
      ls_item-allocqty = lv_qty.
      ls_item-balqty = ls_item-totcast - ls_item-allocqty.
      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
               ENTITY zi_conf_itm
               UPDATE FIELDS ( totcast totqty allocqty balqty )
               WITH VALUE #( id = ls_item-id
                             ( %tky         = ls_item-%tky
                               totcast      = ls_item-totcast
                               totqty       = ls_item-totqty
                               allocqty     = ls_item-allocqty
                               balqty       = ls_item-balqty
                           ) ).

      CLEAR : ls_item, lv_qty.
    ENDLOOP.
  ENDMETHOD.
  METHOD valitem.
    DATA : lv_msg1 TYPE char100.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
               ENTITY zi_conf_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
         ENTITY zi_conf_itm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item).

    LOOP AT item INTO DATA(ls_item).
      IF ls_item-rejqty1 IS NOT INITIAL AND ls_item-rejrea1 IS INITIAL.
        lv_msg1 = |Rejection Reason 1 is mandatory for | && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty2 IS NOT INITIAL AND ls_item-rejrea2 IS INITIAL.
        lv_msg1 = |Rejection Reason 2 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty3 IS NOT INITIAL AND ls_item-rejrea3 IS INITIAL.
        lv_msg1 = |Rejection Reason 3 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty4 IS NOT INITIAL AND ls_item-rejrea4 IS INITIAL.
        lv_msg1 = |Rejection Reason 4 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty5 IS NOT INITIAL AND ls_item-rejrea5 IS INITIAL.
        lv_msg1 = |Rejection Reason 5 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty6 IS NOT INITIAL AND ls_item-rejrea6 IS INITIAL.
        lv_msg1 = |Rejection Reason 6 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty7 IS NOT INITIAL AND ls_item-rejrea7 IS INITIAL.
        lv_msg1 = |Rejection Reason 7 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty8 IS NOT INITIAL AND ls_item-rejrea8 IS INITIAL.
        lv_msg1 = |Rejection Reason 8 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF ls_item-rejqty9 IS NOT INITIAL AND ls_item-rejrea9 IS INITIAL.
        lv_msg1 = |Rejection Reason 9 is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
      IF gfs_header-opr = '0040' AND ls_item-actwt IS INITIAL.
        lv_msg1 = |Actual weight is mandatory for| && ls_item-matnr.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Item'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
    ENDLOOP.

    READ ENTITY zi_conf_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item_2).

    DATA(item_1) = item_2[].
    IF item_1[] IS NOT INITIAL.
      SORT item_1 BY matnr.
      DATA(lv_line_1) = lines( item_1 ).
      DELETE ADJACENT DUPLICATES FROM item_1 COMPARING matnr.
      DATA(lv_line_2) = lines( item_1 ).
      IF lv_line_1 <> lv_line_2.
        lv_msg1 = |Please remove duplicate material|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_conf_hdr.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD getmouqty.

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
               ENTITY zi_conf_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
         ENTITY zi_conf_itm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item).

    LOOP AT item INTO DATA(ls_item).

      ls_item-totmouqty = ( ls_item-totmou * ls_item-qtyperbox ).

      MODIFY ENTITIES OF zi_conf_hdr IN LOCAL MODE
               ENTITY zi_conf_itm
               UPDATE FIELDS ( totmouqty )
               WITH VALUE #( id = ls_item-id
                             ( %tky         = ls_item-%tky
                               totmouqty     = ls_item-totmouqty
                           ) ).

      CLEAR : ls_item.
    ENDLOOP.


  ENDMETHOD.


  METHOD deleteval.

*    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
*               ENTITY zi_conf_hdr
*               ALL FIELDS
*               WITH CORRESPONDING #( keys )
*               RESULT FINAL(header).
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
*         ENTITY zi_conf_itm
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(item).
*
*    DATA : lv_msg1 TYPE char100.
*
*    lv_msg1 = |Please remove duplicate material|.
*    APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.
*
*    APPEND VALUE #( %tky        = gfs_header-%tky
*                    %state_area = 'Validate_Header'
*                    %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                         text     = lv_msg1 ) )
*    TO reported-zi_conf_hdr.

  ENDMETHOD.

  METHOD checkcomb1.

*--------------------------------------------------------------------*
* Local Declarations
*--------------------------------------------------------------------*
    DATA:
      lv_pc_mat TYPE i_productplantbasic-profitcenter.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
        ENTITY zi_conf_itm
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_changed_items).

    IF lt_changed_items IS INITIAL.
      RETURN.
    ENDIF.

*--------------------------------------------------------------------*
* Loop Changed Items
*--------------------------------------------------------------------*
    LOOP AT lt_changed_items INTO DATA(ls_item).

*--------------------------------------------------------------------*
* Read Header
*--------------------------------------------------------------------*
      READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
        ENTITY zi_conf_itm BY \_head
        ALL FIELDS
        WITH VALUE #(
          ( %tky = ls_item-%tky )
        )
        RESULT DATA(lt_header).

      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

      IF ls_header IS INITIAL.
        CONTINUE.
      ENDIF.

*--------------------------------------------------------------------*
* Get External Product Group of Material
*--------------------------------------------------------------------*
      SELECT externalproductgroup
        FROM i_product
        WHERE product = @ls_item-matnr
        INTO TABLE @DATA(lt_ex_mat).

*--------------------------------------------------------------------*
* Skip Validation if Material belongs to ZE03
*--------------------------------------------------------------------*
      READ TABLE lt_ex_mat
           TRANSPORTING NO FIELDS
           WITH KEY externalproductgroup = 'ZE03'.

      IF sy-subrc = 0.
        CONTINUE.
      ENDIF.

*--------------------------------------------------------------------*
* Get Profit Center from Material + Plant
*--------------------------------------------------------------------*
      CLEAR lv_pc_mat.

      SELECT SINGLE profitcenter
        FROM i_productplantbasic
        WHERE product = @ls_item-matnr
          AND plant   = @ls_header-plant
        INTO @lv_pc_mat.

      CONDENSE lv_pc_mat NO-GAPS.

*--------------------------------------------------------------------*
* Get All Profit Centers from Cost Center Mapping
*--------------------------------------------------------------------*
      SELECT profitcenter
        FROM zi_cc_pc_comb
        WHERE costcenter = @ls_header-dept
        INTO TABLE @DATA(lt_pc_cc).

*--------------------------------------------------------------------*
* Validation
*--------------------------------------------------------------------*
      READ TABLE lt_pc_cc
           TRANSPORTING NO FIELDS
           WITH KEY profitcenter = lv_pc_mat.

      IF sy-subrc <> 0.

        APPEND VALUE #(
          %tky = ls_item-%tky

          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = |Profit Center & Cost Center are not matching|
                 )

          %element-matnr = if_abap_behv=>mk-on

        ) TO reported-zi_conf_itm.

        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-zi_conf_itm.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkcomb2.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
        ENTITY zi_conf_itm
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_changed_items).

    LOOP AT lt_changed_items INTO DATA(ls_changed_item).

*--------------------------------------------------------------------*
* Read Header
*--------------------------------------------------------------------*
      READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
        ENTITY zi_conf_itm BY \_head
        ALL FIELDS
        WITH VALUE #(
          ( %tky = ls_changed_item-%tky )
        )
        RESULT DATA(lt_header).

      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

      IF ls_header IS INITIAL.
        CONTINUE.
      ENDIF.

*--------------------------------------------------------------------*
* Read ALL Items of Current Document
*--------------------------------------------------------------------*
      READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
        ENTITY zi_conf_hdr BY \_item
        ALL FIELDS
        WITH VALUE #(
          ( %tky = ls_header-%tky )
        )
        RESULT DATA(lt_all_items).

*--------------------------------------------------------------------*
* Get Material Group from Operation Mapping
*--------------------------------------------------------------------*
      SELECT SINGLE matkl
        FROM zdt_opr_mgrp_tmg
        WHERE zopn = @ls_header-opr
        INTO @DATA(lv_mg_mat).

*--------------------------------------------------------------------*
* Validate ALL Materials
*--------------------------------------------------------------------*
      LOOP AT lt_all_items INTO DATA(ls_item).

*--------------------------------------------------------------------*
* Get Product Group
*--------------------------------------------------------------------*
        SELECT SINGLE productgroup
          FROM i_product
          WHERE product = @ls_item-matnr
          INTO @DATA(lv_pg_mat).

*--------------------------------------------------------------------*
* Get External Product Group
*--------------------------------------------------------------------*
        SELECT externalproductgroup
          FROM i_product
          WHERE product = @ls_item-matnr
          INTO TABLE @DATA(lt_ex_mat).

*--------------------------------------------------------------------*
* Skip Validation if Any Material belongs to ZE03
*--------------------------------------------------------------------*
        READ TABLE lt_ex_mat
             TRANSPORTING NO FIELDS
             WITH KEY externalproductgroup = 'ZE03'.

        IF sy-subrc = 0.
          CONTINUE.
        ENDIF.

*--------------------------------------------------------------------*
* Validation
*--------------------------------------------------------------------*
        IF lv_mg_mat IS NOT INITIAL
           AND lv_pg_mat IS NOT INITIAL
           AND lv_mg_mat <> lv_pg_mat.

          APPEND VALUE #(
            %tky = ls_item-%tky

            %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = |Material Group not matching with Operation|
                   )

            %element-matnr = if_abap_behv=>mk-on

          ) TO reported-zi_conf_itm.

          APPEND VALUE #(
            %tky = ls_item-%tky
          ) TO failed-zi_conf_itm.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

METHOD checkcomb3.

  DATA:
    lv_max_stock   TYPE p LENGTH 16 DECIMALS 2,
    lv_stock       TYPE p LENGTH 16 DECIMALS 2,
    lv_total_stock TYPE p LENGTH 16 DECIMALS 2.

*--------------------------------------------------------------------*
* Read Header Data from RAP Buffer
*--------------------------------------------------------------------*
  READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
    ENTITY zi_conf_hdr
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_hdr).

*--------------------------------------------------------------------*
* Read Item Data from RAP Buffer
*--------------------------------------------------------------------*
  READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
    ENTITY zi_conf_itm
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

  IF lt_item IS INITIAL.
    RETURN.
  ENDIF.

*--------------------------------------------------------------------*
* Validate Each Item
*--------------------------------------------------------------------*
  LOOP AT lt_item INTO DATA(ls_item).

    CLEAR:
      lv_max_stock,
      lv_stock,
      lv_total_stock.

*--------------------------------------------------------------------*
* Get Header Data
*--------------------------------------------------------------------*
    READ TABLE lt_hdr INTO DATA(ls_hdr)
         WITH KEY id = ls_item-id.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

*--------------------------------------------------------------------*
* Applicable only for Operations 0120 and 0130
*--------------------------------------------------------------------*
    IF ls_hdr-opr <> '0120'
       AND ls_hdr-opr <> '0130'.
      CONTINUE.
    ENDIF.

*--------------------------------------------------------------------*
* Get Maximum Stock Quantity
*--------------------------------------------------------------------*
    SELECT SINGLE maximumstockquantity
      FROM i_productsupplyplanning
      WHERE product = @ls_item-matnr
        AND plant   = @ls_hdr-plant
      INTO @lv_max_stock.

    IF sy-subrc <> 0 OR lv_max_stock IS INITIAL.
      lv_max_stock = 0.
    ENDIF.

*--------------------------------------------------------------------*
* Get Current Stock
*--------------------------------------------------------------------*
    SELECT SINGLE matlwrhsstkqtyinmatlbaseunit
      FROM zi_matwhstock
      WHERE product = @ls_item-matnr
        AND plant   = @ls_hdr-plant
      INTO @lv_stock.

    IF sy-subrc <> 0 OR lv_stock IS INITIAL.
      lv_stock = 0.
    ENDIF.

*--------------------------------------------------------------------*
* Validation
*--------------------------------------------------------------------*
    lv_total_stock = lv_stock + ls_item-goodcast.

    IF lv_total_stock > lv_max_stock.

      APPEND VALUE #(
        %tky = ls_item-%tky
      ) TO failed-zi_conf_itm.

      APPEND VALUE #(
        %tky = ls_item-%tky

        %msg = new_message(
                  id       = 'ZMM'
                  number   = '010'
                  severity = if_abap_behv_message=>severity-error
                  v1       = |{ ls_item-matnr }|
                  v2       = |{ lv_max_stock }|
                  v3       = |{ lv_total_stock }|
               )

        %element-goodcast = if_abap_behv=>mk-on
        %element-matnr    = if_abap_behv=>mk-on

      ) TO reported-zi_conf_itm.

    ENDIF.

  ENDLOOP.

ENDMETHOD.


ENDCLASS.


CLASS lhc_zi_conf_ord DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_conf_ord RESULT result.
    "    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
    "      IMPORTING keys REQUEST requested_authorizations FOR zi_conf_ord RESULT result.

    METHODS checkord FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_conf_ord~checkord.
ENDCLASS.
CLASS lhc_zi_conf_ord IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
           ENTITY zi_conf_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(ord_failed).

    IF <head>-shpflrno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_conf_itm WHERE shpflrno = @<head>-shpflrno AND ( status = 'C' OR status = 'P' ) INTO @DATA(ls_c_itm).
    ENDIF.

    DATA(ord_tmp) = ord[].
    LOOP AT ord_tmp ASSIGNING FIELD-SYMBOL(<fs_tmp>).
      SELECT SINGLE * FROM zdt_confpost_ord
      WHERE refid = @<fs_tmp>-id AND refitem = @<fs_tmp>-item AND reford = @<fs_tmp>-ord
      INTO @DATA(ls_check).
      IF ls_check IS NOT INITIAL.
        <fs_tmp>-ovstatus = 'C'.
      ENDIF.
      CLEAR : ls_check.
    ENDLOOP.

    SELECT SINGLE * FROM zdt_pp_delusr WHERE userid = @sy-uname INTO @DATA(ls_usr).


    result = VALUE #(
          FOR gs_item IN ord_tmp
          ( %tky                       = gs_item-%tky
*            %delete                    = COND #( WHEN <head>-shpflrno IS NOT INITIAL
*                                                 THEN if_abap_behv=>fc-o-disabled
*                                                 ELSE if_abap_behv=>fc-o-disabled  )
            %field-serial              = COND #( WHEN <head>-opr = '0010' OR <head>-opr = '0020' OR <head>-opr = '0030'
                                                   "OR <head>-plant = '1100'  "Commented by SP on 1.9.25
                                                   OR <head>-plant = '1400'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 WHEN gs_item-ovstatus = 'C'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 WHEN gs_item-status <> 'C'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )

            %field-heatno              = COND #( WHEN <head>-opr <> '0010'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 WHEN <head>-plant = '1200' OR <head>-plant = '1300'
                                                      OR <head>-plant = '1100' "Changed by SP on 1.9.25
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 WHEN gs_item-ovstatus = 'C'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 WHEN gs_item-status <> 'C'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )

            %delete                    = COND #( WHEN ls_usr IS INITIAL
                                                 THEN if_abap_behv=>fc-o-disabled
                                                 WHEN gs_item-status = 'C'
                                                 THEN if_abap_behv=>fc-o-disabled
                                                 ELSE if_abap_behv=>fc-o-enabled  )

          ) ).
  ENDMETHOD.

  " METHOD get_instance_authorizations.
  " ENDMETHOD.

  METHOD checkord.
    DATA : lv_msg TYPE char100.
    READ ENTITIES OF zi_conf_hdr IN LOCAL MODE
             ENTITY zi_conf_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_conf_hdr
           BY \_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord).

    IF gfs_header-opr = '0050' OR gfs_header-opr = '0060' OR gfs_header-opr = '0070' OR gfs_header-opr = '0080'.
      DATA(ord_1) = ord[].
      DELETE ord_1 WHERE serial IS INITIAL.
      IF ord_1 IS NOT INITIAL.
        SORT ord_1 BY matnr serial.
        DATA(lv_line) = lines( ord_1 ).
        DELETE ADJACENT DUPLICATES FROM ord_1 COMPARING matnr serial.
        DATA(lv_line1) = lines( ord_1 ).
        IF lv_line <> lv_line1.
          lv_msg = |Please remove duplicate serial number|.
          APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

          APPEND VALUE #( %tky        = gfs_header-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_conf_hdr.
        ENDIF.
      ENDIF.

      LOOP AT ord INTO DATA(ls_ord_c) WHERE serial IS NOT INITIAL.
        SELECT SINGLE * FROM zdt_cont_ord
        WHERE matnr = @ls_ord_c-matnr AND serial = @ls_ord_c-serial AND shpflrno <> @gfs_header-shpflrno
        INTO @DATA(ls_ser_c).

        SELECT SINGLE * FROM zdt_confpost_ord
        WHERE refid = @ls_ord_c-id AND refitem = @ls_ord_c-item AND reford = @ls_ord_c-ord
          AND shpflrno = @ls_ord_c-shpflrno
        INTO @DATA(ls_ser_p_c).
        IF ls_ser_c IS NOT INITIAL AND ls_ser_p_c IS INITIAL.
          lv_msg = ls_ord_c-serial && | already exist in SF No | && ls_ord_c-shpflrno.
          APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_conf_hdr.

          APPEND VALUE #( %tky        = gfs_header-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_conf_hdr.
        ENDIF.
        CLEAR : ls_ord_c, ls_ser_c.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
