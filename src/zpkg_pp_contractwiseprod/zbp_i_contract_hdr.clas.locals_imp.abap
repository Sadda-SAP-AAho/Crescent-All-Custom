CLASS lhc_zi_contract_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_contract_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_contract_hdr RESULT result.

    METHODS printr FOR MODIFY
      IMPORTING keys FOR ACTION zi_contract_hdr~printr RESULT result.

    METHODS updateprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_contract_hdr~updateprint RESULT result.

    METHODS checkdet FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_contract_hdr~checkdet.


ENDCLASS.

CLASS lhc_zi_contract_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD printr.
    READ ENTITIES OF zi_contract_hdr IN LOCAL MODE
                ENTITY zi_contract_hdr
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT DATA(header)
                " TODO: variable is assigned but never used (ABAP cleaner)
                FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.


        MODIFY ENTITIES OF zi_contract_hdr IN LOCAL MODE
                ENTITY zi_contract_hdr
                UPDATE
                FIELDS ( printrep )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 printrep = 'Y'
                                  %control-printrep   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_contract_hdr IN LOCAL MODE
         ENTITY  zi_contract_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.


  METHOD updateprint.
    READ ENTITIES OF zi_contract_hdr IN LOCAL MODE
               ENTITY zi_contract_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    READ ENTITY zi_contract_hdr " IN LOCAL MODE
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(itmdet).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    " DATA(gfs_item)   = VALUE #( itmdet[ 1 ]  OPTIONAL ).

    LOOP AT itmdet INTO DATA(gfs_item).

      MODIFY ENTITIES OF zi_contract_hdr IN LOCAL MODE
                  ENTITY zi_contract_itm
                  DELETE FROM VALUE #( ( cont   = gfs_item-cont
                                         dept   = gfs_item-dept
                                         opr    = gfs_item-opr
                                         plant  = gfs_item-plant
                                         matnr  = gfs_item-matnr ) ).
      CLEAR : gfs_item.
    ENDLOOP.

    DATA: lv_start TYPE datum.
    DATA: lv_end TYPE datum.
    DATA: lv_date TYPE datum.
    lv_start = gfs_header-shpflrdt.               "" ++ 26/05/2025
    lv_end   = lv_start + 6.
    lv_date = lv_start.

    DATA : ls_item2 TYPE zi_contract_itm,
           lt_item  TYPE STANDARD TABLE OF zi_contract_itm,
           ls_item3 LIKE LINE OF lt_item.

    "" ++ 26/05/2025

    SELECT shpflrdt,opr,plant,dept,cont,matnr,reqqty,materialbaseunit
    FROM zcds_perdayview
    WHERE shpflrdt BETWEEN @lv_start AND @lv_end
*    AND   plant = @gfs_header-plant
    AND   cont  = @gfs_header-cont
    AND   dept  = @gfs_header-dept
    AND opr = @gfs_header-opr
    INTO TABLE @DATA(lt_qty).
    DATA(lt_qtyfinal) = lt_qty[].
    SORT lt_qtyfinal BY matnr.
    DELETE ADJACENT DUPLICATES FROM lt_qtyfinal COMPARING matnr.

    SELECT DISTINCT a~product,a~productdescription , b~netweight
    FROM @lt_qtyfinal AS c
    INNER JOIN i_productdescription AS a ON a~product = c~matnr
    INNER JOIN i_product AS b ON b~product = a~product
    WHERE a~language = 'E'
    INTO TABLE @DATA(lt_mat).

    SELECT b~matnr, b~plant, b~activitytype, b~costcenteractivitytypeformula, b~calculatedcost
    FROM @lt_qtyfinal AS a
    INNER JOIN zcds_activity1 AS b
    ON b~matnr = a~matnr
    AND b~plant = a~plant

    AND b~cont = a~cont
    AND b~dept = a~dept
    AND b~opr = a~opr

    AND a~shpflrdt BETWEEN b~validitystartdate AND b~validityenddate
