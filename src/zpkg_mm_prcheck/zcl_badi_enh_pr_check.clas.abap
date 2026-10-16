CLASS zcl_badi_enh_pr_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mm_pur_s4_pr_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BADI_ENH_PR_CHECK IMPLEMENTATION.


  METHOD if_mm_pur_s4_pr_check~check.

*    DATA: lr_prdgrp TYPE RANGE OF i_product-productgroup.
*
***Requisition Item Validation for Amendment
*    IF purchaserequisitionitem_table IS NOT INITIAL.
*      SELECT purchaserequisition,
*             purchaserequisitionitem,
*             purchasereqncreationdate
*          FROM i_purchaserequisitionitemapi01
*          FOR ALL ENTRIES IN @purchaserequisitionitem_table
*          WHERE purchaserequisition = @purchaserequisitionitem_table-purchaserequisition
*          AND   purchaserequisitionitem = @purchaserequisitionitem_table-purchaserequisitionitem
*          INTO TABLE @DATA(lt_purchaserequisitionitem).
*      IF sy-subrc = 0.
*        LOOP AT purchaserequisitionitem_table ASSIGNING FIELD-SYMBOL(<lfs_purchasereqitem_t>).
*          IF <lfs_purchasereqitem_t>-isclosed IS INITIAL AND <lfs_purchasereqitem_t>-isdeleted IS INITIAL.
*            DATA(ls_purchaserequisitionitem) =  VALUE #( lt_purchaserequisitionitem[
*                                                purchaserequisition = <lfs_purchasereqitem_t>-purchaserequisition
*                                                purchaserequisitionitem = <lfs_purchasereqitem_t>-purchaserequisitionitem ] ).
*            IF ls_purchaserequisitionitem IS NOT INITIAL.
*              IF ls_purchaserequisitionitem-purchasereqncreationdate < cl_abap_context_info=>get_system_date(  ).
*                APPEND INITIAL LINE TO messages ASSIGNING FIELD-SYMBOL(<lfs_message>).
*                <lfs_message>-messagetype = 'E'.
*                <lfs_message>-messageid = 'ZMM'.
*                <lfs_message>-messagenumber = '000'.
*
*                purchaserequisitionhaserror = abap_true.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
*
***********************************************************************
**Validation PR Quantity
*    IF purchaserequisitionitem_table IS NOT INITIAL.
*      SELECT product,
*             plant,
*             maximumstockquantity
*      FROM i_prodplantsupplyplanningtp_2
*      FOR ALL ENTRIES IN @purchaserequisitionitem_table
*      WHERE product = @purchaserequisitionitem_table-material
*      AND plant = @purchaserequisitionitem_table-plant
*      INTO TABLE @DATA(lt_prodplant).
*      IF sy-subrc = 0.
*        SORT lt_prodplant BY product plant.
*      ENDIF.
*
*      SELECT product,
*             productgroup
*      FROM i_product
*      FOR ALL ENTRIES IN @purchaserequisitionitem_table
*      WHERE product = @purchaserequisitionitem_table-material
*      INTO TABLE @DATA(lt_product).
*      IF sy-subrc = 0.
*        SORT lt_product BY product.
*      ENDIF.
*
*      SELECT purchaserequisition,
*             purchaserequisitionitem,
*             material,
*             plant,
*             requestedquantity,
*             orderedquantity
*      FROM i_purchaserequisitionitemapi01
*      FOR ALL ENTRIES IN @purchaserequisitionitem_table
*      WHERE purchaserequisition <> @purchaserequisition-purchaserequisition
*      AND material = @purchaserequisitionitem_table-material
*      AND plant = @purchaserequisitionitem_table-plant
*      AND isdeleted = ''
*      AND isclosed  = ''
*      AND purreqnreleasestatus = '05'
*      INTO TABLE @DATA(lt_purreqplant).
*      IF sy-subrc = 0.
*        SORT lt_purreqplant BY material plant.
*      ENDIF.
*
*      SELECT product,
*             plant,
*             matlwrhsstkqtyinmatlbaseunit
*      FROM i_stockquantitycurrentvalue_2( p_displaycurrency = 'INR' )
*      FOR ALL ENTRIES IN @purchaserequisitionitem_table
*      WHERE product = @purchaserequisitionitem_table-material
*      AND plant = @purchaserequisitionitem_table-plant
*      AND valuationareatype = '1'
*      INTO TABLE @DATA(lt_plantstock).
*      IF sy-subrc = 0.
*        SORT lt_plantstock BY product plant.
*      ENDIF.
*
*      SELECT a~purchaseorder,
*             purchaseorderitem,
*             material,
*             plant,
*             orderquantity
*      FROM i_purchaseorderitemapi01 AS a
*      INNER JOIN i_purchaseorderapi01 AS b ON b~purchaseorder = a~purchaseorder
*      FOR ALL ENTRIES IN @purchaserequisitionitem_table
*      WHERE material = @purchaserequisitionitem_table-material
*      AND plant = @purchaserequisitionitem_table-plant
*      AND a~purchasingdocumentdeletioncode <> 'L'
*      AND iscompletelydelivered = ''
*      AND isreturnsitem = ''
*      AND b~purchasingprocessingstatus = '05'
*      INTO TABLE @DATA(lt_purpoplant).
*      IF sy-subrc = 0.
*        SORT lt_purpoplant BY material plant.
*
*        SELECT purchaseorder,
*               purchaseorderitem,
*               accountassignmentnumber,
*               purchasinghistorydocumenttype,
*               purchasinghistorydocumentyear,
*               purchasinghistorydocument,
*               purchasinghistorydocumentitem,
*               material,
*               plant,
*               goodsmovementtype,
*               quantity
*        FROM i_purchaseorderhistoryapi01
*        FOR ALL ENTRIES IN @lt_purpoplant
*        WHERE purchaseorder = @lt_purpoplant-purchaseorder
*        AND purchaseorderitem = @lt_purpoplant-purchaseorderitem
*        AND goodsmovementtype IN ( '101', '102', '122', '121' )
*        AND purchasinghistorydocumenttype = '1'
*        AND purchasinghistorycategory = 'E'
*        INTO TABLE @DATA(lt_purpoplanthistory).
*        IF sy-subrc = 0.
*          SORT lt_purpoplanthistory BY material plant.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    SELECT *
*    FROM zdt_prgroup_tmg
*    INTO TABLE @DATA(lt_prdgrp).
*    IF sy-subrc = 0.
*      LOOP AT lt_prdgrp INTO DATA(ls_prdgrp).
*        APPEND INITIAL LINE TO lr_prdgrp ASSIGNING FIELD-SYMBOL(<lfs_prdgrp>).
*        <lfs_prdgrp>-sign = 'I'.
*        <lfs_prdgrp>-option = 'EQ'.
*        <lfs_prdgrp>-low = ls_prdgrp-productgroup.
*      ENDLOOP.
*    ENDIF.
*
*    LOOP AT purchaserequisitionitem_table ASSIGNING FIELD-SYMBOL(<lfs_purchaserequisitionitem>).
*
*      DATA(ls_product) = VALUE #( lt_product[ product = <lfs_purchaserequisitionitem>-material
*                                            ] OPTIONAL ).
*      IF ls_product IS NOT INITIAL AND
*         ls_product-productgroup IN lr_prdgrp.
*        DATA(ls_prodplant) = VALUE #( lt_prodplant[ product = <lfs_purchaserequisitionitem>-material
*                                                    plant = <lfs_purchaserequisitionitem>-plant
*                                                  ] OPTIONAL ).
*        IF ls_prodplant IS NOT INITIAL.
*          IF ls_prodplant-maximumstockquantity > 0.
*            DATA(lv_requested_prqty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purreqplant IN lt_purreqplant
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant )
*                                                            NEXT lv_value = lv_value + ls_purreqplant-requestedquantity ).
*
*            DATA(lv_ordered_prqty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purreqplant IN lt_purreqplant
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant )
*                                                            NEXT lv_value = lv_value + ls_purreqplant-orderedquantity ).
*
*            DATA(lv_practualqty) = lv_requested_prqty - lv_ordered_prqty.
*
*            DATA(lv_availqty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_plantstock IN lt_plantstock
*                                                            WHERE ( product = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant )
*                                                            NEXT lv_value = lv_value + ls_plantstock-matlwrhsstkqtyinmatlbaseunit ).
*
*            DATA(lv_po_qty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purpoplant IN lt_purpoplant
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant )
*                                                            NEXT lv_value = lv_value + ls_purpoplant-orderquantity ).
*
*            DATA(lv_pohist_101_qty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purpoplanthistory IN lt_purpoplanthistory
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant AND
*                                                                    goodsmovementtype = '101' )
*                                                            NEXT lv_value = lv_value + ls_purpoplanthistory-quantity ).
*
*            DATA(lv_pohist_102_qty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purpoplanthistory IN lt_purpoplanthistory
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant AND
*                                                                    goodsmovementtype = '102' )
*                                                            NEXT lv_value = lv_value + ls_purpoplanthistory-quantity ).
*
*            DATA(lv_pohist_122_qty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purpoplanthistory IN lt_purpoplanthistory
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant AND
*                                                                    goodsmovementtype = '122' )
*                                                            NEXT lv_value = lv_value + ls_purpoplanthistory-quantity ).
*
*            DATA(lv_pohist_121_qty) = REDUCE menge_d( INIT lv_value TYPE menge_d
*                                                            FOR ls_purpoplanthistory IN lt_purpoplanthistory
*                                                            WHERE ( material = <lfs_purchaserequisitionitem>-material AND
*                                                                    plant = <lfs_purchaserequisitionitem>-plant AND
*                                                                    goodsmovementtype = '121' )
*                                                            NEXT lv_value = lv_value + ls_purpoplanthistory-quantity ).
*
*            DATA(lv_poactualqty) = lv_po_qty + lv_pohist_102_qty + lv_pohist_122_qty - ( lv_pohist_101_qty + lv_pohist_121_qty ).
*
*            DATA(lv_actualstockinplant) = ls_prodplant-maximumstockquantity - ( lv_practualqty + lv_poactualqty + lv_availqty ).
*
*            IF <lfs_purchaserequisitionitem>-orderedquantity > lv_actualstockinplant.
*              APPEND INITIAL LINE TO messages ASSIGNING <lfs_message>.
*              <lfs_message>-messagetype = 'E'.
*              <lfs_message>-messageid = 'ZMM'.
*              <lfs_message>-messagenumber = '001'.
*              <lfs_message>-messagevariable1 = <lfs_purchaserequisitionitem>-purchaserequisitionitem.
*              <lfs_message>-messagevariable2 = <lfs_purchaserequisitionitem>-material.
*
*              purchaserequisitionhaserror = abap_true.
*            ENDIF.
*          ELSE.
*            APPEND INITIAL LINE TO messages ASSIGNING <lfs_message>.
*            <lfs_message>-messagetype = 'E'.
*            <lfs_message>-messageid = 'ZMM'.
*            <lfs_message>-messagenumber = '002'.
*            <lfs_message>-messagevariable1 = <lfs_purchaserequisitionitem>-purchaserequisitionitem.
*            <lfs_message>-messagevariable2 = <lfs_purchaserequisitionitem>-material.
*
*            purchaserequisitionhaserror = abap_true.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*      CLEAR:    ls_product,
*                ls_prodplant,
*                lv_requested_prqty,
*                lv_ordered_prqty,
*                lv_actualstockinplant,
*                lv_practualqty,
*                lv_poactualqty,
*                lv_availqty,
*                lv_po_qty,
*                lv_pohist_102_qty,
*                lv_pohist_101_qty,
*                lv_pohist_121_qty,
*                lv_pohist_122_qty.
*    ENDLOOP.
*
*
*    DATA: lo_test TYPE REF TO zcl_test.
*
*    CREATE OBJECT lo_test.
*
*    call METHOD lo_test->test.

  ENDMETHOD.
ENDCLASS.
