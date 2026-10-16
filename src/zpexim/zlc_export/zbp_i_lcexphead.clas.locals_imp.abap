*-----------------------------------------------------------------------------------*
*  Export Lc Header
*-----------------------------------------------------------------------------------*
CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~headerdetails.

    METHODS rate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~rate.

    METHODS tenure FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~tenure.

    METHODS amendment FOR MODIFY
      IMPORTING keys FOR ACTION head~amendment.

    METHODS setout FOR MODIFY
      IMPORTING keys FOR ACTION head~setout RESULT result.

    METHODS deldata FOR MODIFY
      IMPORTING keys FOR ACTION head~deldata.

    METHODS checkamt FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~checkamt.

    METHODS updateheader FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~updateheader.

    METHODS get_dataupdate_f4 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~get_dataupdate_f4.


ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.
*-----------------------------------------------------------------------------------*
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(head)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed).

    DATA(gfs_head) = VALUE #( head[ 1 ]  OPTIONAL ).
*-----------------------------------------------------------------------------------*

    result = VALUE #( FOR ls_head IN head
                          ( %tky                = gfs_head-%tky

                            %action-amendment   = COND #( WHEN ls_head-lc_status = 'AMENDMENT'
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled
                                                         )
                            %field-amend_date   = COND #( WHEN ls_head-lc_status = 'AMENDMENT'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                         )
                            %field-amend_txt    = COND #( WHEN ls_head-lc_status = 'AMENDMENT'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                         )
                            %assoc-_item1        = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled
                                                         )
                            %assoc-_item2        = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled
                                                         )
                            %action-edit         = COND #( WHEN ls_head-lc_status = 'CLOSE'
                                                           THEN if_abap_behv=>fc-o-disabled
                                                           ELSE if_abap_behv=>fc-o-enabled
                                                         )
                            %delete              = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled
                                                         )
                            %action-setout        = if_abap_behv=>fc-o-disabled

                            %field-lc_status      = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_number      = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lifnr          = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_exp_date    = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_req_date    = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_open_dt     = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_tot_amt_fc  = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_appl        = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-lc_type        = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
*                            %field-lc_ut_rpt      = COND #( WHEN ls_head-lc_status = 'OPEN'
*                                                           THEN if_abap_behv=>fc-f-mandatory
*                                                           ELSE if_abap_behv=>fc-f-read_only
*                                                          )
                            %field-zterm          = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-payterm_description = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                            %field-tenure         = COND #( WHEN ls_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
*                            %field-grace          = COND #( WHEN ls_head-lc_status = 'OPEN'
*                                                           THEN if_abap_behv=>fc-f-mandatory
*                                                           ELSE if_abap_behv=>fc-f-read_only
*                                                          )
                      ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD rate.

***    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
***      ENTITY head
***      ALL FIELDS
***      WITH CORRESPONDING #( keys )
***      RESULT DATA(lt_header)
***      FAILED DATA(lt_header_failed).
***
***    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).
***
***      SELECT * FROM zcds_exchrate1
***          INTO TABLE @DATA(lt_rate).
***      SORT lt_rate BY sourcecurrency difference ASCENDING.
***      DELETE ADJACENT DUPLICATES FROM lt_rate COMPARING sourcecurrency.
***
***      LOOP AT lt_rate ASSIGNING FIELD-SYMBOL(<lfs>).
***        IF <lfs_header>-Currfc = <lfs>-sourcecurrency AND <lfs_header>-Currfc NE 'INR'.
***          <lfs_header>-wkurs = <lfs>-exchangerate.
***          <lfs_header>-lc_tot_amt_lc = <lfs>-exchangerate * <lfs_header>-lc_tot_amt_fc.
***        ELSEIF <lfs_header>-Currfc = 'INR' .
***          <lfs_header>-wkurs = '1.00000'.
***          <lfs_header>-lc_tot_amt_lc = <lfs_header>-lc_tot_amt_fc.
***        ENDIF.
***      ENDLOOP.
***
***      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
***            ENTITY head
***            UPDATE
***                FIELDS ( wkurs lc_tot_amt_lc  )
***                WITH VALUE #(
***                               ( %tky   = <lfs_header>-%tky
***                                 wkurs       = <lfs_header>-wkurs
***                                 lc_tot_amt_lc       = <lfs_header>-lc_tot_amt_lc
***
***                                 %control-wkurs  = if_abap_behv=>mk-on
***                                 %control-lc_tot_amt_lc  = if_abap_behv=>mk-on
***
***                               ) ).
***
***    ENDLOOP.

  ENDMETHOD.

  METHOD tenure.

