CLASS lsc_zi_expensecal DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_expensecal IMPLEMENTATION.

  METHOD save_modified.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_expensecal_i DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS getitemupdate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_expensecal_i~getitemupdate.
    METHODS updateamount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_expensecal_i~updateamount.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_expensecal_i RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_expensecal_i RESULT result.

    METHODS serviceentry FOR MODIFY
      IMPORTING keys FOR ACTION zi_expensecal_i~serviceentry RESULT result.
*    METHODS copy FOR MODIFY
*      IMPORTING keys FOR ACTION zi_expensecal_i~copy RESULT result.

    DATA: lv_msg TYPE string .

ENDCLASS.

CLASS lhc_zi_expensecal_i IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITY zi_expensecal
          BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    result = VALUE #( FOR ls_item IN lt_item
                        (  %tky              = ls_item-%tky

                          %delete                 = COND #( WHEN ls_item-servicepo = ''
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )
                          %action-serviceentry    = COND #( WHEN ls_item-servicepo IS NOT INITIAL AND ls_item-serentrysheet IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )
                          %field-exchangerate     = COND #( WHEN ls_item-servicepo = ''
                                                            THEN if_abap_behv=>fc-f-mandatory
                                                            ELSE if_abap_behv=>fc-f-read_only )
                          %field-amountinr        = COND #( WHEN ls_item-servicepo = ''
                                                            THEN if_abap_behv=>fc-f-mandatory
                                                            ELSE if_abap_behv=>fc-f-read_only )
                          %field-amount            = COND #( WHEN ls_item-servicepo = ''
                                                            THEN if_abap_behv=>fc-f-mandatory
                                                            ELSE if_abap_behv=>fc-f-read_only )

                         ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD getitemupdate.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal_i
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

*--- Get total Invoice base on Commercial Invoice
    SELECT SINGLE
        billingdocument,
        exchangerate,
        forwarder,
        consize,
        shipline,
        SUM( i ) AS taxinvcount
    FROM zi_com_dlv_cds
    WHERE billingdocument = @gfs_header-commid
    GROUP BY billingdocument,forwarder,exchangerate,consize,shipline
    INTO @DATA(ls_com_dlv_cds) .
    IF sy-subrc = 0.

      LOOP AT lt_item INTO DATA(gfs_item).
        gfs_item-commid       = gfs_header-commid .

        gfs_item-exchangerate = ls_com_dlv_cds-exchangerate.
        gfs_item-forwarder    = ls_com_dlv_cds-forwarder .

        IF gfs_item-percontship = 'CONTAINER'.
          gfs_item-countcontship = ls_com_dlv_cds-taxinvcount .
        ELSEIF gfs_item-percontship = 'SHIPMENT'.
          gfs_item-countcontship = 1 .
        ENDIF.

        SELECT SINGLE * FROM zdt_expensecond
                WHERE expansetype = @gfs_item-expansetype AND
                      percontship = @gfs_item-percontship AND
                      contsize    = @ls_com_dlv_cds-consize AND
                      shipline    = @ls_com_dlv_cds-shipline AND
                      forwarder   = @ls_com_dlv_cds-forwarder
          INTO @DATA(ls_expensecond).
        IF sy-subrc EQ 0.
          IF gfs_item-amount IS INITIAL .
            gfs_item-amount       = ls_expensecond-amount * gfs_item-countcontship.
          ENDIF.
          gfs_item-currency     = ls_expensecond-currency.
          gfs_item-amountinr    = gfs_item-amount .
        ENDIF.

        IF gfs_item-currency <> 'INR'.
