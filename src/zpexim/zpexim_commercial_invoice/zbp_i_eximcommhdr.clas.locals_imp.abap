CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS Cancel FOR MODIFY
      IMPORTING keys FOR ACTION head~Cancel RESULT result.

    METHODS Print FOR MODIFY
      IMPORTING keys FOR ACTION head~Print RESULT result.

    METHODS Release FOR MODIFY
      IMPORTING keys FOR ACTION head~Release RESULT result.

    METHODS updatefields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~updatefields.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~updateitem.

    METHODS validatehead FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~validatehead.

    METHODS validateoverall FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~validateoverall.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
       ENTITY head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       FAILED FINAL(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      SELECT SINGLE *
          FROM zexim_comm_hdr
          WHERE id = @ls_header-id
          INTO @DATA(ls_zexim_comm_hdr).
      IF sy-subrc = 0.
        DATA(lv_oldentry) = 'X'.
      ENDIF.

      result = VALUE #( FOR ls_header_t IN lt_header
                        (

                        %tky               = ls_header_t-%tky


                        %update            = COND #( WHEN ls_header_t-released = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header_t-released = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_itm         = COND #( WHEN lv_oldentry = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_add         = COND #( WHEN ls_header_t-released = '' AND ls_header_t-Deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_cnh         = COND #( WHEN ls_header_t-released = '' AND ls_header_t-Deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_cni         = COND #( WHEN ls_header_t-released = '' AND ls_header_t-Deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_cus         = COND #( WHEN ls_header_t-released = '' AND ls_header_t-Deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_pay         = COND #( WHEN ls_header_t-released = '' AND ls_header_t-Deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %assoc-_shp         = COND #( WHEN ls_header_t-released = '' AND ls_header_t-Deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %action-Release     = COND #( WHEN ls_header_t-released = '' AND ls_header_t-deleted = ''
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled
                                                  )

                       %action-Cancel      = COND #( WHEN ls_header_t-released = '' AND ls_header_t-deleted = ''
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).

    ENDIF.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD Cancel.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
       ENTITY head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       FAILED FINAL(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.
      MODIFY ENTITIES OF zi_eximcommhdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( Deleted Status )
         WITH VALUE #(
                            ( %tky    = ls_header-%tky
                              Deleted = 'X'
                              Status  = 'Cancelled'
                            ) ).
    ENDIF.
    CLEAR: ls_header.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_ret)
      FAILED DATA(lt_header_failed_ret).

    result = VALUE #( FOR ls_header_ret IN lt_header_ret
                      ( %tky   = ls_header_ret-%tky
                        %param = ls_header_ret ) ).

  ENDMETHOD.

  METHOD Print.
  ENDMETHOD.

  METHOD Release.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
       ENTITY head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_header)
       FAILED FINAL(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.
      MODIFY ENTITIES OF zi_eximcommhdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( released Status )
         WITH VALUE #(
                            ( %tky      = ls_header-%tky
                              released  = 'X'
                              Status    = 'Released'
                            ) ).
    ENDIF.
    CLEAR: ls_header.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
    ENTITY head
    ALL FIELDS
    WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_ret)
      FAILED DATA(lt_header_failed_ret).

    result = VALUE #( FOR ls_header_ret IN lt_header_ret
                      ( %tky   = ls_header_ret-%tky
                        %param = ls_header_ret ) ).

  ENDMETHOD.

  METHOD updatefields.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS WITH
     CORRESPONDING #( keys )
     RESULT FINAL(lt_head).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head IS NOT INITIAL.

      SELECT SINGLE *
        FROM zc_eximclubhdr_f4
        WHERE clubnointernal = @ls_head-Invclubnointernal
        INTO @DATA(ls_zc_eximclubhdr).

      GET TIME STAMP FIELD DATA(lv_utctimestamp).
      CONVERT TIME STAMP lv_utctimestamp  TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).

      TRY.
          DATA(lv_user) = cl_abap_context_info=>get_user_formatted_name(  ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      MODIFY ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        UPDATE
            FIELDS ( invclubnoexternal invclubnodate invcommdate invcommuser invcommtime fobamount fobcurrency Status )
            WITH VALUE #(
                           ( %tky               = ls_head-%tky
                             invclubnoexternal  = ls_zc_eximclubhdr-clubnoexternal
                             invclubnodate      = ls_zc_eximclubhdr-cdate
                             invcommdate        = lv_date
                             invcommuser        = lv_user
                             invcommtime        = lv_time
                             fobamount          = ls_zc_eximclubhdr-fobamount
                             fobcurrency        = ls_zc_eximclubhdr-fobcurrency
                             Status             = 'In Process'
                           ) ).
    ENDIF.
  ENDMETHOD.

  METHOD updateitem.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
       ENTITY head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_head).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head IS NOT INITIAL.

      SELECT SINGLE *
          FROM zexim_comm_hdr
          WHERE id = @ls_head-id
          INTO @DATA(ls_zexim_comm_hdr).
      IF sy-subrc <> 0.

        SELECT a~fobamount,
               a~fobcurrency,
               b~invoice,
               b~posnr,
               b~matnr,
               b~maktx,
               b~hsnsac,
               b~availableqty,
               b~appliedqty,
               b~uom,
               b~netprice,
               b~netvalue,
               b~currency,
               b~netweight,
               b~grossweight
            FROM zexim_club_hdr AS a
            INNER JOIN zexim_club_itm AS b ON b~id = a~id
            WHERE a~clubnoexternal = @ls_head-Invclubnoexternal
            INTO TABLE @DATA(lt_invclubitem).
        IF sy-subrc = 0.
          SORT lt_invclubitem BY invoice posnr.

          SELECT  a~BillingDocument,
                  a~BillingDocumentitem,
                  a~ReferenceSDDocument,
                  a~ReferenceSDDocumentItem,
                  a~SalesDocument,
                  a~SalesDocumentItem,
                  b~AssignmentReference
              FROM I_BillingDocumentItem AS a
              INNER JOIN I_BillingDocument AS b ON b~BillingDocument = a~BillingDocument
              FOR ALL ENTRIES IN @lt_invclubitem
              WHERE a~BillingDocument = @lt_invclubitem-invoice
              AND   a~BillingDocumentItem = @lt_invclubitem-posnr
              INTO TABLE @DATA(lt_billingdocitem).
          IF sy-subrc = 0.
            SORT lt_billingdocitem BY BillingDocument BillingDocumentItem.
          ENDIF.
        ENDIF.

        LOOP AT lt_invclubitem INTO DATA(ls_invclubitem).
          DATA(ls_billingdocitem) = VALUE #( lt_billingdocitem[ BillingDocument = ls_invclubitem-invoice
                                                                BillingDocumentItem = ls_invclubitem-posnr
                                                              ] OPTIONAL ).
          IF ls_billingdocitem IS NOT INITIAL.

            MODIFY ENTITIES OF zi_eximcommhdr IN LOCAL MODE
                   ENTITY head
                   CREATE BY \_itm
                   FROM VALUE #( ( id      = ls_head-id
                                   %target = VALUE #( (     %cid                = ls_invclubitem-invoice && ls_invclubitem-posnr

                                                            Invoice             = ls_invclubitem-invoice
                                                            Invoiceitem         = ls_invclubitem-posnr
                                                            Material            = ls_invclubitem-matnr
                                                            Materialdescription = ls_invclubitem-maktx
                                                            Uom                 = ls_invclubitem-uom
                                                            Quantity            = ls_invclubitem-appliedqty
                                                            Weightuom           = ls_invclubitem-uom
                                                            Netweight           = ls_invclubitem-netweight
                                                            Grossweight         = ls_invclubitem-grossweight
                                                            Currency            = ls_invclubitem-currency
                                                            Rate                = ls_invclubitem-netprice
                                                            Amount              = ls_invclubitem-netvalue
                                                            Harmoniccode        = ls_invclubitem-hsnsac
                                                            Delivery            = ls_billingdocitem-ReferenceSDDocument
                                                            Deliveryitem        = ls_billingdocitem-ReferenceSDDocumentItem
                                                            Salesorder          = ls_billingdocitem-SalesDocument
                                                            Salesorderitem      = ls_billingdocitem-SalesDocumentItem
                                                            Reference           = ls_billingdocitem-AssignmentReference

                                                            %control-Invoice              = if_abap_behv=>mk-on
                                                            %control-Invoiceitem          = if_abap_behv=>mk-on
                                                            %control-Material             = if_abap_behv=>mk-on
                                                            %control-Materialdescription  = if_abap_behv=>mk-on
                                                            %control-Uom                  = if_abap_behv=>mk-on
                                                            %control-Quantity             = if_abap_behv=>mk-on
                                                            %control-Weightuom            = if_abap_behv=>mk-on
                                                            %control-Netweight            = if_abap_behv=>mk-on
                                                            %control-Grossweight          = if_abap_behv=>mk-on
                                                            %control-Currency             = if_abap_behv=>mk-on
                                                            %control-Rate                 = if_abap_behv=>mk-on
                                                            %control-Amount               = if_abap_behv=>mk-on
                                                            %control-Harmoniccode         = if_abap_behv=>mk-on
                                                            %control-Delivery             = if_abap_behv=>mk-on
                                                            %control-Deliveryitem         = if_abap_behv=>mk-on
                                                            %control-Salesorder           = if_abap_behv=>mk-on
                                                            %control-Salesorderitem       = if_abap_behv=>mk-on
                                                            %control-Reference            = if_abap_behv=>mk-on
                                                        ) ) ) )
                   MAPPED FINAL(ls_mapped)
                   FAILED FINAL(ls_failed)
                   REPORTED FINAL(ls_reported).

          ENDIF.
          CLEAR: ls_billingdocitem.
        ENDLOOP.
      ENDIF.
    ENDIF.
    CLEAR: ls_head.

  ENDMETHOD.

  METHOD validatehead.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
       ENTITY head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_head).