*-----------------------------------------------------------------------------------*
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
      ENTITY head
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).
*-----------------------------------------------------------------------------------*
    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

      IF <lfs_header>-lc_exp_date IS NOT INITIAL AND <lfs_header>-lc_open_dt IS NOT INITIAL
      AND <lfs_header>-lc_open_dt <= <lfs_header>-lc_exp_date.
        <lfs_header>-tenure = ( <lfs_header>-lc_exp_date - <lfs_header>-lc_open_dt ) + 1.
      ENDIF.

      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
            ENTITY head
            UPDATE
                FIELDS ( tenure  )
                WITH VALUE #(
                               ( %tky   = <lfs_header>-%tky
                                 tenure = <lfs_header>-tenure
                                 %control-tenure  = if_abap_behv=>mk-on
                               ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD headerdetails.

    DATA: lv_flag TYPE char1.
*-----------------------------------------------------------------------------------*

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_header_failed).
*-----------------------------------------------------------------------------------*
    CLEAR: lv_flag .
    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

***      SELECT SINGLE * FROM zcds_so_details
***        WHERE salesorder = @<lfs_header>-so
***        INTO @DATA(ls_so_det).
***      IF sy-subrc = 0.
***        <lfs_header>-ekorg       = ls_so_det-salesorganization.
***        <lfs_header>-lifnr       = ls_so_det-soldtoparty.
***        <lfs_header>-div         = ls_so_det-plant.
***        <lfs_header>-vendor_name = ls_so_det-customerfullname.
***      ENDIF.
***      IF <lfs_header>-lc_req_date IS INITIAL.
***        <lfs_header>-lc_req_date = sy-datlo.
***      ENDIF.

      IF <lfs_header>-version IS INITIAL.
        <lfs_header>-version = '1'.
        lv_flag = 'X' .
      ENDIF.

      IF <lfs_header>-lc_status IS INITIAL.
        <lfs_header>-lc_status = 'OPEN'.
        lv_flag = 'X' .
      ENDIF.

      IF <lfs_header>-ekorg IS INITIAL.
        <lfs_header>-ekorg = <lfs_header>-companycode .
        lv_flag = 'X' .
      ENDIF.

      IF  lv_flag = 'X' .
        MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( status version ekorg lifnr div vendor_name lc_req_date currinr )
               WITH VALUE #( ( %tky                 = <lfs_header>-%tky
                               lc_status            = <lfs_header>-lc_status
                               version              = <lfs_header>-version
                               ekorg                = <lfs_header>-ekorg
                            ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD amendment.

    DATA: lv_id        TYPE zi_lcexphead-id.
    DATA: lt_lcexphead TYPE TABLE FOR CREATE zi_lcexphead,
          lt_bdetails  TYPE TABLE FOR CREATE zi_lcexphead\_item1,
          lt_delivery  TYPE TABLE FOR CREATE zi_lcexphead\_item2.
*-----------------------------------------------------------------------------------*
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
     ENTITY head BY \_item1
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT FINAL(lt_bdetail).

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
    ENTITY head BY \_item2
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_del).

    TRY.
        lv_id = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
    ENDTRY.

    TRY.
        DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
        " handle exception
    ENDTRY.
