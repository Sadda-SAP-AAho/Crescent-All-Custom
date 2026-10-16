CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_customer_name FOR DETERMINE ON SAVE
      IMPORTING keys FOR item~get_customer_name.

    METHODS get_plant_name FOR DETERMINE ON SAVE
      IMPORTING keys FOR item~get_plant_name.

    METHODS get_mat_name FOR DETERMINE ON SAVE
      IMPORTING keys FOR item~get_mat_name.

    METHODS validfiscal FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~validfiscal.


ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD get_customer_name.


    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
      ENTITY item FIELDS ( customer_code plantcode matcode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(datasales).


    LOOP AT datasales ASSIGNING FIELD-SYMBOL(<ls_name>).


      SELECT SINGLE businesspartnerfullname
        FROM i_businesspartner
        WHERE businesspartner = @<ls_name>-customer_code
        INTO @DATA(lv_name).


      IF sy-subrc < 1.
        MODIFY ENTITIES OF z_i_sales_commitment IN LOCAL MODE
          ENTITY item
          UPDATE
          FIELDS ( customer_name )
          WITH VALUE #( ( %tky = <ls_name>-%tky customer_name = lv_name ) ).
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD get_plant_name.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
        ENTITY item FIELDS ( plantcode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(datasales1).


    LOOP AT datasales1 ASSIGNING FIELD-SYMBOL(<ls_name>).


      SELECT SINGLE plantname
        FROM i_plant
        WHERE plant = @<ls_name>-plantcode
        INTO @DATA(lv_name1).


      IF sy-subrc < 1.
        MODIFY ENTITIES OF z_i_sales_commitment IN LOCAL MODE
          ENTITY item
          UPDATE
          FIELDS ( plantname )
          WITH VALUE #( ( %tky = <ls_name>-%tky plantname = lv_name1 ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_mat_name.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
        ENTITY item FIELDS ( matcode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(datasales2).


    LOOP AT datasales2 ASSIGNING FIELD-SYMBOL(<ls_name>).


      SELECT SINGLE productname
        FROM i_producttext
        WHERE product = @<ls_name>-matcode
        INTO @DATA(lv_name2).


      IF sy-subrc < 1.
        MODIFY ENTITIES OF z_i_sales_commitment IN LOCAL MODE
          ENTITY item
          UPDATE
          FIELDS ( matname )
          WITH VALUE #( ( %tky = <ls_name>-%tky matname = lv_name2 ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD validfiscal.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY item FIELDS (  customer_code plantname  )
       WITH CORRESPONDING #( keys )
       RESULT DATA(custdata).


    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY sales FIELDS ( fiscal_year  )
       WITH CORRESPONDING #( keys )
       RESULT DATA(fiscalyear).



    LOOP AT custdata ASSIGNING FIELD-SYMBOL(<ls_cust>).

      LOOP AT fiscalyear ASSIGNING FIELD-SYMBOL(<ls_fiscal>).

        SELECT  requestuuid,fiscal_year
          FROM zsales_commitmnt
          WHERE fiscal_year       = @<ls_fiscal>-fiscal_year
          INTO  TABLE @DATA(lt_data).

      ENDLOOP.

*          ////Old logic////

*      " Check if Customer Code is missing
*      IF <ls_cust>-customer_code IS INITIAL.
*        APPEND VALUE #( %tky = <ls_fiscal>-%tky ) TO failed-sales.
*
*        APPEND VALUE #(
*          %tky = <ls_fiscal>-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = |Customer Code is Mandatory Field|
*                 )
*        ) TO reported-sales.
*      ENDIF.
*
*      " Check if Plant Code is missing
*      IF <ls_cust>-plantcode IS INITIAL.
*        APPEND VALUE #( %tky = <ls_fiscal>-%tky ) TO failed-sales.
*
*        APPEND VALUE #(
*          %tky = <ls_fiscal>-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = |Plant Code is Mandatory Field|
*                 )
*        ) TO reported-sales.
*      ENDIF.
*
*      " Check if Material Code is missing
*      IF <ls_cust>-matcode IS INITIAL.
*        APPEND VALUE #( %tky = <ls_fiscal>-%tky ) TO failed-sales.
*
*        APPEND VALUE #(
*          %tky = <ls_fiscal>-%tky
*          %msg = new_message_with_text(
*                   severity = if_abap_behv_message=>severity-error
*                   text     = |Material Code is Mandatory Field|
*                 )
*        ) TO reported-sales.
*      ENDIF.

*          ////Old logic////

      IF lt_data IS NOT INITIAL.


        SELECT requestuuid
          FROM zsales_commt_itm
          FOR ALL ENTRIES IN @lt_data
          WHERE requestuuid = @lt_data-requestuuid
          AND customer_code = @<ls_cust>-customer_code
          AND plantname = @<ls_cust>-plantname
          AND matcode = @<ls_cust>-matcode
          INTO TABLE @DATA(lt_item).



        IF lt_item IS NOT INITIAL.

          APPEND VALUE #( %tky = <ls_fiscal>-%tky ) TO failed-sales.

          APPEND VALUE #(
            %tky = <ls_fiscal>-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text = |Customer, Plant & Material cannot be repeated|
                   )
          ) TO reported-sales.


        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_sales DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR sales RESULT result.

    METHODS determinedocnum FOR DETERMINE ON SAVE
      IMPORTING keys FOR sales~determinedocnum.

    METHODS get_sales_employee_name FOR DETERMINE ON SAVE
      IMPORTING keys FOR sales~get_sales_employee_name.

    METHODS validatcust FOR VALIDATE ON SAVE
      IMPORTING keys FOR sales~validatcust.

    METHODS validprodplan FOR VALIDATE ON SAVE
      IMPORTING keys FOR sales~validprodplan.

    METHODS validsalestrgt FOR VALIDATE ON SAVE
      IMPORTING keys FOR sales~validsalestrgt.

    METHODS validdesptrgt FOR VALIDATE ON SAVE
      IMPORTING keys FOR sales~validdesptrgt.


