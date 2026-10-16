CLASS lhc_zr_boetp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR zr_boetp RESULT result.

    METHODS change_details FOR DETERMINE ON MODIFY            IMPORTING keys FOR zr_boetp~change_details.

    METHODS save_details FOR VALIDATE ON SAVE              IMPORTING keys FOR zr_boetp~save_details.

ENDCLASS.


CLASS lhc_zr_boetp IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD change_details.
  ENDMETHOD.

  METHOD save_details.

    DATA lv_usage   TYPE zex_licence_hdr-exportvalueinr_v.
    DATA lv_invoice TYPE zex_licence_hdr-exportvalueinr_v.

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boetp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    READ ENTITY zr_boetp
         BY \_boelic
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lic)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lic_failed).

    READ ENTITY zr_boetp
         BY \_boeitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).

    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF <lfs_head>-exchangerate IS INITIAL.
      APPEND VALUE #( %tky                  = <lfs_head>-%tky
                      %state_area           = 'Validate_Header'
                      %msg                  = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     = 'Please provide the exchange rate' )
                      %element-exchangerate = if_abap_behv=>mk-on )
             TO reported-zr_boetp.

      APPEND VALUE #( %tky = <lfs_head>-%tky )
             TO failed-zr_boetp.
    ENDIF.

    LOOP AT lic ASSIGNING FIELD-SYMBOL(<lfs_lic>).
      IF <lfs_lic>-usageamount > <lfs_lic>-pendingamount.
        DATA(lv_msg) = |License Usage Amount is greater than Pending Amount|.

        APPEND VALUE #( %tky = <lfs_head>-%tky )
               TO failed-zr_boetp.

        APPEND VALUE #( %tky               = <lfs_head>-%tky
                        %state_area        = 'Validate_Header'
                        %msg               = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg )
                        %element-boenumber = if_abap_behv=>mk-on )
               TO reported-zr_boetp.
      ENDIF.

      lv_usage += <lfs_lic>-usageamount.
    ENDLOOP.

    LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      lv_invoice += <lfs_item>-totaldutysaved.
    ENDLOOP.

    IF lv_invoice > lv_usage.

      lv_msg = |Sum of the Duty saved Amt. > License Usage Amt. |.

      APPEND VALUE #( %tky = <lfs_head>-%tky )
             TO failed-zr_boetp.

      APPEND VALUE #( %tky               = <lfs_head>-%tky
                      %state_area        = 'Validate_Header'
                      %msg               = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = lv_msg )
                      %element-boenumber = if_abap_behv=>mk-on )
             TO reported-zr_boetp.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zr_boeitemtp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS change_details FOR DETERMINE ON MODIFY IMPORTING keys FOR zr_boeitemtp~change_details.
    METHODS change_assessbleamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_boeitemtp~change_assessbleamt.

ENDCLASS.


CLASS lhc_zr_boeitemtp IMPLEMENTATION.

  METHOD change_details.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_assessable TYPE zim_boe_item-assessablevalue.

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boetp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boeitemtp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).

    SELECT * FROM zi_podet_3
      FOR ALL ENTRIES IN @item
      WHERE purchaseorder     = @item-po
        AND purchaseorderitem = @item-poitem
      INTO TABLE @DATA(lt_poitem).
    IF sy-subrc = 0.
      SORT lt_poitem BY purchaseorder
                        purchaseorderitem.
    ENDIF.

    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      TRY.
          <lfs_item>-poitem          = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-purchaseorderitem.
          <lfs_item>-material        = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-material.
          <lfs_item>-makxt           = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-purchaseorderitemtext.
          <lfs_item>-povalue         = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-netamount.
          <lfs_item>-poqty           = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-orderquantity.

          <lfs_item>-unit           = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-baseunit.

***          <lfs_item>-assessablevalue = <lfs_head>-exchangerate * <lfs_item>-povalue.
          <lfs_item>-dutycurrency    = 'INR'.
          <lfs_item>-currency        = lt_poitem[ purchaseorder     = <lfs_item>-po
                                                  purchaseorderitem = <lfs_item>-poitem ]-documentcurrency.

          <lfs_head>-supplier     = lt_poitem[ purchaseorder     = <lfs_item>-po
                                               purchaseorderitem = <lfs_item>-poitem ]-supplier.
          <lfs_head>-suppliername = lt_poitem[ purchaseorder     = <lfs_item>-po
                                               purchaseorderitem = <lfs_item>-poitem ]-suppliername.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      lv_assessable += <lfs_item>-assessablevalue.

      MODIFY ENTITIES OF zr_boetp IN LOCAL MODE
             ENTITY zr_boeitemtp
             UPDATE
             FIELDS ( poitem material makxt povalue poqty assessablevalue currency dutycurrency unit )
             WITH VALUE #( ( %tky            = <lfs_item>-%tky
                             poitem          = <lfs_item>-poitem
                             material        = <lfs_item>-material
                             makxt           = <lfs_item>-makxt
                             povalue         = <lfs_item>-povalue
                             poqty           = <lfs_item>-poqty
                             assessablevalue = <lfs_item>-assessablevalue
                             currency        = <lfs_item>-currency
                             dutycurrency    = <lfs_item>-dutycurrency
                             unit            = <lfs_item>-unit
                             ) ).

    ENDLOOP.

    MODIFY ENTITIES OF zr_boetp IN LOCAL MODE
           ENTITY zr_boetp
           UPDATE
           FIELDS ( supplier suppliername assessableamount )
           WITH VALUE #( ( %tky             = <lfs_head>-%tky
                           supplier         = <lfs_head>-supplier
                           suppliername     = <lfs_head>-suppliername
                           assessableamount = <lfs_head>-assessableamount ) ).

  ENDMETHOD.

  METHOD change_assessbleamt.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_assessable TYPE zim_boe_item-assessablevalue.

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boetp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boeitemtp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).

    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      CHECK <lfs_item>-assessablevaluefc IS NOT INITIAL .
      IF  <lfs_item>-currency <> 'INR'.
        <lfs_item>-assessablevalue = <lfs_head>-exchangerate * <lfs_item>-assessablevaluefc.
      ENDIF.

      MODIFY ENTITIES OF zr_boetp IN LOCAL MODE
             ENTITY zr_boeitemtp
             UPDATE
             FIELDS ( assessablevalue )
             WITH VALUE #( ( %tky            = <lfs_item>-%tky
                             assessablevalue = <lfs_item>-assessablevalue
                           ) ).

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.