*-----------------------------------------------------------------------------------*

    SELECT SINGLE MAX( version ) FROM zdt_lcexphdr
      WHERE lc_refnr = @gfs_header-lc_refnr
      INTO @DATA(lv_ver).

    SELECT SINGLE * FROM zdt_lcexphdr
    WHERE lc_refnr = @gfs_header-lc_refnr
    AND   id       = @gfs_header-id
    INTO @DATA(gfs_header1).

    gfs_header1-id        = lv_id.
    gfs_header1-version   = lv_ver + 1.
    gfs_header1-lc_status = 'OPEN'.


    APPEND VALUE #( %cid      = keys[ KEY entity %key = gfs_header-%key ]-%cid
                    id        = lv_id
                    %is_draft = '00'
                    %data     = CORRESPONDING #( gfs_header ) ) TO lt_lcexphead ASSIGNING FIELD-SYMBOL(<lfs_lcexphead>).

*    MOVE-CORRESPONDING gfs_header1 TO <lfs_lcexphead> .

    CLEAR :<lfs_lcexphead>-amend_date,<lfs_lcexphead>-amend_txt .

    <lfs_lcexphead>-version     = gfs_header1-version.
    <lfs_lcexphead>-lc_status   = gfs_header1-lc_status.
    <lfs_lcexphead>-companycode = gfs_header1-companycode.
    <lfs_lcexphead>-companyname = gfs_header1-companyname.
    <lfs_lcexphead>-lc_refnr    = gfs_header1-lc_refnr.
    <lfs_lcexphead>-lc_appl     = gfs_header1-lc_appl.
    <lfs_lcexphead>-ekorg       = gfs_header1-ekorg.
    <lfs_lcexphead>-lifnr       = gfs_header1-lifnr.
    <lfs_lcexphead>-vendor_name = gfs_header1-vendor_name.
    <lfs_lcexphead>-lc_type     = gfs_header1-lc_type.
    <lfs_lcexphead>-lctyp_name  = gfs_header1-lctyp_name.
    <lfs_lcexphead>-lc_ut_rpt   = gfs_header1-lc_ut_rpt.
    <lfs_lcexphead>-zterm       = gfs_header1-zterm.
    <lfs_lcexphead>-payterm_description = gfs_header1-payterm_description.
    <lfs_lcexphead>-tenure      = gfs_header1-tenure.
    <lfs_lcexphead>-grace       = gfs_header1-grace.
    <lfs_lcexphead>-lc_req_date = gfs_header1-lc_req_date.
    <lfs_lcexphead>-lc_open_dt  = gfs_header1-lc_open_dt.
    <lfs_lcexphead>-lc_exp_date = gfs_header1-lc_exp_date.
    <lfs_lcexphead>-finala      = gfs_header1-finala.
    <lfs_lcexphead>-usance      = gfs_header1-usance.
    <lfs_lcexphead>-waers       = gfs_header1-waers.
    <lfs_lcexphead>-currfc      = gfs_header1-currfc.

    <lfs_lcexphead>-lc_tot_amt_fc = gfs_header1-lc_tot_amt_fc.
    <lfs_lcexphead>-avail_amount  = gfs_header1-avail_amount.


    APPEND VALUE #( %cid_ref = <lfs_lcexphead>-%cid
                     id      =  lv_id )
         TO lt_bdetails ASSIGNING FIELD-SYMBOL(<lfs_bdetails>).

    IF lt_bdetail IS NOT INITIAL.
      LOOP AT lt_bdetail ASSIGNING FIELD-SYMBOL(<lfs_bdetail>) USING KEY entity
                                      WHERE id = gfs_header-id.

        APPEND VALUE #( %cid = 'Item_' && sy-index
                         id  = lv_id
                        %data = CORRESPONDING #( <lfs_bdetail> )
                     )  TO  <lfs_bdetails>-%target.

      ENDLOOP.
    ENDIF.

    APPEND VALUE #( %cid_ref = <lfs_lcexphead>-%cid
                    id       =  lv_id )
        TO lt_delivery ASSIGNING FIELD-SYMBOL(<lfs_delivery>).

    IF lt_del IS NOT INITIAL.
      LOOP AT lt_del ASSIGNING FIELD-SYMBOL(<lfs_del>) USING KEY entity
                                      WHERE id = gfs_header-id.

        APPEND VALUE #( %cid = 'Item_' && sy-tabix
                        id   = lv_id
                        %data = CORRESPONDING #( <lfs_del> )
                     )  TO  <lfs_delivery>-%target.

      ENDLOOP.
    ENDIF..


    MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
      ENTITY head
           CREATE FIELDS (  version lc_status companycode companyname lc_refnr lc_appl ekorg lifnr vendor_name
                             lc_type lctyp_name lc_ut_rpt zterm payterm_description tenure grace amend_date amend_txt
                             lc_req_date lc_open_dt lc_exp_date finala usance waers lc_tot_amt_fc avail_amount currfc )
           WITH lt_lcexphead
     ENTITY head
           CREATE BY \_item1
           FIELDS ( banktype land1 bankl hbkid banka brnch ort01 swift )
           WITH lt_bdetails
     ENTITY head
           CREATE BY \_item2
           FIELDS ( delivery netwr appl_amt_lc detail )
           WITH lt_delivery
           MAPPED DATA(mapped_create)
               " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(failed_create)
               " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(reported_create).

    IF failed_create IS INITIAL .

      DATA(gfs_hed_close) = VALUE #( header[ 1 ]  OPTIONAL ).
      gfs_hed_close-lc_status = 'CLOSE'.

      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY head
             UPDATE
                 FIELDS ( lc_status lc_amend_date lc_amend_reason )
                 WITH VALUE #(
                                ( %tky         = gfs_hed_close-%tky

                                  lc_status        = gfs_hed_close-lc_status
                                  lc_amend_date    = gfs_hed_close-lc_amend_date
                                  lc_amend_reason  = gfs_hed_close-lc_amend_reason
                                )
                              ).
    ENDIF.
    mapped-head = mapped_create-head.

    " TODO: remove needless CLEAR (ABAP cleaner)
    CLEAR gfs_header1.

  ENDMETHOD.

  METHOD setout.
  ENDMETHOD.

  METHOD deldata.
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY zi_lcexphead
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-avail_amount = 100.

    MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
            ENTITY head
            UPDATE
                FIELDS ( avail_amount  )
                WITH VALUE #(
                               ( %tky   = gfs_header-%tky
                                 avail_amount = gfs_header-avail_amount
                               )
                             ).
  ENDMETHOD.

  METHOD checkamt.
    DATA: lv_msg TYPE string .

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY zi_lcexphead
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-lc_appl IS INITIAL .
      lv_msg = |LC Number is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head
      .

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
    ENDIF.

    IF gfs_header-lifnr IS INITIAL .
      lv_msg = |Customer Number is Required|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head
      .

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
    ENDIF.

    IF gfs_header-lc_type IS INITIAL .
      lv_msg = |LC Type is Required|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head
      .

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
    ENDIF.

    IF gfs_header-lc_req_date IS INITIAL OR gfs_header-lc_open_dt IS INITIAL OR
       gfs_header-lc_exp_date IS INITIAL.
      lv_msg = |LC Requested Date, Opening Date & Expiry Date is Required|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head
      .

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
    ENDIF.



    IF gfs_header-avail_amount < 0.
      lv_msg = |LC is over utilised|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-head
      .

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-head.
    ENDIF.
  ENDMETHOD.

  METHOD updateheader.
    DATA: lv_flag TYPE char1.

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
          ENTITY zi_lcexphead
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED DATA(header_failed).

    " ---------------------------------------------------------------------
    " == EPCG number creation on create action
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-lc_refnr IS INITIAL.
      TRY.

          CALL METHOD cl_numberrange_runtime=>number_get
            EXPORTING
              nr_range_nr = '01'
              object      = 'ZNRO_REFNO'
            IMPORTING
              number      = DATA(lv_number)
              returncode  = DATA(lv_rcode).
        CATCH cx_number_ranges INTO DATA(lr_error).
      ENDTRY .

      SHIFT lv_number LEFT DELETING LEADING '0'.
      IF lv_number IS INITIAL.
        EXIT.
      ENDIF.

      gfs_header-lc_refnr = |{ lv_number ALPHA = IN }|.

      DATA(gfs_header1) = VALUE #( header[ 1 ]  OPTIONAL ).

      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY zi_lcexphead
             UPDATE
             FIELDS (  lc_refnr lc_status )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                             lc_refnr      = gfs_header-lc_refnr
                             lc_status     = 'OPEN'
                             ) ).
    ENDIF.

    IF gfs_header-lifnr IS NOT INITIAL.
      SELECT SINGLE * FROM zr_customer_f4  WHERE customer = @gfs_header-lifnr INTO @DATA(ls_custnam).
      IF sy-subrc EQ 0 AND gfs_header-vendor_name <> ls_custnam-customername.
        gfs_header-vendor_name = ls_custnam-customername.
        lv_flag = 'X' .
      ENDIF.

    ENDIF.

    IF gfs_header-companycode IS NOT INITIAL .
      SELECT SINGLE * FROM zr_salesorg_f4  WHERE companycode = @gfs_header-companycode INTO @DATA(ls_compnam).
      IF sy-subrc EQ 0 AND  gfs_header-companyname <> ls_compnam-yy1_sd_sord_company_na_sdh.
        gfs_header-companyname = ls_compnam-yy1_sd_sord_company_na_sdh.
        lv_flag = 'X' .
      ENDIF.
    ENDIF.

    IF gfs_header-lc_type IS NOT INITIAL .
      SELECT SINGLE * FROM zr_lctype WHERE value_low = @gfs_header-lc_type INTO @DATA(ls_lctype).
      IF sy-subrc EQ 0 AND  gfs_header-lctyp_name <> ls_lctype-prioritydesc.
        gfs_header-lctyp_name = ls_lctype-prioritydesc.
        lv_flag = 'X' .
      ENDIF.
    ENDIF.

    IF lv_flag = 'X' .
      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS (  vendor_name companyname lctyp_name )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                             vendor_name   = gfs_header-vendor_name
                             companyname   = gfs_header-companyname
                             lctyp_name    = gfs_header-lctyp_name

                             %control-vendor_name  = if_abap_behv=>mk-on
                             %control-companyname  = if_abap_behv=>mk-on
                             %control-lctyp_name   = if_abap_behv=>mk-on
                             ) ).
    ENDIF.


  ENDMETHOD.

  METHOD get_dataupdate_f4.
    DATA: lv_flag TYPE char1.

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
      ENTITY zi_lcexphead
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(header)
      " TODO: variable is assigned but never used (ABAP cleaner)
      FAILED DATA(header_failed).

    CLEAR lv_flag .
    " ---------------------------------------------------------------------
    " == Update the Export Header details
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-lifnr IS NOT INITIAL.
      SELECT SINGLE * FROM zr_customer_f4  WHERE customer = @gfs_header-lifnr INTO @DATA(ls_custnam).
      IF sy-subrc EQ 0 AND gfs_header-vendor_name <> ls_custnam-customername.
        gfs_header-vendor_name = ls_custnam-customername.
        lv_flag = 'X' .
      ENDIF.

    ENDIF.

    IF gfs_header-companycode IS NOT INITIAL .
      SELECT SINGLE * FROM zr_salesorg_f4  WHERE companycode = @gfs_header-companycode INTO @DATA(ls_compnam).
      IF sy-subrc EQ 0 AND  gfs_header-companyname <> ls_compnam-yy1_sd_sord_company_na_sdh.
        gfs_header-companyname = ls_compnam-yy1_sd_sord_company_na_sdh.
        lv_flag = 'X' .
      ENDIF.
    ENDIF.

    IF gfs_header-lc_type IS NOT INITIAL .
      SELECT SINGLE * FROM zr_lctype WHERE value_low = @gfs_header-lc_type INTO @DATA(ls_lctype).
      IF sy-subrc EQ 0 AND  gfs_header-lctyp_name <> ls_lctype-prioritydesc.
        gfs_header-lctyp_name = ls_lctype-prioritydesc.
        lv_flag = 'X' .
      ENDIF.
    ENDIF.

    IF gfs_header-lc_status IS INITIAL.
      gfs_header-lc_status     = 'OPEN'.
    ENDIF.

    IF lv_flag = 'X' .
      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS (  vendor_name companyname lctyp_name lc_status )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                             vendor_name   = gfs_header-vendor_name
                             companyname   = gfs_header-companyname
                             lctyp_name    = gfs_header-lctyp_name
                             lc_status     = gfs_header-lc_status

                             %control-vendor_name  = if_abap_behv=>mk-on
                             %control-companyname  = if_abap_behv=>mk-on
                             %control-lctyp_name   = if_abap_behv=>mk-on
                             ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

