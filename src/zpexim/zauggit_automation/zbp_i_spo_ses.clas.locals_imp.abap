CLASS lhc_zi_spo_ses DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      keys REQUEST requested_features FOR zi_spo_ses RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zi_spo_ses RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zi_spo_ses RESULT result.

    METHODS servicepo FOR MODIFY
       keys FOR ACTION zi_spo_ses~servicepo RESULT result.

ENDCLASS.

CLASS lhc_zi_spo_ses IMPLEMENTATION.

*  METHOD get_instance_features.
**  READ ENTITIES OF zi_spo_ses IN LOCAL MODE
**           ENTITY zi_spo_ses
**           ALL FIELDS
**           WITH CORRESPONDING #( keys )
**           RESULT FINAL(header).
**
**    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*
*  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD servicepo.
    DATA: lv_num     TYPE i,
          lv_posnr   TYPE posnr,
          lv_poref   TYPE c LENGTH 35,
          lv_servtxt TYPE c LENGTH 40.

    DATA: ls_pohead    TYPE i_purchaseordertp_2,
          lt_poitem    TYPE STANDARD TABLE OF i_purchaseorderitemtp_2,
          lt_poitemacc TYPE STANDARD TABLE OF i_purordaccountassignmenttp_2.

    READ ENTITIES OF zi_spo_ses IN LOCAL MODE
          ENTITY zi_spo_ses
          ALL FIELDS
          WITH CORRESPONDING #( keys MAPPING commid = %param-newcommid )


*          // WITH CORRESPONDING #( keys mapping Commid = %param  )
          RESULT FINAL(header).
*reading data directly from zdt_expensecal_i table will check later to read it from view
*    READ ENTITY zi_expensecal
*         BY \_item
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT FINAL(lt_item)
*          FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    SELECT * FROM zdt_expensecal_i  WHERE commid = @gfs_header-commid INTO TABLE @DATA(lt_item).
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

      "code to update the item table
*      IF lt_failedpo IS NOT INITIAL.
*      ELSE.
*        LOOP AT GROUP ls_grp INTO gfs_item .
*          MODIFY ENTITIES OF zi_expensecal
*                     ENTITY zi_expensecal_i
*                     UPDATE FIELDS ( servicepobt )
*                     WITH VALUE #( (  commid   = gfs_item-commid
*                                   servicepobt  = abap_true
*                                 ) ).
*        ENDLOOP.
*      ENDIF.
ENDLOOP.
*
*
*
*
*    READ ENTITIES OF zi_expensecal
*         ENTITY zi_expensecal
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(header1).
*
*      READ ENTITY zi_expensecal
*            BY \_item
*             ALL FIELDS
*             WITH CORRESPONDING #( keys )
*             RESULT FINAL(lt_item1)
*             FAILED FINAL(lt_item_failed).

      LOOP AT lt_item INTO DATA(gfs_item1) .

        IF gfs_item1-servicepo IS INITIAL .
          lv_poref = gfs_item1-commid && gfs_item1-expansetype .
          SELECT SINGLE * FROM i_purchaseorderitemapi01 WHERE suppliermaterialnumber = @lv_poref INTO @DATA(ls_poline).
          IF sy-subrc EQ 0.

*            gfs_item1-servicepo     = ls_poline-purchaseorder.
*            gfs_item1-servicepoline = ls_poline-purchaseorderitem.

*          MODIFY ENTITIES OF zi_expensecal
*                     ENTITY zi_expensecal_i
*                     UPDATE FIELDS ( servicepobt )
*                     WITH VALUE #( ( commid   = gfs_item-commid
*
*                                   servicepobt      = abap_true
*                                   servicepo        = ls_poline-purchaseorder
*                                   servicepoline    = ls_poline-purchaseorderitem
*
*                                   %control-servicepobt   = if_abap_behv=>mk-on
*                                   %control-servicepo     = if_abap_behv=>mk-on
*                                   %control-servicepoline = if_abap_behv=>mk-on
*                                 ) ).
*            UPDATE zdt_expensecal_i
*            SET servicepobt = @abap_true,
*            servicepo = @ls_poline-purchaseorder,
*            servicepoline = @ls_poline-purchaseorderitem
*            WHERE commid = @gfs_item-commid.
*            if sy-subrc eq 0.
*            COMMIT WORK.
*            endif.
         ENDIF.
        ENDIF.