*          gfs_item-amountinr =  gfs_item-amount * ( gfs_item-exchangerate * 100 ).
          gfs_item-amountinr =  gfs_item-amount * gfs_item-exchangerate.
        ENDIF.

        MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                   ENTITY zi_expensecal_i
                   UPDATE
                   FIELDS ( commid countcontship amount currency amountinr exchangerate forwarder )
                   WITH VALUE #( id = gfs_item-id
                                 ( %tky          = gfs_item-%tky
                                   commid        = gfs_item-commid
                                   countcontship = gfs_item-countcontship
                                   amount        = gfs_item-amount
                                   currency      = gfs_item-currency
                                   amountinr     = gfs_item-amountinr
                                   exchangerate  = gfs_item-exchangerate
                                   forwarder     = gfs_item-forwarder

                                  )
                               ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD updateamount.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal_i
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

*--- Get total Invoice base on Commercial Invoice

    LOOP AT lt_item INTO DATA(gfs_item).

      IF gfs_item-currency <> 'INR'.
*        gfs_item-amountinr =  gfs_item-amount * ( gfs_item-exchangerate * 100 ).
        gfs_item-amountinr =  gfs_item-amount * gfs_item-exchangerate.
      ENDIF.

      MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                 ENTITY zi_expensecal_i
                 UPDATE
                 FIELDS ( amountinr )
                 WITH VALUE #( id = gfs_item-id
                               ( %tky          = gfs_item-%tky
                                 amountinr     = gfs_item-amountinr
                                )
                             ).
    ENDLOOP.
  ENDMETHOD.

  METHOD serviceentry.

    DATA:
      ls_header_data TYPE i_serviceentrysheettp_2,
      ls_item_data   TYPE i_serviceentrysheetitemtp_2,

      lt_header_crt  TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet,
      lt_item_cba    TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet\_serviceentrysheetitem.

    DATA: lv_num     TYPE i.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal_i
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

*-------------------------------------------------------------------------------------------------------
*--- Get total Invoice base on Commercial Invoice

    LOOP AT lt_item INTO DATA(gfs_item) WHERE serviceentrybt IS INITIAL  .
      CHECK gfs_item-servicepo IS NOT INITIAL AND gfs_item-servicepoline IS NOT INITIAL.

      lv_num = lv_num + 1 .

      SELECT SINGLE expansetypedesc
       FROM zi_expensetype_f4
       WHERE expansetype = @gfs_item-expansetype INTO @DATA(ls_expensetxt).


* Create SES with reference to a Service Purchase Order Item

*--- Prepare Header Data
      ls_header_data-serviceentrysheetname = ls_expensetxt.
      ls_header_data-purchaseorder = gfs_item-servicepo ."'2200000024'.
      ls_header_data-sesoriginobjecttype = 'EX'.

*--- Prepare Item Data
      ls_item_data-purchaseorderitem = gfs_item-servicepoline. "'00010'.
      ls_item_data-confirmedquantity = '1'.
      ls_item_data-accountassignmentcategory      = 'K'.
      ls_item_data-serviceperformancedate         = sy-datlo.
      ls_item_data-multipleacctassgmtdistribution = '0'.


*--- Prepare Payload
      APPEND INITIAL LINE TO lt_header_crt ASSIGNING FIELD-SYMBOL(<ls_hdr_crt>).
      <ls_hdr_crt> = CORRESPONDING #( ls_header_data CHANGING CONTROL ).
      <ls_hdr_crt>-%cid = 'HEADER_' && lv_num .


      APPEND INITIAL LINE TO lt_item_cba ASSIGNING FIELD-SYMBOL(<ls_itm_cba>).
      <ls_itm_cba>-%cid_ref = 'HEADER_' && lv_num.

      APPEND INITIAL LINE TO <ls_itm_cba>-%target ASSIGNING FIELD-SYMBOL(<item_data>).
      <item_data> = CORRESPONDING #( ls_item_data CHANGING CONTROL ).
      <item_data>-%cid = 'ITEM_' && lv_num.


      MODIFY ENTITIES OF i_serviceentrysheettp_2
       ENTITY serviceentrysheet
         CREATE
               FROM lt_header_crt
         CREATE BY \_serviceentrysheetitem
               FROM lt_item_cba

       FAILED DATA(ls_failed_crt)
       REPORTED DATA(ls_reported_crt)
       MAPPED DATA(ls_mapped_crt).

    ENDLOOP.

  ENDMETHOD.