*-----------------------------------------------------------------------------------*
*  Export Lc Bank Details
*-----------------------------------------------------------------------------------*
CLASS lhc_zi_lcbnk_dlts DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_lcbnk_dlts RESULT result.

ENDCLASS.

CLASS lhc_zi_lcbnk_dlts IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY zi_lcexphead
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(header_failed).



    IF header IS INITIAL.
      RETURN.
    ENDIF.

    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
         ENTITY zi_lcbnk_dlts
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(fg)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed).


    result = VALUE #( FOR gs_item IN fg
                       ( %tky            = gs_item-%tky

                         %field-hbkid    = COND #( WHEN gs_item-banktype = 'Opening Bank'
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-f-read_only  )
                   ) ).
  ENDMETHOD.

ENDCLASS.

*-----------------------------------------------------------------------------------*
*//--------- Item Delivery Line----------------------//
*-----------------------------------------------------------------------------------*
CLASS lhc_zi_lcexpitm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS lcamtdel FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_lcexpitm~lcamtdel.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_lcexpitm RESULT result.
    METHODS delivery FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_lcexpitm~delivery.

ENDCLASS.

CLASS lhc_zi_lcexpitm IMPLEMENTATION.

  METHOD lcamtdel.

    DATA: lv_delv    TYPE char10,
          lv_dlvpric TYPE dmbtr,
          lv_dlvdisc TYPE dmbtr.