*--Header Validation
    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head IS NOT INITIAL.


    ENDIF.

  ENDMETHOD.

  METHOD validateoverall.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
       ENTITY head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_head).

    READ ENTITY zi_eximcommhdr
       BY \_itm
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_invoiceitem).

    READ ENTITY zi_eximcommhdr
       BY \_cus
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_custaddress).

    READ ENTITY zi_eximcommhdr
       BY \_pay
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_payment).

    READ ENTITY zi_eximcommhdr
       BY \_shp
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT FINAL(lt_shipping).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head IS NOT INITIAL.

      SELECT SINGLE *
          FROM zexim_comm_hdr
          WHERE id = @ls_head-id
          INTO @DATA(ls_zexim_comm_hdr).
      IF sy-subrc = 0.
        DATA(lv_oldentry) = 'X'.
      ENDIF.

      IF lv_oldentry = 'X' AND ls_head-Released = 'X'.

*--Invoice Item Validation
        IF lines( lt_invoiceitem ) = 0.
          APPEND VALUE #(
          %tky                      = ls_head-%tky
          %state_area               = 'Validate_Head'
          %msg                      = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'No Invoice Items found'
          )
          %element-dateofdischarge = if_abap_behv=>mk-on
          ) TO reported-head.

          APPEND VALUE #(
          %tky = ls_head-%tky
          ) TO failed-head.
        ENDIF.

        LOOP AT lt_invoiceitem INTO DATA(ls_invoiceitem).
          IF ls_invoiceitem-Netweight IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Please provide a Net Weight in the Line Item -' && | | && sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.

          IF ls_invoiceitem-Grossweight IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Please provide a Gross Weight in the Line Item -' && | | && sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.
        ENDLOOP.