endloop.
*      IF gfs_item-serentrysheet IS INITIAL AND gfs_item-servicepo IS NOT INITIAL.
*
*        SELECT SINGLE a~serviceentrysheet
*         FROM i_serviceentrysheetapi01 AS a
*         INNER JOIN i_serviceentrysheetitemapi01 AS b ON a~serviceentrysheet = b~serviceentrysheet
*         WHERE a~purchaseorder     = @gfs_item-servicepo AND
*               b~purchaseorderitem = @gfs_item-servicepoline AND
*               a~isdeleted = ''
*        INTO @DATA(ls_serline).
*        IF sy-subrc EQ 0.
*          MODIFY ENTITIES OF zi_expensecal IN LOCAL MODE
*                     ENTITY zi_expensecal_i
*                     UPDATE FIELDS ( serviceentrybt serentrysheet )
*                     WITH VALUE #( ( %tky       = gfs_item-%tky
*
*                                   serviceentrybt   = abap_true
*                                   serentrysheet    = ls_serline
*
*                                   %control-serviceentrybt  = if_abap_behv=>mk-on
*                                   %control-serentrysheet   = if_abap_behv=>mk-on
*                                 ) ).
*        ENDIF.
*      ENDIF.
*
*    ENDLOOP.
*
*    READ ENTITIES OF zi_expensecal IN LOCAL MODE
*                 ENTITY zi_expensecal
*                 ALL FIELDS
*                 WITH CORRESPONDING #( keys )
*                 RESULT FINAL(item_upd).
*
*    result = VALUE #( FOR ls_itm_upd IN item_upd
*                          ( %tky   = ls_itm_upd-%tky
*                            %param = ls_itm_upd ) ).


*

* logic for SES

        DATA:
          ls_header_data TYPE i_serviceentrysheettp_2,
          ls_item_data   TYPE i_serviceentrysheetitemtp_2,

          lt_header_crt  TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet,
          lt_item_cba    TYPE TABLE FOR CREATE i_serviceentrysheettp_2\\serviceentrysheet\_serviceentrysheetitem.

        DATA: lv_num1     TYPE i.

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

*-------------------------------------------------------------------------------------------------------
*--- Get total Invoice base on Commercial Invoice
*Read item data again to get the updated entries
        SELECT * FROM zdt_expensecal_i  WHERE commid = @gfs_header-commid INTO TABLE @DATA(lt_item_ses).

        LOOP AT lt_item_ses INTO DATA(gfs_item_ses) WHERE serviceentrybt IS INITIAL  .
          CHECK gfs_item-servicepo IS NOT INITIAL AND gfs_item-servicepoline IS NOT INITIAL.

          lv_num = lv_num + 1 .

          SELECT SINGLE expansetypedesc
           FROM zi_expensetype_f4
           WHERE expansetype = @gfs_item_ses-expansetype INTO @DATA(ls_expensetxt_ses).


* Create SES with reference to a Service Purchase Order Item

*--- Prepare Header Data
          ls_header_data-serviceentrysheetname = ls_expensetxt_ses.
          ls_header_data-purchaseorder = gfs_item_ses-servicepo ."'2200000024'.
          ls_header_data-sesoriginobjecttype = 'EX'.

*--- Prepare Item Data
          ls_item_data-purchaseorderitem = gfs_item_ses-servicepoline. "'00010'.
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

ENDCLASS.