*-----------------------------------------------------------------------------------*
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
             ENTITY zi_lcexphead
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_lcexphead
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item2).

    DATA(gfs_item2) = VALUE #( item2[ 1 ]  OPTIONAL ).
    DATA(lt_item2) = item2[] .
*-----------------------------------------------------------------------------------*

    LOOP AT lt_item2 ASSIGNING FIELD-SYMBOL(<lfs_item2>) .
      lv_delv = |{ <lfs_item2>-delivery ALPHA = IN }|.
      <lfs_item2>-delivery = lv_delv .
    ENDLOOP.


    SELECT
           a~deliverydocument,
           c~referencesddocument , c~referencesddocumentitem,
                                   c~originaldeliveryquantity,
           b~netpriceamount , b~transactioncurrency,b~orderquantity,
           d~conditionratevalue, d~conditiontype
    FROM i_deliverydocument AS a
    INNER JOIN @lt_item2 AS e ON a~deliverydocument = e~delivery
    INNER JOIN i_deliverydocumentitem AS c ON a~deliverydocument = c~deliverydocument
    INNER JOIN i_salesdocumentitem AS b ON c~referencesddocument     = b~salesdocument
                                       AND c~referencesddocumentitem = b~salesdocumentitem
    INNER JOIN i_salesdocitempricingelement AS d ON c~referencesddocument    = d~salesdocument
                                                AND c~referencesddocumentitem =  d~salesdocumentitem
                                                AND ( d~conditiontype = 'ZPR0' OR d~conditiontype = 'ZPR1'
                                                   OR d~conditiontype = 'ZSPC'
                                                   OR d~conditiontype = 'ZK07' OR d~conditiontype = 'ZK08' )
    INTO TABLE @DATA(lt_dlvdtls) .

    IF lt_dlvdtls IS NOT INITIAL .
      DATA(lv_availamt) = gfs_header-lc_tot_amt_fc.

      LOOP AT lt_item2 ASSIGNING <lfs_item2> .

        lv_dlvpric = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_dlv IN lt_dlvdtls
                                    WHERE (  deliverydocument = <lfs_item2>-delivery AND
                                           ( conditiontype = 'ZPR0' OR conditiontype = 'ZPR1' OR
                                             conditiontype = 'ZSPC' ) )
                               NEXT lv_amt = lv_amt + ( ls_dlv-originaldeliveryquantity * ls_dlv-conditionratevalue ) ).

        lv_dlvdisc = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_dlv IN lt_dlvdtls
                                    WHERE (  deliverydocument = <lfs_item2>-delivery AND
                                           ( conditiontype    = 'ZK07' OR conditiontype = 'ZK08') )
                               NEXT lv_amt = COND #(
                                                   WHEN ls_dlv-conditiontype = 'ZK07'
                                                         THEN lv_amt + ( ( ls_dlv-conditionratevalue *
                                                              ( REDUCE dmbtr( INIT lv_zk07 TYPE dmbtr FOR ls_dlvk07 IN lt_dlvdtls
                                                                       WHERE (  deliverydocument        = ls_dlv-deliverydocument AND
                                                                                referencesddocument     = ls_dlv-referencesddocument AND
                                                                                referencesddocumentitem = ls_dlv-referencesddocumentitem AND
                                                                              ( conditiontype = 'ZPR0' OR conditiontype = 'ZPR1' OR
                                                                                conditiontype = 'ZSPC') )
                                                                         NEXT lv_zk07 = lv_zk07 + ( ls_dlvk07-originaldeliveryquantity *
                                                                                                    ls_dlvk07-conditionratevalue ) ) ) / 100 )
                                                                )
                                                   WHEN ls_dlv-conditiontype = 'ZK08'
                                                          THEN  lv_amt + ls_dlv-conditionratevalue

                                                      )
                                    ).

        <lfs_item2>-netwr       = lv_dlvpric + lv_dlvdisc .

        IF lv_availamt >= <lfs_item2>-netwr .
          <lfs_item2>-appl_amt_lc = <lfs_item2>-netwr.
          lv_availamt             = lv_availamt - <lfs_item2>-netwr .
        ELSE.
          CLEAR <lfs_item2>-appl_amt_lc .
        ENDIF.

        READ TABLE lt_dlvdtls INTO DATA(ls_slvdtls) WITH KEY deliverydocument = <lfs_item2>-delivery.
        IF sy-subrc EQ 0.
          <lfs_item2>-applcurr = ls_slvdtls-transactioncurrency.
          <lfs_item2>-waers    = ls_slvdtls-transactioncurrency.
        ENDIF.

        MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
        ENTITY zi_lcexpitm
        UPDATE FIELDS ( appl_amt_lc applcurr waers netwr )
        WITH VALUE #( id     = <lfs_item2>-id
                      ( %tky          = <lfs_item2>-%tky
                        appl_amt_lc   = <lfs_item2>-appl_amt_lc
                        applcurr      = <lfs_item2>-applcurr
                        waers         = <lfs_item2>-waers
                        netwr         = <lfs_item2>-netwr

                      ) ).

      ENDLOOP.
    ENDIF.

    READ ENTITY zi_lcexphead
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_final).

    lv_dlvpric = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_final IN lt_final
                           NEXT lv_amt = lv_amt + ls_final-appl_amt_lc  ).

    gfs_header-avail_amount = gfs_header-lc_tot_amt_fc - lv_dlvpric.

    IF gfs_header-avail_amount IS NOT INITIAL .
      MODIFY ENTITIES OF zi_lcexphead IN LOCAL MODE
              ENTITY head
              UPDATE
                  FIELDS ( avail_amount  )
                  WITH VALUE #( ( %tky   = gfs_header-%tky
                                   avail_amount     = gfs_header-avail_amount
                                   %control-tenure  = if_abap_behv=>mk-on
                                 ) ).
    ENDIF.
  ENDMETHOD.

  METHOD get_instance_features.