*--Customer Address Validation
        IF lines( lt_custaddress ) = 0.
          APPEND VALUE #(
          %tky                      = ls_head-%tky
          %state_area               = 'Validate_Head'
          %msg                      = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'No Address Items found'
          )
          %element-dateofdischarge = if_abap_behv=>mk-on
          ) TO reported-head.

          APPEND VALUE #(
          %tky = ls_head-%tky
          ) TO failed-head.
        ENDIF.

        DATA(ls_custaddress) = VALUE #( lt_custaddress[ Addresstype = '1' ] OPTIONAL ).
        IF ls_custaddress IS NOT INITIAL.
          ls_custaddress = VALUE #( lt_custaddress[ Addresstype = '2' ] OPTIONAL ).
          IF ls_custaddress IS NOT INITIAL.
            ls_custaddress = VALUE #( lt_custaddress[ Addresstype = '3' ] OPTIONAL ).
            IF ls_custaddress IS NOT INITIAL.
              ls_custaddress = VALUE #( lt_custaddress[ Addresstype = '4' ] OPTIONAL ).
              IF ls_custaddress IS NOT INITIAL.
                DATA(lv_exist) = 'X'.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        IF lv_exist = ''.
          IF lines( lt_custaddress ) = 0.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'All Address needs to be provided'
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.
        ENDIF.