CLASS lhc_zr_boelictp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS change_details FOR DETERMINE ON MODIFY IMPORTING keys FOR zr_boelictp~change_details.
    METHODS update_utilization FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_boelictp~update_utilization.

ENDCLASS.


CLASS lhc_zr_boelictp IMPLEMENTATION.

  METHOD change_details.

    DATA: lt_epcg_ultdata TYPE STANDARD TABLE OF zr_licence_hdr.

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boetp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(head)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(head_failed).

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boelictp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lic_failed).

    ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

* //== Get All Utilization EPCG license Data ==//
    SELECT a~* FROM zr_licence_hdr AS a
             INNER JOIN @lt_item AS b ON a~licenceint = b~licencint
             APPENDING CORRESPONDING FIELDS OF TABLE @lt_epcg_ultdata.

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).

      "//== Get License Details ==//
      READ TABLE lt_epcg_ultdata INTO DATA(ls_epcg_ultdata) WITH KEY licenceint = <lfs_item>-licencint .
      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM zdt_boe_lic WHERE licenceint = @<lfs_item>-licencint INTO @DATA(ls_boe_lic).

        <lfs_item>-assignamount  = ( ls_epcg_ultdata-boeusage + ls_epcg_ultdata-shipusage ) +  <lfs_item>-usageamount .
*        - ls_boe_lic-usageamount.
        <lfs_item>-pendingamount =  ls_epcg_ultdata-plandutysaveinr - <lfs_item>-assignamount .

        MODIFY ENTITIES OF zr_boetp IN LOCAL MODE
               ENTITY zr_boelictp
               UPDATE
               FIELDS ( assignamount pendingamount )
               WITH VALUE #( ( %tky          = <lfs_item>-%tky
                               assignamount  = <lfs_item>-assignamount
                               pendingamount = <lfs_item>-pendingamount
                             ) ).
      ENDIF.
    ENDLOOP.

***    MODIFY ENTITIES OF zr_boetp  IN LOCAL MODE
***           ENTITY zr_boetp
***           UPDATE
***           FIELDS ( usageamount )
***           WITH VALUE #( ( %tky        = <lfs_head>-%tky
***                           usageamount = <lfs_head>-usageamount ) ).

  ENDMETHOD.

  METHOD update_utilization.

    DATA: lt_epcg_ultdata TYPE STANDARD TABLE OF zr_licence_hdr.

*//===============================================================//
    READ ENTITIES OF zr_boetp IN LOCAL MODE
                 ENTITY zr_boetp
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header)
                 FAILED FINAL(header_failed).

    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ) .

    READ ENTITIES OF zr_boetp IN LOCAL MODE
         ENTITY zr_boelictp
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         FAILED FINAL(lt_item_failed).
*//===============================================================//

    CHECK lt_item[] IS NOT INITIAL .
    CLEAR :lt_epcg_ultdata[].

* //== Get All Utilization EPCG license Data ==//
    SELECT a~* FROM zr_licence_hdr AS a
             INNER JOIN @lt_item AS b ON a~licenceint = b~licencint
             APPENDING CORRESPONDING FIELDS OF TABLE @lt_epcg_ultdata.

* //== Update Line item Field ==//
    LOOP AT lt_item INTO DATA(ls_item).

      "//== Get License Details ==//
      READ TABLE lt_epcg_ultdata INTO DATA(ls_epcg_ultdata) WITH KEY licenceint = ls_item-licencint .
      IF sy-subrc EQ 0.
        ls_item-licencenumber = ls_epcg_ultdata-licenceext  .
        ls_item-assignamount  = ( ls_epcg_ultdata-boeusage + ls_epcg_ultdata-shipusage ) .
        ls_item-pendingamount =  ls_epcg_ultdata-plandutysaveinr - ls_item-assignamount .

      ENDIF.

* //== Modify Entities Line item Field ==//
      MODIFY ENTITIES OF zr_boetp IN LOCAL MODE
              ENTITY zr_boelictp
              UPDATE
              FIELDS ( assignamount pendingamount usageamount licencenumber )
              WITH VALUE #( (   %tky           = ls_item-%tky

                              assignamount     = ls_item-assignamount
                              pendingamount    = ls_item-pendingamount
                              usageamount      = ls_item-usageamount
                              licencenumber    = ls_item-licencenumber
                              ) ).
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