ENDCLASS.

CLASS lhc_sales IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determinedocnum.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
           ENTITY z_i_sales_commitment
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-docnum IS INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-created_by = sy-uname.
      gfs_header-created_at = lv_date.

      SELECT MAX( keyid ) AS keyid FROM z_i_sales_commitment WHERE fiscal_year = @gfs_header-fiscal_year
      INTO @DATA(lv_keyid).

      lv_keyid = lv_keyid + 1.
      gfs_header-keyid = lv_keyid.
      gfs_header-docnum = gfs_header-fiscal_year && lv_keyid.

      MODIFY ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY z_i_sales_commitment
       UPDATE
       FIELDS ( docnum keyid created_by created_at )
       WITH VALUE #( FOR key IN keys
                    ( %tky = gfs_header-%tky
                    docnum = gfs_header-docnum
                    keyid = gfs_header-keyid
                    created_by = gfs_header-created_by
                    created_at = gfs_header-created_at
                    %control-docnum = if_abap_behv=>mk-on
                    ) ).

    ENDIF.

  ENDMETHOD.

  METHOD get_sales_employee_name.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
        ENTITY sales FIELDS ( sales_employee_code )
        WITH CORRESPONDING #( keys )
        RESULT DATA(salesemp).


    LOOP AT salesemp ASSIGNING FIELD-SYMBOL(<saleemp>).


      SELECT SINGLE salesperson
        FROM ztmg_salesgrp
        WHERE salesgroup = @<saleemp>-sales_employee_code
        INTO @DATA(salesname).

      IF sy-subrc < 1.
        MODIFY ENTITIES OF z_i_sales_commitment IN LOCAL MODE
          ENTITY sales
          UPDATE
          FIELDS ( sales_employee_name )
          WITH VALUE #( ( %tky = <saleemp>-%tky sales_employee_name = salesname ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validatcust.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
      ENTITY sales FIELDS ( sales_employee_code fiscal_year  )
      WITH CORRESPONDING #( keys )
      RESULT DATA(salesdata).


    LOOP AT salesdata ASSIGNING FIELD-SYMBOL(<saledata>).


      IF <saledata>-sales_employee_code IS INITIAL.
        APPEND VALUE #( %tky = <saledata>-%tky ) TO failed-sales.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text = 'Sales Group is Mandatory Field'
                        ) ) TO reported-sales. " Report error message
      ENDIF.



      IF <saledata>-fiscal_year IS INITIAL.
        APPEND VALUE #( %tky = <saledata>-%tky ) TO failed-sales.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text = 'Fiscal Year is Manadatory Field'
                        ) ) TO reported-sales.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validprodplan.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY sales FIELDS ( commitment_type  )
       WITH CORRESPONDING #( keys )
       RESULT DATA(headerdata).

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY z_i_sales_commitment  BY \_item
         FIELDS (  customer_code plantcode matcode  )
         WITH CORRESPONDING #( keys )
         RESULT DATA(itemdata).

    LOOP AT headerdata ASSIGNING FIELD-SYMBOL(<ls_header>).

      LOOP AT itemdata ASSIGNING FIELD-SYMBOL(<ls_item>).

        IF <ls_header>-commitment_type = 'PRODUCTION PLAN'
        AND ( <ls_item>-customer_code IS INITIAL
           OR <ls_item>-plantcode IS INITIAL
           OR <ls_item>-matcode IS INITIAL ).

          APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-sales.

          APPEND VALUE #(
            %tky = <ls_item>-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = |Customer, Plant & Material Mandatory|
                   )
          ) TO reported-sales.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD validsalestrgt.

  READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY sales FIELDS ( commitment_type  )
       WITH CORRESPONDING #( keys )
       RESULT DATA(headerdata).

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
        ENTITY z_i_sales_commitment  BY \_item
         FIELDS (  customer_code profitcenter )
         WITH CORRESPONDING #( keys )
         RESULT DATA(itemdata).

    LOOP AT headerdata ASSIGNING FIELD-SYMBOL(<ls_header>).

      LOOP AT itemdata ASSIGNING FIELD-SYMBOL(<ls_item>).

        IF <ls_header>-commitment_type = 'SALES TARGET'
        AND ( <ls_item>-customer_code IS INITIAL
           OR <ls_item>-profitcenter IS INITIAL
            ).

          APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-sales.

          APPEND VALUE #(
            %tky = <ls_item>-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = |CustomerCode and ProfitCentre Mandatory|
                   )
          ) TO reported-sales.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD validdesptrgt.

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY sales FIELDS ( commitment_type  )
       WITH CORRESPONDING #( keys )
       RESULT DATA(headerdata).

    READ ENTITIES OF z_i_sales_commitment IN LOCAL MODE
       ENTITY z_i_sales_commitment  BY \_item
         FIELDS (  profitcenter  )
         WITH CORRESPONDING #( keys )
         RESULT DATA(itemdata).

    LOOP AT headerdata ASSIGNING FIELD-SYMBOL(<ls_header>).

      LOOP AT itemdata ASSIGNING FIELD-SYMBOL(<ls_item>).

        IF <ls_header>-commitment_type = 'DESPATCH TARGET'
        AND ( <ls_item>-profitcenter IS INITIAL ).


          APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-sales.

          APPEND VALUE #(
            %tky = <ls_item>-%tky
            %msg = new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     = |Profit Centre Mandatory|
                   )
          ) TO reported-sales.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