*
*  METHOD Copy.
*    READ ENTITIES OF zi_expensecal IN LOCAL MODE
*           ENTITY zi_expensecal
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(header).
*
*    READ ENTITIES OF zi_expensecal IN LOCAL MODE
*           ENTITY zi_expensecal_i
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(lt_item)
*           FAILED FINAL(lt_item_failed).
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*    DATA : lv_item TYPE zi_packlist_itm-item.
*    DATA: lv_p TYPE p.
*
*    LOOP AT lt_item INTO DATA(gs_item) WHERE commid is not initial.
*     lv_p += 1.
*
*      TRY.
*          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*        CATCH cx_uuid_error.
*      ENDTRY.
*      lv_item = lv_p && lv_item.
*
*      MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
*      ENTITY zi_expensecal
*      CREATE BY \_item
*      FROM VALUE #( ( id      = gfs_header-id
*                     %target = VALUE #( (     %cid                = lv_item && gs_item-commid && gs_item-expansetype
*                                              item                = lv_item
*                                              commid              = gs_item-commid
*                                              expansetype         = gs_item-expansetype
*                                              percontship         = gs_item-percontship
*                                              forwarder           = gs_item-forwarder
*                                              countcontship       = gs_item-countcontship
*                                              amount              = gs_item-amount
*                                              currency            = gs_item-currency
*                                              exchangerate        = gs_item-exchangerate
*                                              amountinr           = gs_item-amountinr
*
*                                              %control-item         = if_abap_behv=>mk-on
*                                              %control-commid       = if_abap_behv=>mk-on
*                                              %control-expansetype  = if_abap_behv=>mk-on
*                                              %control-percontship  = if_abap_behv=>mk-on
*                                              %control-forwarder    = if_abap_behv=>mk-on
*                                              %control-countcontship = if_abap_behv=>mk-on
*                                              %control-amount       = if_abap_behv=>mk-on
*                                              %control-currency     = if_abap_behv=>mk-on
*                                              %control-exchangerate = if_abap_behv=>mk-on
*                                              %control-amountinr    = if_abap_behv=>mk-on
*                                       ) ) ) )
*                     MAPPED FINAL(ls_mapped)
*                     FAILED FINAL(ls_failed)
*                     REPORTED FINAL(ls_reported).
*     clear : gs_item.
*    ENDLOOP.
*
*     READ ENTITY zi_expensecal
*          BY \_item
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT FINAL(item_upd).
*
*    result = VALUE #( FOR ls_item1 IN item_upd
*                          ( %tky   = ls_item1-%tky
*                            %param = ls_item1 ) ).
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_expensecal DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_expensecal RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_expensecal RESULT result.

    METHODS servicepo FOR MODIFY
      IMPORTING keys FOR ACTION zi_expensecal~servicepo RESULT result.
    METHODS poupd FOR MODIFY
      IMPORTING keys FOR ACTION zi_expensecal~poupd RESULT result.
    METHODS upd_taxcode FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_expensecal~upd_taxcode.
    METHODS upd_profitcenter FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_expensecal~upd_profitcenter.
    METHODS exptype FOR MODIFY
      IMPORTING keys FOR ACTION zi_expensecal~exptype RESULT result .


ENDCLASS.

CLASS lhc_zi_expensecal IMPLEMENTATION.

  METHOD get_instance_features.

*---------------------------------------------------------------------------*
    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITY zi_expensecal
              BY \_item
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(lt_item)
               FAILED FINAL(lt_item_failed).