*--Payment Validation
        IF lines( lt_payment ) = 0.
          APPEND VALUE #(
          %tky                      = ls_head-%tky
          %state_area               = 'Validate_Head'
          %msg                      = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'No Payment Items found'
          )
          %element-dateofdischarge = if_abap_behv=>mk-on
          ) TO reported-head.

          APPEND VALUE #(
          %tky = ls_head-%tky
          ) TO failed-head.
        ENDIF.

        LOOP AT lt_payment INTO DATA(ls_payment).
          IF ls_payment-Paymentterms IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Provide Payment Terms in line -' && | | && Sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.

          IF ls_payment-Paymenttermsdesc IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Provide Payment Desc. in line -' && | | && Sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.

          IF ls_payment-Lutarnno IS INITIAL OR ls_payment-Lutarndate IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Provide LUT Details in line -' && | | && Sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.
        ENDLOOP.

*--Shipping Validation
        IF lines( lt_shipping ) = 0.
          APPEND VALUE #(
          %tky                      = ls_head-%tky
          %state_area               = 'Validate_Head'
          %msg                      = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'No Shipping Items found'
          )
          %element-dateofdischarge = if_abap_behv=>mk-on
          ) TO reported-head.

          APPEND VALUE #(
          %tky = ls_head-%tky
          ) TO failed-head.
        ENDIF.

        LOOP AT lt_shipping INTO DATA(ls_shipping).
          IF ls_shipping-Incoterms IS INITIAL OR ls_shipping-Incotermsl IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Provide Inco. and Inco. Loc. in line -' && | | && Sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.

          IF ls_shipping-Countrydestination IS INITIAL OR ls_shipping-Countryorigin IS INITIAL.
            APPEND VALUE #(
            %tky                      = ls_head-%tky
            %state_area               = 'Validate_Head'
            %msg                      = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Provide Dest./Origin Country -' && | | && Sy-tabix
            )
            %element-dateofdischarge = if_abap_behv=>mk-on
            ) TO reported-head.

            APPEND VALUE #(
            %tky = ls_head-%tky
            ) TO failed-head.
          ENDIF.
        ENDLOOP.

      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_add DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR add RESULT result.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR add~updateitem.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR add~validate.

ENDCLASS.

