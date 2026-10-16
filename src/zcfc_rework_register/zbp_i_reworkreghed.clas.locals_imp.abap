CLASS lhc_zi_reworkreghed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_reworkreghed RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_reworkreghed RESULT result.

    METHODS updateheader FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_reworkreghed~updateheader.

    METHODS checkvalidation1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_reworkreghed~checkvalidation1.

    METHODS checkmandt FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_reworkreghed~checkmandt.




ENDCLASS.

CLASS lhc_zi_reworkreghed IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updateheader.

    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
    ENTITY zi_reworkreghed
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).


*       Plant
    SELECT SINGLE * FROM zi_plant_f4 WHERE plantcd = @gfs_header-plntcd
    INTO @DATA(loc_final1).

    IF sy-subrc = 0.
      gfs_header-plntnm = loc_final1-plantnm.
    ENDIF.

*       OperationCode
    SELECT SINGLE * FROM zi_operation WHERE oprcode = @gfs_header-oprcode
    INTO @DATA(loc_final2).

    IF sy-subrc = 0.
      gfs_header-oprname = loc_final2-oprname.
    ENDIF.

    MODIFY ENTITIES OF zi_reworkreghed IN LOCAL MODE
    ENTITY zi_reworkreghed
    UPDATE
    FIELDS ( plntnm oprname )
    WITH VALUE #( FOR key IN keys
    ( %tky = gfs_header-%tky
    plntnm = gfs_header-plntnm
    oprname = gfs_header-oprname
    %control-plntnm = if_abap_behv=>mk-on
    %control-oprname = if_abap_behv=>mk-on
    ) ).

  ENDMETHOD.

  METHOD checkvalidation1.

    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
      ENTITY zi_reworkreghed
      ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~id
      FROM zi_reworkreghed AS a
      WHERE a~plntcd = @gfs_header-plntcd
        AND a~oprcode = @gfs_header-oprcode
        AND a~reportyear = @gfs_header-reportyear
        AND a~reportmonth = @gfs_header-reportmonth
        AND a~id <> @gfs_header-id
      INTO @DATA(lv_comb_1).

    IF lv_comb_1 IS NOT INITIAL.

      APPEND VALUE #( %tky = gfs_header-%tky )
        TO failed-zi_reworkreghed.

      APPEND VALUE #(
        %tky        = gfs_header-%tky
        %state_area = 'Validate_Head'
        %msg        = new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     = |Plant,Oprn,Year & Month already used| )
      ) TO reported-zi_reworkreghed.

    ENDIF.

  ENDMETHOD.




  METHOD checkmandt.

    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
    ENTITY zi_reworkreghed
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF gfs_header IS INITIAL.
      RETURN.
    ENDIF.


    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
  ENTITY zi_reworkreghed BY \_item
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_item_1).

    LOOP AT lt_item_1 INTO DATA(ls_item_1).

** Material Code mandatory **

      IF ls_item_1-matcd IS INITIAL.

        APPEND VALUE #( %tky = ls_item_1-%tky )
          TO failed-zi_reworkreghed.

        APPEND VALUE #(
          %tky        = ls_item_1-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Material Code is mandatory| )
        ) TO reported-zi_reworkreghed.

      ENDIF.

** Work Details mandatory **

      IF ls_item_1-workdetls IS INITIAL.

        APPEND VALUE #( %tky = ls_item_1-%tky )
          TO failed-zi_reworkreghed.

        APPEND VALUE #(
          %tky        = ls_item_1-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Work Details is mandatory| )
        ) TO reported-zi_reworkreghed.

      ENDIF.

** Work Hours mandatory **

      IF ls_item_1-workmin IS INITIAL.

        APPEND VALUE #( %tky = ls_item_1-%tky )
          TO failed-zi_reworkregitm.

        APPEND VALUE #(
          %tky        = ls_item_1-%tky
          %state_area = 'Validate_Head'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Work Minutes is mandatory| )
        ) TO reported-zi_reworkreghed.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.


ENDCLASS.

CLASS lhc_zi_reworkregitm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_reworkregitm~updateitem.

   METHODS checkcomb1 FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_reworkregitm~checkcomb1.

    METHODS checkdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_reworkregitm~checkdate.


ENDCLASS.