*---------------------------------------------------------------------------*

    DATA(lt_tmp_item) = lt_item .
    DELETE lt_tmp_item WHERE servicepo = '' .
    DATA(ls_item) = VALUE #( lt_tmp_item[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_head IN header
                        ( %tky                    = ls_head-%tky

                          %delete                 = COND #( WHEN sy-uname = 'CB9980000000'  "++ 14.02.25@SM
                                                                     THEN if_abap_behv=>fc-o-enabled
                                                            WHEN ls_item-servicepo = ''
                                                                    THEN if_abap_behv=>fc-o-enabled
                                                                    ELSE if_abap_behv=>fc-o-disabled )
                          %field-commid           = COND #( WHEN ls_item-servicepo = ''
                                                                    THEN if_abap_behv=>fc-f-mandatory
                                                                    ELSE if_abap_behv=>fc-f-read_only )
                          %field-commdate         = COND #( WHEN ls_item-servicepo = ''
                                                                    THEN if_abap_behv=>fc-f-mandatory
                                                                    ELSE if_abap_behv=>fc-f-read_only )
                          %field-taxcode          = COND #( WHEN ls_item-servicepo = ''
                                                                    THEN if_abap_behv=>fc-f-mandatory
                                                                    ELSE if_abap_behv=>fc-f-read_only )
                          %field-profitcenter     = COND #( WHEN ls_item-servicepo = ''
                                                                    THEN if_abap_behv=>fc-f-mandatory
                                                                    ELSE if_abap_behv=>fc-f-read_only )
                         ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD servicepo.

    DATA: lv_num     TYPE i,
          lv_posnr   TYPE posnr,
          lv_poref   TYPE c LENGTH 35,
          lv_servtxt TYPE c LENGTH 40.

    DATA: ls_pohead    TYPE i_purchaseordertp_2,
          lt_poitem    TYPE STANDARD TABLE OF i_purchaseorderitemtp_2,
          lt_poitemacc TYPE STANDARD TABLE OF i_purordaccountassignmenttp_2.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
           ENTITY zi_expensecal
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    READ ENTITY zi_expensecal
          BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    DATA(lt_item_tmp) = lt_item.

    CLEAR :lt_item_tmp[] .
    DATA lv_profitcenter TYPE prctr.
    DATA lv_glaccount TYPE hkont.

    lv_profitcenter = |{ gfs_header-profitcenter ALPHA = IN }|.

    "- Get Costcenter from Tmg
    SELECT SINGLE * FROM zdt_exp_costc WHERE profitcenter = @lv_profitcenter INTO @DATA(ls_costcenter) .