*    WHERE a~plant = @gfs_header-plant

    AND a~cont = @gfs_header-cont
    AND a~dept = @gfs_header-dept
    AND a~opr = @gfs_header-opr

    GROUP BY b~matnr,
           b~plant,
           b~activitytype,
           b~costcenteractivitytypeformula,
           b~calculatedcost
    INTO TABLE @DATA(lt_labor).
    SORT lt_labor BY matnr activitytype plant.
    DELETE ADJACENT DUPLICATES FROM lt_labor COMPARING matnr activitytype plant.


    ""++ 26/05/2025
    LOOP AT lt_qtyfinal INTO DATA(ls_qtyfinal).
      gfs_item-matnr = ls_qtyfinal-matnr.
      gfs_item-opr   = ls_qtyfinal-opr.
      gfs_item-cont  = ls_qtyfinal-cont.
      gfs_item-dept  = ls_qtyfinal-dept.
      gfs_item-plant = ls_qtyfinal-plant.
      gfs_item-materialbaseunit = ls_qtyfinal-materialbaseunit.
      READ TABLE lt_qty INTO DATA(ls_qty1) WITH KEY matnr = ls_qtyfinal-matnr shpflrdt = lv_start.
      IF sy-subrc = 0.
        gfs_item-day1qty = ls_qty1-reqqty.
      ENDIF.
      CLEAR: ls_qty1.

      lv_date = lv_start + 1.
      READ TABLE lt_qty INTO DATA(ls_qty2) WITH KEY   matnr = ls_qtyfinal-matnr shpflrdt = lv_date .
      IF sy-subrc = 0.
        gfs_item-day2qty = ls_qty2-reqqty.
      ENDIF.
      CLEAR: ls_qty2.

      lv_date = lv_start + 2.
      READ TABLE lt_qty INTO DATA(ls_qty3) WITH KEY   matnr = ls_qtyfinal-matnr shpflrdt = lv_date .
      IF sy-subrc = 0.
        gfs_item-day3qty = ls_qty3-reqqty.
      ENDIF.
      CLEAR: ls_qty3.

      lv_date = lv_start + 3.
      READ TABLE lt_qty INTO DATA(ls_qty4) WITH KEY   matnr = ls_qtyfinal-matnr shpflrdt = lv_date.
      IF sy-subrc = 0.
        gfs_item-day4qty = ls_qty4-reqqty.
      ENDIF.
      CLEAR: ls_qty4.

      lv_date = lv_start + 4.
      READ TABLE lt_qty INTO DATA(ls_qty5) WITH KEY   matnr = ls_qtyfinal-matnr shpflrdt = lv_date.
      IF sy-subrc = 0.
        gfs_item-day5qty = ls_qty5-reqqty.
      ENDIF.
      CLEAR: ls_qty5.

      lv_date = lv_start + 5.
      READ TABLE lt_qty INTO DATA(ls_qty6) WITH KEY   matnr = ls_qtyfinal-matnr shpflrdt = lv_date.
      IF sy-subrc = 0.
        gfs_item-day6qty = ls_qty6-reqqty.
      ENDIF.
      CLEAR: ls_qty6.

      lv_date = lv_start + 6.
      READ TABLE lt_qty INTO DATA(ls_qty7) WITH KEY   matnr = ls_qtyfinal-matnr shpflrdt = lv_date.
      IF sy-subrc = 0.
        gfs_item-day7qty = ls_qty7-reqqty.
      ENDIF.
      CLEAR: ls_qty7.

      gfs_item-totalperdayqty = gfs_item-day1qty + gfs_item-day2qty + gfs_item-day3qty + gfs_item-day4qty
                                + gfs_item-day5qty + gfs_item-day6qty + gfs_item-day7qty.

      READ TABLE lt_mat INTO DATA(ls_mat) WITH KEY product = ls_qtyfinal-matnr.
      IF sy-subrc = 0.
        gfs_item-itemname = ls_mat-productdescription.
        gfs_item-netweight = ls_mat-netweight.
      ENDIF.
      CLEAR: ls_mat.

      gfs_item-qtyinkg = ( gfs_item-day1qty + gfs_item-day2qty + gfs_item-day3qty + gfs_item-day4qty
                                + gfs_item-day5qty + gfs_item-day6qty + gfs_item-day7qty ) * gfs_item-netweight.

      ls_item3 = CORRESPONDING #( gfs_item ).
      APPEND ls_item3 TO lt_item.
      CLEAR: gfs_item,ls_item3.
    ENDLOOP.

    IF lt_item[] IS INITIAL.
      MODIFY ENTITIES OF zi_contract_hdr IN LOCAL MODE
                   ENTITY zi_contract_hdr
                   CREATE BY \_item
                   FROM VALUE #( ( cont = gfs_header-cont
                                   opr  = gfs_header-opr
                                   dept = gfs_header-dept
                                   plant = gfs_header-plant
                                  %target = VALUE #( (     %cid                = 'DELETE' "ls_itmfinal-matnr
                                                           itemname            = 'DELETE'
                                                           %control-itemname   = if_abap_behv=>mk-on

                                                    ) ) ) )
                                  MAPPED FINAL(ls_mapped1)
                                  FAILED FINAL(ls_failed1)
                                  REPORTED FINAL(ls_reported1).
    ENDIF.


    LOOP AT lt_item INTO DATA(ls_itmfinal).

      MODIFY ENTITIES OF zi_contract_hdr IN LOCAL MODE
                   ENTITY zi_contract_hdr
                   CREATE BY \_item
                   FROM VALUE #( ( cont = ls_itmfinal-cont
                                   opr  = ls_itmfinal-opr
                                   dept = ls_itmfinal-dept
                                   plant = ls_itmfinal-plant
                                  %target = VALUE #( (     %cid                = ls_itmfinal-matnr
                                                           matnr               = ls_itmfinal-matnr
                                                           opr                 = ls_itmfinal-opr
                                                           cont                = ls_itmfinal-cont
                                                           dept                = ls_itmfinal-dept
                                                           plant               = ls_itmfinal-plant
                                                           materialbaseunit    = ls_itmfinal-materialbaseunit
                                                           day1qty             = ls_itmfinal-day1qty
                                                           day2qty             = ls_itmfinal-day2qty
                                                           day3qty             = ls_itmfinal-day3qty
                                                           day4qty             = ls_itmfinal-day4qty
                                                           day5qty             = ls_itmfinal-day5qty
                                                           day6qty             = ls_itmfinal-day6qty
                                                           day7qty             = ls_itmfinal-day7qty
                                                           totalperdayqty      = ls_itmfinal-totalperdayqty
                                                           qtyinkg             = ls_itmfinal-qtyinkg
                                                           netweight           = ls_itmfinal-netweight
                                                           itemname            = ls_itmfinal-itemname
                                                           %control-matnr         = if_abap_behv=>mk-on
                                                           %control-opr         = if_abap_behv=>mk-on
                                                           %control-cont         = if_abap_behv=>mk-on
                                                           %control-dept         = if_abap_behv=>mk-on
                                                           %control-plant         = if_abap_behv=>mk-on
                                                           %control-materialbaseunit  = if_abap_behv=>mk-on
                                                           %control-day1qty         = if_abap_behv=>mk-on
                                                           %control-day2qty         = if_abap_behv=>mk-on
                                                           %control-day3qty         = if_abap_behv=>mk-on
                                                           %control-day4qty         = if_abap_behv=>mk-on
                                                           %control-day5qty         = if_abap_behv=>mk-on
                                                           %control-day6qty         = if_abap_behv=>mk-on
                                                           %control-day7qty         = if_abap_behv=>mk-on
                                                           %control-totalperdayqty  = if_abap_behv=>mk-on
                                                           %control-qtyinkg         = if_abap_behv=>mk-on
                                                           %control-itemname        = if_abap_behv=>mk-on
                                                           %control-netweight       = if_abap_behv=>mk-on

                                                    ) ) ) )
                                  MAPPED FINAL(ls_mappe21)
                                  FAILED FINAL(ls_failed21)
                                  REPORTED FINAL(ls_reported21).
    ENDLOOP.
    ""eoc 26/05/2025

    READ ENTITY zi_contract_hdr " IN LOCAL MODE
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(itmdetfinal).


    LOOP AT itmdetfinal INTO DATA(ls_item) .

      READ TABLE lt_labor INTO DATA(ls_labor) WITH KEY matnr = ls_item-matnr activitytype = gfs_header-laboritemno1.
      IF ls_labor IS NOT INITIAL.
        ls_item-activity1 = ls_labor-calculatedcost.
        IF ( ls_labor-costcenteractivitytypeformula = 'ZCON1' OR ls_labor-costcenteractivitytypeformula = 'ZCON2' OR
            ls_labor-costcenteractivitytypeformula = 'ZCON3' OR ls_labor-costcenteractivitytypeformula = 'ZCON4' OR
            ls_labor-costcenteractivitytypeformula = 'ZCON5' ).
          ls_item-activity1amt = ls_labor-calculatedcost * ls_item-qtyinkg.
        ENDIF.
        IF ( ls_labor-costcenteractivitytypeformula = 'ZCON6' OR ls_labor-costcenteractivitytypeformula = 'ZCON7'  ) .
          ls_item-activity1amt = ( ls_labor-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
        IF ( ls_labor-costcenteractivitytypeformula = ls_labor-activitytype ).
          ls_item-activity1amt = ( ls_labor-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
      ELSE.
        ls_item-activity1 = '0.000'.
        ls_item-activity1amt = '0.000'.
      ENDIF.
      CLEAR: ls_labor.

      READ TABLE lt_labor INTO DATA(ls_labor1) WITH KEY matnr = ls_item-matnr activitytype = gfs_header-laboritemno2.
      IF ls_labor1 IS NOT INITIAL.
        ls_item-activity2 = ls_labor1-calculatedcost.
        IF ( ls_labor1-costcenteractivitytypeformula = 'ZCON1' OR ls_labor1-costcenteractivitytypeformula = 'ZCON2' OR
         ls_labor1-costcenteractivitytypeformula = 'ZCON3' OR ls_labor1-costcenteractivitytypeformula = 'ZCON4' OR
         ls_labor1-costcenteractivitytypeformula = 'ZCON5' ).
          ls_item-activity2amt = ls_labor1-calculatedcost * ls_item-qtyinkg.
        ENDIF.
        IF ( ls_labor1-costcenteractivitytypeformula = 'ZCON6' OR ls_labor1-costcenteractivitytypeformula = 'ZCON7'  ) .
          ls_item-activity2amt = ( ls_labor1-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
        IF ( ls_labor1-costcenteractivitytypeformula = ls_labor1-activitytype ).
          ls_item-activity2amt = ( ls_labor1-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
      ELSE.
        ls_item-activity2 = '0.000'.
        ls_item-activity2amt = '0.000'.
      ENDIF.
      CLEAR: ls_labor1.

      READ TABLE lt_labor INTO DATA(ls_labor3) WITH KEY matnr = ls_item-matnr activitytype = gfs_header-laboritemno3.
      IF ls_labor3 IS NOT INITIAL.
        ls_item-activity3 = ls_labor3-calculatedcost.
        IF ( ls_labor3-costcenteractivitytypeformula = 'ZCON1' OR ls_labor3-costcenteractivitytypeformula = 'ZCON2' OR
          ls_labor3-costcenteractivitytypeformula = 'ZCON3' OR ls_labor3-costcenteractivitytypeformula = 'ZCON4' OR
          ls_labor3-costcenteractivitytypeformula = 'ZCON5' ).
          ls_item-activity3amt = ls_labor3-calculatedcost * ls_item-qtyinkg.
        ENDIF.
        IF ( ls_labor3-costcenteractivitytypeformula = 'ZCON6' OR ls_labor3-costcenteractivitytypeformula = 'ZCON7'  ) .
          ls_item-activity3amt = ( ls_labor3-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
        IF ( ls_labor3-costcenteractivitytypeformula = ls_labor3-activitytype ).
          ls_item-activity3amt = ( ls_labor3-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
      ELSE.
        ls_item-activity3 = '0.000'.
        ls_item-activity3amt = '0.000'.
      ENDIF.
      CLEAR: ls_labor3.

      READ TABLE lt_labor INTO DATA(ls_labor4) WITH KEY matnr = ls_item-matnr activitytype = gfs_header-laboritemno4.
      IF ls_labor4 IS NOT INITIAL.
        ls_item-activity4 = ls_labor4-calculatedcost.
        IF ( ls_labor4-costcenteractivitytypeformula = 'ZCON1' OR ls_labor4-costcenteractivitytypeformula = 'ZCON2' OR
         ls_labor4-costcenteractivitytypeformula = 'ZCON3' OR ls_labor4-costcenteractivitytypeformula = 'ZCON4' OR
         ls_labor4-costcenteractivitytypeformula = 'ZCON5' ).
          ls_item-activity4amt = ls_labor4-calculatedcost * ls_item-qtyinkg.
        ENDIF.
        IF ( ls_labor4-costcenteractivitytypeformula = 'ZCON6' OR ls_labor4-costcenteractivitytypeformula = 'ZCON7'  ) .
          ls_item-activity4amt = ( ls_labor4-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
        IF ( ls_labor4-costcenteractivitytypeformula = ls_labor4-activitytype ).
          ls_item-activity4amt = ( ls_labor4-calculatedcost * ls_item-totalperdayqty ).
        ENDIF.
      ELSE.
        ls_item-activity4 = '0.000'.
        ls_item-activity4amt = '0.000'.
      ENDIF.
      CLEAR: ls_labor4.


      ls_item-totalamt = ls_item-activity1amt + ls_item-activity2amt + ls_item-activity3amt + ls_item-activity4amt.



      MODIFY ENTITIES OF zi_contract_hdr   IN LOCAL MODE
                        ENTITY zi_contract_itm
                        UPDATE
                        FIELDS ( activity1 activity1amt activity2 activity2amt activity3 activity3amt
                                 activity4 activity4amt totalamt )
                        WITH VALUE #( FOR key IN keys
                                      ( %tky                = ls_item-%tky
                                        activity1           = ls_item-activity1
                                        activity1amt        = ls_item-activity1amt
                                        activity2           = ls_item-activity2
                                        activity2amt        = ls_item-activity2amt
                                        activity3           = ls_item-activity3
                                        activity3amt        = ls_item-activity3amt
                                        activity4           = ls_item-activity4
                                        activity4amt        = ls_item-activity4amt
                                        totalamt            = ls_item-totalamt
                                        %control-activity1       = if_abap_behv=>mk-on
                                        %control-activity1amt      = if_abap_behv=>mk-on
                                        %control-activity2       = if_abap_behv=>mk-on
                                        %control-activity2amt      = if_abap_behv=>mk-on
                                        %control-activity3       = if_abap_behv=>mk-on
                                        %control-activity3amt      = if_abap_behv=>mk-on
                                        %control-activity4       = if_abap_behv=>mk-on
                                        %control-activity4amt    = if_abap_behv=>mk-on
                                        %control-totalamt        = if_abap_behv=>mk-on

                                         ) ).

    ENDLOOP.

    READ ENTITIES OF zi_contract_hdr IN LOCAL MODE
        ENTITY  zi_contract_hdr
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

  ENDMETHOD.

  METHOD checkdet.
    READ ENTITIES OF zi_contract_hdr IN LOCAL MODE
                   ENTITY zi_contract_hdr
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header1).

    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).


    IF ( gfs_header1-shpflrdt IS INITIAL ).

      DATA(lv_msg) = |Posting Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_contract_hdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_contract_hdr.
    ENDIF.

    IF ( gfs_header1-laboritemno1 IS INITIAL AND gfs_header1-laboritemno2 IS INITIAL AND
        gfs_header1-laboritemno3 IS INITIAL AND gfs_header1-laboritemno4 IS INITIAL ).

      DATA(lv_msg1) = |Please Enter Anyone Of The Labor Item|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_contract_hdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_contract_hdr.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_contract_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_contract_hdr IMPLEMENTATION.

  METHOD save_modified.

    DATA : ls_hdr  TYPE zdt_contract_hdr.
    DATA : ls_item TYPE zdt_contract_itm,
           lv_flag TYPE flag.

    CLEAR : lv_flag.
    IF create IS NOT INITIAL.
      DATA(lt_item1) = create-zi_contract_itm.
      READ TABLE lt_item1 INTO DATA(ls_item3) INDEX 1.
      DELETE FROM zdt_contract_itm
      WHERE cont = @ls_item3-cont AND dept = @ls_item3-dept
        AND plant = @ls_item3-plant AND opr = @ls_item3-opr.
      CLEAR : ls_item3.
      lv_flag = 'X'.
      READ TABLE lt_item1 INTO DATA(ls_item_d) WITH KEY itemname = 'DELETE'.
      IF ls_item_d IS INITIAL.
        LOOP AT lt_item1 INTO DATA(ls_item2).
          MOVE-CORRESPONDING ls_item2 TO ls_item.
          MODIFY zdt_contract_itm FROM @ls_item.
          CLEAR : ls_item2 , ls_item.
        ENDLOOP.
      ENDIF.
      CLEAR : ls_item_d.
    ENDIF.

    IF update IS NOT INITIAL.

      DATA(lt_head) = update-zi_contract_hdr.
      DATA(lt_item) = update-zi_contract_itm.

      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      SELECT SINGLE * FROM zdr_contract_hdr
      WHERE cont = @wa_head-cont
        AND dept = @wa_head-dept
        AND plant = @wa_head-plant
        AND opr   = @wa_head-opr
      INTO @DATA(ls_det).

*      MOVE-CORRESPONDING wa_head TO ls_hdr.
*      MODIFY zdt_contract_hdr FROM @ls_hdr.
      CLEAR : ls_hdr.
      MOVE-CORRESPONDING ls_det TO ls_hdr.
      MODIFY zdt_contract_hdr FROM @ls_hdr.
      IF lv_flag <> 'X'.
        READ TABLE lt_item INTO DATA(ls_item4) INDEX 1.
        DELETE FROM zdt_contract_itm
        WHERE cont = @ls_item4-cont AND dept = @ls_item4-dept
          AND plant = @ls_item4-plant AND opr = @ls_item4-opr.
        CLEAR : ls_item4.
      ENDIF.

      READ TABLE lt_item1 INTO ls_item_d WITH KEY itemname = 'DELETE'.
      IF ls_item_d IS INITIAL.
        LOOP AT lt_item INTO DATA(ls_item1).
          MOVE-CORRESPONDING ls_item1 TO ls_item.
          MODIFY zdt_contract_itm FROM @ls_item.
          CLEAR : ls_item1 , ls_item.
        ENDLOOP.
      ENDIF.
      CLEAR : ls_item_d.

      DATA: lv_printq TYPE char32.

      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.

      IF wa_head-printrep = 'Y' AND ( wa_head-laboritemno1 IS NOT INITIAL OR wa_head-laboritemno2 IS NOT INITIAL
                                      OR wa_head-laboritemno3 IS NOT INITIAL OR wa_head-laboritemno4 IS NOT INITIAL ).

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_REPPRINT' ) .

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'CONTRACTWISEPROD' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                  lo_store->set_schema(
*                    iv_form_name = 'CONTRACTWISEPROD'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'SHPFLRDT' ]-value = lt_head[ 1 ]-shpflrdt.
            lt_keys[ name = 'OPR' ]-value = lt_head[ 1 ]-opr.
            lt_keys[ name = 'CONT' ]-value = lt_head[ 1 ]-cont.
            lt_keys[ name = 'DEPT' ]-value = lt_head[ 1 ]-dept.
            lt_keys[ name = 'PLANT' ]-value = lt_head[ 1 ]-plant.

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY.
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'CONTRACTWISEPROD'
              iv_template_name = 'CONTRACTWISEPROD'
            ).
*        cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml
*                                              iv_xdp_layout   = ls_template-xdp_template
*                                              iv_locale       = 'en_US'
*                                              is_options      = VALUE #(
*                                                          trace_level = 4 )
*                                    IMPORTING ev_pdf          = DATA(lv_pdf01)
*                                              ev_trace_string = DATA(lv_trace01)
*                                               ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'TAXINVDOM'
                iv_xml_data     = lv_xml
                iv_xdp_layout   = ls_template-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace)
                ev_pdl          = DATA(lv_pdf)
            ).

            DATA: lv_text TYPE char120.
            lv_text = |CONTRACTOR WISE PRODUCTION REPORT | && lt_head[ 1 ]-cont.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'TAXINVDOM'
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_text
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