*-----------------------------------------------------------------------------------*
    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(head)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed).

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
         ENTITY zi_lcexpitm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed_itm).
    DATA(gfs_head) = VALUE #( head[ 1 ]  OPTIONAL ).

*-----------------------------------------------------------------------------------*

    result = VALUE #( FOR ls_item IN item
                          ( %tky                = ls_item-%tky

                            %delete             = COND #( WHEN gfs_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled
                                                          )

                            %field-delivery     = COND #( WHEN gfs_head-lc_status = 'OPEN'
                                                           THEN if_abap_behv=>fc-f-mandatory
                                                           ELSE if_abap_behv=>fc-f-read_only
                                                          )
                      ) ).



  ENDMETHOD.

  METHOD delivery.

    DATA : lv_msg TYPE string .

    READ ENTITIES OF zi_lcexphead IN LOCAL MODE
              ENTITY head
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(lt_header)

              FAILED FINAL(lt_header_failed).

    READ ENTITY zi_lcexphead
         BY \_item2
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item2)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.


    LOOP AT lt_item2 INTO DATA(ls_item2).

      "-- Check Delivery exit -----"
      SELECT SINGLE b~* FROM zdt_lcexpitm AS a
                        INNER JOIN zdt_lcexphdr AS b ON a~id = b~id
                        WHERE a~item2   <> @ls_item2-item2 AND
                              a~delivery = @ls_item2-delivery AND
                              b~lc_number <> @ls_header-lc_number
                        INTO @DATA(ls_dlvexit).
      IF sy-subrc = 0 .
        lv_msg = 'DLV-' && ls_item2-delivery && 'Exist in LC-' && ls_dlvexit-lc_refnr && 'V-' && ls_dlvexit-version .
        APPEND VALUE #( %tky              = ls_header-%tky
                             %state_area  = 'Validate_Head'
                             %msg         = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = lv_msg  ) )
                    TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
        EXIT.
      ENDIF.

      "-- Check Delivery with Customer & Payment term -----"
      SELECT SINGLE * FROM zcds_exlcdlv_f4
                        WHERE deliverydocument     = @ls_item2-delivery AND
                              soldtoparty          = @ls_header-lifnr AND
                              customerpaymentterms = @ls_header-zterm
                        INTO @DATA(ls_dlvcheck).
      IF sy-subrc <> 0 .
        lv_msg = 'DLV-' && ls_item2-delivery && ' Customer & PaymentTerms Not Match'.
        APPEND VALUE #( %tky              = ls_header-%tky
                             %state_area  = 'Validate_Head'
                             %msg         = new_message_with_text( severity  = if_abap_behv_message=>severity-error
                                                                        text = lv_msg  ) )
                    TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.
        EXIT.
      ENDIF.


      IF ls_header-currfc <> ls_item2-applcurr .
        lv_msg = 'Not Match LC & Delivery-Currency-' && ls_item2-delivery.
        APPEND VALUE #( %tky              = ls_header-%tky
                             %state_area  = 'Validate_Head'
                             %msg         = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = lv_msg  ) )
                    TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.

      ENDIF.

      IF ls_item2-appl_amt_lc IS INITIAL .
        lv_msg = 'Delivery-' && ls_item2-delivery && 'Amt morethen LC RemainAmt'.
        APPEND VALUE #( %tky              = ls_header-%tky
                             %state_area  = 'Validate_Head'
                             %msg         = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = lv_msg  ) )
                    TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lsc_zi_lchead DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_lchead IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