*--- Get total Invoice base on Commercial Invoice
    LOOP AT lt_item INTO DATA(gfs_item) WHERE servicepobt = ' '
                         GROUP BY ( k1 = gfs_item-forwarder ) INTO DATA(ls_grp).


      CLEAR:lv_posnr.

      LOOP AT GROUP ls_grp INTO gfs_item .
        "Replacing Hard-coded GL Account
        SELECT SINGLE glc2 FROM zi_glm WHERE exptyp = @gfs_item-expansetype INTO @DATA(lv_glacc).
        lv_glaccount = |{ lv_glacc ALPHA = IN }|.
        lv_posnr = lv_posnr + 10.
        lv_poref = gfs_item-commid && gfs_item-expansetype.


        SELECT SINGLE expansetypedesc
         FROM zi_expensetype_f4
         WHERE expansetype = @gfs_item-expansetype INTO @DATA(ls_expensetxt).

        APPEND INITIAL LINE TO lt_poitem ASSIGNING FIELD-SYMBOL(<lfs_poitem>).
        <lfs_poitem> = VALUE  i_purchaseorderitemtp_2(
                                                       purchaseorderitem = lv_posnr
                                                       producttypecode   = '2'
                                                       accountassignmentcategory = 'K'
                                                       purchaseorderitemtext     = ls_expensetxt
                                                       purchaseorderquantityunit = 'EA'
                                                       materialgroup = 'ZS34'
                                                       plant = '1000'
                                                       orderquantity = '1'
                                                       netpriceamount   = gfs_item-amountinr
                                                       documentcurrency = 'INR' "gfs_item-currency
                                                       suppliermaterialnumber = lv_poref
                                                       taxcode = gfs_header-taxcode
                                                     ).

        APPEND INITIAL LINE TO lt_poitemacc ASSIGNING FIELD-SYMBOL(<lfs_poitemacc>).
        <lfs_poitemacc> = VALUE i_purordaccountassignmenttp_2(
                                                                purchaseorderitem = lv_posnr
                                                                controllingarea   = 'A000'
                                                                accountassignmentnumber = '01'
                                                                costcenter = ls_costcenter-costcenter"'0000110002'
                                                                glaccount  = lv_glaccount " '0048300210'
                                                              ).
      ENDLOOP.

      lv_num   = lv_num + 1.

      ls_pohead = VALUE i_purchaseordertp_2( purchaseordertype = 'ZEXP'
                                             companycode       = '1000'
                                             purchasingorganization = '1000'
                                             purchasinggroup        = '103'
                                             supplier = |{  gfs_item-forwarder ALPHA = IN }|
                                             correspncinternalreference = gfs_header-commid
                                          ).

      MODIFY  ENTITIES OF i_purchaseordertp_2
                ENTITY purchaseorder
                  CREATE SET FIELDS WITH VALUE #( (
                    VALUE #( BASE CORRESPONDING #( ls_pohead CHANGING CONTROL )
                           %cid = |My%CID_{ lv_num }| )
                          ) )
                ENTITY purchaseorder
                CREATE BY \_purchaseorderitem SET FIELDS WITH VALUE #( (
                    %cid_ref = |My%CID_{ lv_num }|
                    %target = VALUE #( FOR ls_poitem IN lt_poitem
                            ( VALUE #( BASE CORRESPONDING #( ls_poitem CHANGING CONTROL ) %cid = |My%CIDitem_{ ls_poitem-purchaseorderitem }| ) ) )

                  ) )
               ENTITY purchaseorderitem
                 CREATE BY \_purordaccountassignment SET FIELDS WITH VALUE #(  FOR ls_poitem IN lt_poitem
                      (
                    %cid_ref = |My%CIDitem_{ ls_poitem-purchaseorderitem }|
                    purchaseorderitem = ls_poitem-purchaseorderitem
                    %target = VALUE #( FOR ls_poitemacc IN lt_poitemacc WHERE ( purchaseorderitem = ls_poitem-purchaseorderitem )
                                    ( VALUE #( BASE CORRESPONDING #( ls_poitemacc CHANGING CONTROL ) %cid = |My%CIDAcc_{ ls_poitemacc-purchaseorderitem }| ) ) )

                  ) )

       REPORTED FINAL(lt_reportedpo)
       FAILED FINAL(lt_failedpo)
       MAPPED FINAL(lt_mappedpo).

      IF lt_failedpo IS NOT INITIAL.
      ELSE.
        LOOP AT GROUP ls_grp INTO gfs_item .
          MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                     ENTITY zi_expensecal_i
                     UPDATE FIELDS ( servicepobt )
                     WITH VALUE #( ( %tky       = gfs_item-%tky
                                   servicepobt  = abap_true
                                 ) ).
        ENDLOOP.
      ENDIF.

      READ ENTITIES OF zi_expensecal IN LOCAL MODE
             ENTITY zi_expensecal
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item_upd).

      result = VALUE #( FOR ls_itm_upd IN item_upd
                            ( %tky   = ls_itm_upd-%tky
                              %param = ls_itm_upd ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD poupd.

    DATA:lv_poref   TYPE c LENGTH 35.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
         ENTITY zi_expensecal
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    READ ENTITY zi_expensecal
          BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).

    LOOP AT lt_item INTO DATA(gfs_item) .

      IF gfs_item-servicepo IS INITIAL .
        lv_poref = gfs_item-commid && gfs_item-expansetype .
        SELECT SINGLE * FROM i_purchaseorderitemapi01 WHERE suppliermaterialnumber = @lv_poref INTO @DATA(ls_poline).
        IF sy-subrc EQ 0.

          gfs_item-servicepo     = ls_poline-purchaseorder.
          gfs_item-servicepoline = ls_poline-purchaseorderitem.

          MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                     ENTITY zi_expensecal_i
                     UPDATE FIELDS ( servicepobt servicepo servicepoline )
                     WITH VALUE #( ( %tky       = gfs_item-%tky

                                   servicepobt      = abap_true
                                   servicepo        = ls_poline-purchaseorder
                                   servicepoline    = ls_poline-purchaseorderitem

                                   %control-servicepobt   = if_abap_behv=>mk-on
                                   %control-servicepo     = if_abap_behv=>mk-on
                                   %control-servicepoline = if_abap_behv=>mk-on
                                 ) ).
        ENDIF.
      ENDIF.

      IF gfs_item-serentrysheet IS INITIAL AND gfs_item-servicepo IS NOT INITIAL.

        SELECT SINGLE a~serviceentrysheet
         FROM i_serviceentrysheetapi01 AS a
         INNER JOIN i_serviceentrysheetitemapi01 AS b ON a~serviceentrysheet = b~serviceentrysheet
         WHERE a~purchaseorder     = @gfs_item-servicepo AND
               b~purchaseorderitem = @gfs_item-servicepoline AND
               a~isdeleted = ''
        INTO @DATA(ls_serline).
        IF sy-subrc EQ 0.
          MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                     ENTITY zi_expensecal_i
                     UPDATE FIELDS ( serviceentrybt serentrysheet )
                     WITH VALUE #( ( %tky       = gfs_item-%tky

                                   serviceentrybt   = abap_true
                                   serentrysheet    = ls_serline

                                   %control-serviceentrybt  = if_abap_behv=>mk-on
                                   %control-serentrysheet   = if_abap_behv=>mk-on
                                 ) ).
        ENDIF.
      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
                 ENTITY zi_expensecal
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(item_upd).

    result = VALUE #( FOR ls_itm_upd IN item_upd
                          ( %tky   = ls_itm_upd-%tky
                            %param = ls_itm_upd ) ).

  ENDMETHOD.

  METHOD upd_taxcode.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
         ENTITY zi_expensecal
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(ls_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF ls_header-taxcode IS INITIAL.

      ls_header-taxcode = 'I0'.

      MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                 ENTITY zi_expensecal
                 UPDATE
                 FIELDS ( taxcode )
                 WITH VALUE #( ( %tky        = ls_header-%tky
                                 taxcode     = ls_header-taxcode
                                )
                             ).
    ENDIF.

  ENDMETHOD.

  METHOD upd_profitcenter.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
         ENTITY zi_expensecal
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(ls_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE plant FROM i_billingdocumentitem WHERE billingdocument = @ls_header-commid INTO @DATA(lv_plant).

    IF ls_header-profitcenter IS INITIAL.

      ls_header-profitcenter = lv_plant.

      MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                 ENTITY zi_expensecal
                 UPDATE
                 FIELDS ( profitcenter )
                 WITH VALUE #( ( %tky         = ls_header-%tky
                                 profitcenter = ls_header-profitcenter
                                )
                             ).
    ENDIF.

  ENDMETHOD.

  METHOD exptype.

    READ ENTITIES OF zi_expensecal IN LOCAL MODE
         ENTITY zi_expensecal
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_header_failed).

    DATA(ls_hdr) = VALUE #( lt_header[ 1 ]  OPTIONAL ).

    SELECT * FROM i_billingdocumentitem WHERE
    billingdocument = @ls_hdr-commid INTO TABLE @DATA(lt_del).

    DELETE ADJACENT DUPLICATES FROM lt_del COMPARING referencesddocument.

    SELECT delivery, consizen, forwarder, shipline, cod FROM zi_deldash_hdr
    FOR ALL ENTRIES IN @lt_del
    WHERE delivery = @lt_del-referencesddocument
    INTO TABLE @DATA(lt_deldash).

    SELECT * FROM zi_expensecond
    FOR ALL ENTRIES IN @lt_deldash
    WHERE contsize = @lt_deldash-consizen
    AND   forwarder = @lt_deldash-forwarder
    AND   shipline = @lt_deldash-shipline
    AND countrydest = @lt_deldash-cod
    INTO TABLE @DATA(lt_exptype).

    LOOP AT lt_exptype INTO DATA(ls_exptype).

      SELECT SINGLE exchangerate, SUM( i ) AS taxinvcount
           FROM zi_com_dlv_cds
           WHERE billingdocument = @ls_hdr-commid
           GROUP BY billingdocument,forwarder,cod,exchangerate,consize,shipline
           INTO @DATA(ls_com_dlv_cds).

      SELECT billingdocument, forwarder, cod, exchangerate, consize, shipline
      FROM zi_com_dlv_cds
      WHERE billingdocument = @ls_hdr-commid
      GROUP BY billingdocument, forwarder, cod, exchangerate, consize, shipline
      INTO TABLE @DATA(lt_billing_groups).

      DATA(lv_billingdoc_count) = lines( lt_billing_groups ).

      IF lv_billingdoc_count = 1.

        IF ls_exptype-percontship = 'CONTAINER'.

          DATA(lv_amt) = ls_com_dlv_cds-taxinvcount * ls_exptype-amount.

        ELSE.

          lv_amt = ls_exptype-amount.

        ENDIF.

