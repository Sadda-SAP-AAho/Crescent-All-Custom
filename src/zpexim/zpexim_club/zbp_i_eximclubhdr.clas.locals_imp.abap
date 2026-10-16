CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS Cancel FOR MODIFY
      IMPORTING keys FOR ACTION head~Cancel RESULT result.

    METHODS release FOR MODIFY
      IMPORTING keys FOR ACTION head~release RESULT result.

    METHODS updatefields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~updatefields.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~validate.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    result = VALUE #( FOR ls_header IN lt_header
                      (

                      %tky              = ls_header-%tky


                      %update           = COND #( WHEN ls_header-released = ''
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  ELSE if_abap_behv=>fc-o-disabled
                                                )

                     %assoc-_item        = COND #( WHEN ls_header-released = ''
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled
                                                )

                     %field-clubcomment  = COND #( WHEN ls_header-released = ''
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled
                                                )

*                     %field-documenttype = COND #( WHEN ls_header-released = ''
*                                                   THEN if_abap_behv=>fc-o-enabled
*                                                   ELSE if_abap_behv=>fc-o-disabled
*                                                )

                     %action-Release     = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled
                                                )

                     %action-Cancel      = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled
                                                )

                    )
                    ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD Cancel.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.
      MODIFY ENTITIES OF zi_eximclubhdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( deleted )
         WITH VALUE #(
                            ( %tky    = ls_header-%tky
                              deleted = 'X'
                            ) ).
    ENDIF.
    CLEAR: ls_header.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT lt_header
      FAILED lt_header_failed.

    result = VALUE #( FOR ls_header_t IN lt_header
                      ( %tky   = ls_header_t-%tky
                        %param = ls_header_t ) ).

  ENDMETHOD.

  METHOD Release.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.
      MODIFY ENTITIES OF zi_eximclubhdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( released )
         WITH VALUE #(
                            ( %tky      = ls_header-%tky
                              released = 'X'
                            ) ).
    ENDIF.
    CLEAR: ls_header.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT lt_header
      FAILED lt_header_failed.

    result = VALUE #( FOR ls_header_t IN lt_header
                      ( %tky   = ls_header_t-%tky
                        %param = ls_header_t ) ).

  ENDMETHOD.

  METHOD updatefields.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    GET TIME STAMP FIELD DATA(lv_utctimestamp).
    CONVERT TIME STAMP lv_utctimestamp  TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      SELECT SINGLE *
        FROM zi_eximclubdoctype
        WHERE value_low = @ls_header-documenttype
        INTO @DATA(ls_zi_eximclubdoctype).

      TRY.
          DATA(lv_user) = cl_abap_context_info=>get_user_formatted_name(  ).
        CATCH cx_abap_context_info_error .
      ENDTRY.


      MODIFY ENTITIES OF zi_eximclubhdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( clubnointernal documenttypedesc cdate ctime cuser )
         WITH VALUE #(
                            ( %tky  = ls_header-%tky
                              clubnointernal = lv_date+0(4) && |-| && lv_date+4(2) && |-| && ls_header-clubnoexternal
                              documenttypedesc = ls_zi_eximclubdoctype-text
                              cdate = lv_date
                              ctime = lv_time
                              cuser = lv_user
                            ) ).
    ENDIF.
    CLEAR: ls_header.

  ENDMETHOD.

  METHOD validate.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    READ ENTITY zi_eximclubhdr
    BY \_item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      SELECT SINGLE *
          FROM zexim_club_hdr
          WHERE clubnoexternal = @ls_header-clubnoexternal
          INTO @DATA(ls_zexim_club_hdr).
      IF sy-subrc = 0.
        APPEND VALUE #(
        %tky                        = ls_header-%tky
        %state_area                 = 'Validate_Head'
        %msg                        = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Please provide a unique Clubbing No'
        )
        %element-clubcomment = if_abap_behv=>mk-on
        ) TO reported-head.

        APPEND VALUE #(
         %tky = ls_header-%tky
        ) TO failed-head.
      ENDIF.

      IF ls_header-clubcomment IS INITIAL.
        APPEND VALUE #(
        %tky                        = ls_header-%tky
        %state_area                 = 'Validate_Head'
        %msg                        = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Comment is mandatory'
        )
        %element-clubcomment = if_abap_behv=>mk-on
        ) TO reported-head.

        APPEND VALUE #(
         %tky = ls_header-%tky
        ) TO failed-head.
      ENDIF.
    ENDIF.

    SELECT *
        FROM zexim_club_itm AS a
        INNER JOIN zexim_club_hdr AS b ON b~id = a~id
        FOR ALL ENTRIES IN @lt_item
        WHERE invoice = @lt_item-invoice
        AND   posnr = @lt_item-posnr
        AND   deleted = ''
        INTO TABLE @DATA(lt_zexim_club_itm).
    IF sy-subrc = 0.
      SORT lt_zexim_club_itm BY a-invoice a-posnr.
    ENDIF.

    LOOP AT lt_zexim_club_itm INTO DATA(ls_zexim_club_itm).
      DATA(ls_item) = VALUE #( lt_item[ invoice = ls_zexim_club_itm-a-invoice
                                        posnr   = ls_zexim_club_itm-a-posnr
                                        ] OPTIONAL ).
      IF ls_item IS NOT INITIAL.
        APPEND VALUE #(
        %tky                        = ls_header-%tky
        %state_area                 = 'Validate_Head'
        %msg                        = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Invoice/Item already tagged in -' && ls_zexim_club_itm-b-clubnoexternal
        )
        %element-clubcomment = if_abap_behv=>mk-on
        ) TO reported-head.

        APPEND VALUE #(
         %tky = ls_header-%tky
        ) TO failed-head.
      ENDIF.
      CLEAR: ls_item.
    ENDLOOP.

    IF lines( lt_item ) = 0.
      APPEND VALUE #(
      %tky                        = ls_header-%tky
      %state_area                 = 'Validate_Head'
      %msg                        = new_message_with_text(
      severity = if_abap_behv_message=>severity-error
      text     = 'No Lines are present'
      )
      %element-clubcomment = if_abap_behv=>mk-on
      ) TO reported-head.

      APPEND VALUE #(
       %tky = ls_header-%tky
      ) TO failed-head.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.

    METHODS invoicedata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~invoicedata.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item)
      FAILED DATA(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.
      result = VALUE #( FOR ls_item IN lt_item
                        (

                        %tky    = ls_item-%tky

                        %update = COND #(
                                          WHEN ls_header-released = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled
                        )

                        %delete = COND #(
                                          WHEN ls_header-released = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled
                        )

                      )
                      ).
    ENDIF.

  ENDMETHOD.

  METHOD invoicedata.

    DATA: lv_fob_amount   TYPE zexim_club_hdr-fobamount,
          lv_fob_currency TYPE zexim_club_hdr-fobcurrency.

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    READ ENTITIES OF zi_eximclubhdr IN LOCAL MODE
         ENTITY item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         FAILED FINAL(lt_item_failed).

    SELECT *
        FROM zi_clubbildocf4tp_1
        FOR ALL ENTRIES IN @lt_item
        WHERE BillingCombo = @lt_item-choose
        INTO TABLE @DATA(lt_zi_clubbildocf4tp_1).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      LOOP AT lt_item INTO DATA(ls_item).
        DATA(ls_zi_clubbildocf4tp_1) = VALUE #( lt_zi_clubbildocf4tp_1[ BillingCombo = ls_item-choose ] OPTIONAL ).
        IF ls_zi_clubbildocf4tp_1 IS NOT INITIAL.
          ls_item-invoice = ls_zi_clubbildocf4tp_1-BillingDocument.
          ls_item-posnr = ls_zi_clubbildocf4tp_1-BillingDocumentItem.
          ls_item-matnr = ls_zi_clubbildocf4tp_1-Product.
          ls_item-maktx = ls_zi_clubbildocf4tp_1-BillingDocumentItemText.
          ls_item-hsnsac = ls_zi_clubbildocf4tp_1-hsnsac.
          ls_item-availableqty = ls_zi_clubbildocf4tp_1-BillingQuantity.
          ls_item-appliedqty = ls_zi_clubbildocf4tp_1-BillingQuantity.
          ls_item-uom = ls_zi_clubbildocf4tp_1-BillingQuantityUnit.
          ls_item-netprice = ls_zi_clubbildocf4tp_1-UnitPrice.
          ls_item-netvalue = ls_zi_clubbildocf4tp_1-NetAmount.
          ls_item-currency = ls_zi_clubbildocf4tp_1-TransactionCurrency.
          ls_item-netweight = ls_zi_clubbildocf4tp_1-ItemNetWeight.
          ls_item-grossweight = ls_zi_clubbildocf4tp_1-ItemGrossWeight.
          ls_item-plant = ls_zi_clubbildocf4tp_1-Plant.

          lv_fob_amount = lv_fob_amount + ls_item-netvalue.
          lv_fob_currency = ls_item-currency.
        ENDIF.
        CLEAR: ls_zi_clubbildocf4tp_1.

        MODIFY ENTITIES OF zi_eximclubhdr IN LOCAL MODE
               ENTITY item
               UPDATE
               FIELDS ( clubnointernal invoice posnr matnr maktx hsnsac availableqty appliedqty uom netprice netvalue currency netweight grossweight plant )
               WITH VALUE #( ( %tky             = ls_item-%tky
                               clubnointernal   = ls_header-clubnointernal
                               invoice          = ls_item-invoice
                               posnr            = ls_item-posnr
                               matnr            = ls_item-matnr
                               maktx            = ls_item-maktx
                               hsnsac           = ls_item-hsnsac
                               availableqty     = ls_item-availableqty
                               appliedqty       = ls_item-appliedqty
                               uom              = ls_item-uom
                               netprice         = ls_item-netprice
                               netvalue         = ls_item-netvalue
                               currency         = ls_item-currency
                               netweight        = ls_item-netweight
                               grossweight      = ls_item-grossweight
                               plant            = ls_item-plant
                            ) ).
      ENDLOOP.

      MODIFY ENTITIES OF zi_eximclubhdr IN LOCAL MODE
              ENTITY head
              UPDATE
              FIELDS ( fobamount fobcurrency )
              WITH VALUE #( ( %tky   = ls_header-%tky
                              fobamount = lv_fob_amount
                              fobcurrency = lv_fob_currency ) ).
    ENDIF.



  ENDMETHOD.

ENDCLASS.