CLASS lhc_add IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY add
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_add)
        FAILED FINAL(lt_add_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_add IN lt_add
                        (

                        %tky               = ls_add-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).

    ENDIF.

  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_cnh DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR cnh RESULT result.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR cnh~updateitem.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR cnh~validate.

ENDCLASS.

CLASS lhc_cnh IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY cnh
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_cnh)
        FAILED FINAL(lt_cnh_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_cnh IN lt_cnh
                        (

                        %tky               = ls_cnh-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).

    ENDIF.

  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_cni DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR cni RESULT result.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR cni~updateitem.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR cni~validate.

ENDCLASS.

CLASS lhc_cni IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY cni
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_cni)
        FAILED FINAL(lt_cni_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_cni IN lt_cni
                        (

                        %tky               = ls_cni-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).
    ENDIF.

  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_cus DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR cus RESULT result.

    METHODS updateaddresstype FOR DETERMINE ON MODIFY
      IMPORTING keys FOR cus~updateaddresstype.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR cus~updateitem.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR cus~validate.

ENDCLASS.

CLASS lhc_cus IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY cus
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_cus)
        FAILED FINAL(lt_cus_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_cus IN lt_cus
                        (

                        %tky               = ls_cus-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).
    ENDIF.
  ENDMETHOD.

  METHOD updateaddresstype.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS WITH
     CORRESPONDING #( keys )
     RESULT FINAL(lt_head).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
     ENTITY cus
     ALL FIELDS WITH
     CORRESPONDING #( keys )
     RESULT FINAL(lt_cus).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head IS NOT INITIAL.

      SELECT *
        FROM ddcds_customer_domain_value_t( p_domain_name = 'ZDO_EXIMADDRTYPE' )
        INTO TABLE @DATA(lt_domain_value).

      LOOP AT lt_cus INTO DATA(ls_cus).
        DATA(ls_domain_value) = VALUE #( lt_domain_value[ value_low = ls_cus-Addresstype ] OPTIONAL ).
        IF ls_domain_value IS NOT INITIAL.
          ls_cus-Addresstypedesc = ls_domain_value-text.
        ENDIF.
        CLEAR: ls_domain_value.

        MODIFY ENTITIES OF zi_eximcommhdr IN LOCAL MODE
            ENTITY cus
            UPDATE
                FIELDS ( Addresstypedesc )
                WITH VALUE #(
                               ( %tky            = ls_cus-%tky
                                 Addresstypedesc = ls_cus-Addresstypedesc
                               ) ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR itm RESULT result.

    METHODS updateheaderfield FOR DETERMINE ON SAVE
      IMPORTING keys FOR itm~updateheaderfield.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR itm~updateitem.

    METHODS updateitemfield FOR DETERMINE ON SAVE
      IMPORTING keys FOR itm~updateitemfield.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR itm~validate.

ENDCLASS.

CLASS lhc_itm IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY itm
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_itm)
        FAILED FINAL(lt_itm_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_itm IN lt_itm
                        (

                        %tky               = ls_itm-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).
    ENDIF.
  ENDMETHOD.

  METHOD updateheaderfield.
  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD updateitemfield.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_pay DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR pay RESULT result.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR pay~updateitem.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR pay~validate.

ENDCLASS.

CLASS lhc_pay IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY pay
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_pay)
        FAILED FINAL(lt_pay_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_pay IN lt_pay
                        (

                        %tky               = ls_pay-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).
    ENDIF.
  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_shp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR shp RESULT result.

    METHODS updateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR shp~updateitem.

    METHODS validate FOR VALIDATE ON SAVE
      IMPORTING keys FOR shp~validate.

ENDCLASS.

CLASS lhc_shp IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_eximcommhdr IN LOCAL MODE
        ENTITY shp
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT FINAL(lt_shp)
        FAILED FINAL(lt_shp_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS NOT INITIAL.

      result = VALUE #( FOR ls_shp IN lt_shp
                        (

                        %tky               = ls_shp-%tky

                        %update            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                        %delete            = COND #( WHEN ls_header-released = '' AND ls_header-deleted = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled
                                                  )

                      )
                      ).
    ENDIF.
  ENDMETHOD.

  METHOD updateitem.
  ENDMETHOD.

  METHOD validate.
  ENDMETHOD.

ENDCLASS.