*     data(lv_a_inr) = lv_amt * ls_com_dlv_cds-ExchangeRate.

        DATA(lv_a_inr) = COND #( WHEN ls_exptype-currency = 'INR' THEN lv_amt ELSE lv_amt * ls_com_dlv_cds-exchangerate ).

        TRY.
            DATA(lv_item1) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
        ENDTRY.


        MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
                   ENTITY zi_expensecal
                   CREATE BY \_item
                   FROM VALUE #( ( id      = ls_hdr-id
                                   %target = VALUE #( ( %cid                     = lv_item1
                                                         item                    = lv_item1
                                                         commid                  = ls_hdr-commid
                                                         expansetype             = ls_exptype-expansetype
                                                         percontship             = ls_exptype-percontship
                                                         countcontship           = ls_com_dlv_cds-taxinvcount
                                                         amount                  = lv_amt
                                                         amountinr               = lv_a_inr
                                                         currency                = ls_exptype-currency

                                                         %control-item                = if_abap_behv=>mk-on
                                                         %control-commid              = if_abap_behv=>mk-on
                                                         %control-expansetype         = if_abap_behv=>mk-on
                                                         %control-percontship         = if_abap_behv=>mk-on
                                                         %control-countcontship       = if_abap_behv=>mk-on
                                                         %control-amount              = if_abap_behv=>mk-on
                                                         %control-amountinr           = if_abap_behv=>mk-on
                                                         %control-currency            = if_abap_behv=>mk-on

                                                         ) ) ) )
                                                         MAPPED FINAL(ls_mapped1)
                                                         FAILED FINAL(ls_failed1)
                                                         REPORTED FINAL(ls_reported1).

      ENDIF.

    ENDLOOP.



    READ ENTITIES OF zi_expensecal IN LOCAL MODE
         ENTITY zi_expensecal
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_w1).

    result = VALUE #( FOR ls_hedader IN header_w1
                     ( %tky   = ls_hedader-%tky
                       %param = ls_hedader ) ).





  ENDMETHOD.

ENDCLASS.