CLASS lhc_zi_reworkregitm IMPLEMENTATION.

  METHOD updateitem.
    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
                ENTITY zi_reworkreghed
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_reworkreghed
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~product, a~productname
    FROM zi_plantwisemat_f4 AS a
    WHERE a~product = @gfs_item-matcd
    INTO @DATA(ls_comb1).

    IF sy-subrc = 0.
      gfs_item-matnm = ls_comb1-productname.
    ENDIF.


    MODIFY ENTITIES OF zi_reworkreghed IN LOCAL MODE
      ENTITY zi_reworkregitm
      UPDATE
      FIELDS ( matnm )
      WITH VALUE #( FOR key IN keys
                   ( %tky = gfs_item-%tky
                   matnm = gfs_item-matnm
                   %control-matnm = if_abap_behv=>mk-on
                   ) ).


  ENDMETHOD.

  METHOD checkcomb1.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
  READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
      ENTITY zi_reworkregitm
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_changed_items).

  LOOP AT lt_changed_items INTO DATA(ls_changed_item).

*--------------------------------------------------------------------*
* Read Header
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
      ENTITY zi_reworkregitm BY \_head
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
    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
      ENTITY zi_reworkreghed BY \_item
      ALL FIELDS
      WITH VALUE #(
        ( %tky = ls_header-%tky )
      )
      RESULT DATA(lt_all_items).

*--------------------------------------------------------------------*
* Check Duplicate Inside Same Document
*--------------------------------------------------------------------*
    LOOP AT lt_all_items INTO DATA(ls_existing_item).

      " Skip same item
      IF ls_existing_item-%tky = ls_changed_item-%tky.
        CONTINUE.
      ENDIF.

      IF ls_existing_item-matcd   = ls_changed_item-matcd
         AND ls_existing_item-rptdate = ls_changed_item-rptdate.

        APPEND VALUE #(
          %tky = ls_changed_item-%tky

          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = |Duplicate Report Date & Material are not allowed|
                 )

          %element-rptdate = if_abap_behv=>mk-on
          %element-matcd   = if_abap_behv=>mk-on

        ) TO reported-zi_reworkregitm.

        APPEND VALUE #(
          %tky = ls_changed_item-%tky
        ) TO failed-zi_reworkregitm.

        EXIT.

      ENDIF.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.

  METHOD checkdate.

  DATA:
    lv_month_num TYPE c LENGTH 2,
    lv_year      TYPE c LENGTH 4,
    lv_month     TYPE c LENGTH 2,
    lv_rptdate   TYPE c LENGTH 8.

  " Read Item Data
  READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
      ENTITY zi_reworkregitm
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item).

  LOOP AT lt_item INTO DATA(ls_item).

    " Read Parent Header using association
    READ ENTITIES OF zi_reworkreghed IN LOCAL MODE
        ENTITY zi_reworkregitm BY \_head
        ALL FIELDS
        WITH VALUE #(
          ( %tky = ls_item-%tky )
        )
        RESULT DATA(lt_header).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    CLEAR: lv_month_num,
           lv_year,
           lv_month,
           lv_rptdate.

    CASE ls_header-reportmonth.
      WHEN 'JANUARY'.   lv_month_num = '01'.
      WHEN 'FEBRUARY'.  lv_month_num = '02'.
      WHEN 'MARCH'.     lv_month_num = '03'.
      WHEN 'APRIL'.     lv_month_num = '04'.
      WHEN 'MAY'.       lv_month_num = '05'.
      WHEN 'JUNE'.      lv_month_num = '06'.
      WHEN 'JULY'.      lv_month_num = '07'.
      WHEN 'AUGUST'.    lv_month_num = '08'.
      WHEN 'SEPTEMBER'. lv_month_num = '09'.
      WHEN 'OCTOBER'.   lv_month_num = '10'.
      WHEN 'NOVEMBER'.  lv_month_num = '11'.
      WHEN 'DECEMBER'.  lv_month_num = '12'.
    ENDCASE.

    lv_rptdate = ls_item-rptdate.

    lv_year  = lv_rptdate(4).
    lv_month = lv_rptdate+4(2).

    IF lv_year <> ls_header-reportyear
       OR lv_month <> lv_month_num.

      APPEND VALUE #(
        %tky = ls_item-%tky

        %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = |Report Date must belong to { ls_header-reportmonth } { ls_header-reportyear }|
               )

        %element-rptdate = if_abap_behv=>mk-on

      ) TO reported-zi_reworkregitm.

      APPEND VALUE #(
        %tky = ls_item-%tky
      ) TO failed-zi_reworkregitm.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
