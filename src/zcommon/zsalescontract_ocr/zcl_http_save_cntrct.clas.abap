class ZCL_HTTP_SAVE_CNTRCT definition
  public
  create public .

PUBLIC SECTION.



  INTERFACES if_http_service_extension .

  METHODS: handle_post
    IMPORTING
      request  TYPE REF TO if_web_http_request
      response TYPE REF TO if_web_http_response,
    handle_patch
    IMPORTING
      request  TYPE REF TO if_web_http_request
      response TYPE REF TO if_web_http_response,
    send_json
      IMPORTING
        response TYPE REF TO if_web_http_response
        code     TYPE i
        json     TYPE string,
    parse_date
      IMPORTING
        iv_str         TYPE string
      RETURNING
        VALUE(rv_date) TYPE d,
    flag
      IMPORTING
        iv_bool     TYPE abap_bool
      RETURNING
        VALUE(rv_x) TYPE abap_bool.
protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_SAVE_CNTRCT IMPLEMENTATION.


METHOD if_http_service_extension~handle_request.
    CASE request->get_method( ).
      WHEN 'POST'.   handle_post(   request = request response = response ).
      WHEN 'PATCH'.  handle_patch(   request = request response = response ).
      WHEN OTHERS.
        send_json( response = response code = 405
                   json = '{"isSuccess":false,"message":"Method Not Allowed"}' ).
    ENDCASE.
  ENDMETHOD.


  METHOD handle_post.
    DATA lv_body TYPE string.
    lv_body = request->get_text( ).

    IF lv_body IS INITIAL.
      send_json( response = response code = 400
                 json = '{"isSuccess":false,"message":"Empty body"}' ).
      RETURN.
    ENDIF.

    TRY.
        DATA ls_payload TYPE ty_payload.
        /ui2/cl_json=>deserialize(
          EXPORTING json        = lv_body
                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          CHANGING  data        = ls_payload ).
*        ls_payload-docid = cl_system_uuid=>create_uuid_c32_static( ).
        MODIFY ENTITIES OF zr_schdr
          ENTITY zrschdr
            CREATE FIELDS (
                docuuid
                ponumber          sonumber          airfaasorderid    accountreference
                orderdate         duedate           revisiondate      ischangeorder
                currency          customercode
                customername      customeraddrline1 customeraddrline2
                customercity      customerstate     customerpostal    customercountry
                customerphone     customerfax       customeremail
                customervatid     customereorino    customercompanyno
                vendorname        vendoraddrline1   vendoraddrline2
                vendorcity        vendorstate       vendorpostal      vendorcountry
                vendorphone       vendorfax         vendorvatid
                shiptoname        shiptoaddrline1   shiptoaddrline2
                shiptocity        shiptostate       shiptopostal      shiptocountry
                shipfromname      shipfromaddrline1 shipfromaddrline2
                shipfromcity      shipfrompostal    shipfromcountry
                shipvia           incoterms         incotermsyear     pol  pod
                prepaidfreight    paymentterms      deliveryterms
                buyername         buyerdepartment   buyeremail        invoiceemail
                linessubtotal     misccharge        taxsubtotal       total
                pocomment         socomment         notes
                authorizedby      termsurl          filename          provider
                salesorganization distributionchannel division
            )
            WITH VALUE #(
              (
                %cid              = |HDR_{ ls_payload-docid }|
                docuuid           = ls_payload-docid
                ponumber          = ls_payload-ponumber
                sonumber          = ls_payload-sonumber
                airfaasorderid    = ls_payload-airfaasorderid
                accountreference  = ls_payload-accountreference
                orderdate         = parse_date( ls_payload-orderdate )
                duedate           = parse_date( ls_payload-duedate )
                revisiondate      = parse_date( ls_payload-revisiondate )
                ischangeorder     = flag( ls_payload-ischangeorder )
                currency          = ls_payload-currency
                customercode      = ls_payload-customercode
                customername      = ls_payload-customername
                customeraddrline1 = ls_payload-customeraddrline1
                customeraddrline2 = ls_payload-customeraddrline2
                customercity      = ls_payload-customercity
                customerstate     = ls_payload-customerstate
                customerpostal    = ls_payload-customerpostal
                customercountry   = to_upper( ls_payload-customercountry )
                customerphone     = ls_payload-customerphone
                customerfax       = ls_payload-customerfax
                customeremail     = ls_payload-customeremail
                customervatid     = ls_payload-customervatid
                customereorino    = ls_payload-customereorino
                customercompanyno = ls_payload-customercompanyno
                salesorganization = ls_payload-salesorganization
                division          = ls_payload-division
                distributionchannel = ls_payload-distributionchannel
                vendorname        = ls_payload-vendorname
                vendoraddrline1   = ls_payload-vendoraddrline1
                vendoraddrline2   = ls_payload-vendoraddrline2
                vendorcity        = ls_payload-vendorcity
                vendorstate       = ls_payload-vendorstate
                vendorpostal      = ls_payload-vendorpostal
                vendorcountry     = ls_payload-vendorcountry
                vendorphone       = ls_payload-vendorphone
                vendorfax         = ls_payload-vendorfax
                vendorvatid       = ls_payload-vendorvatid
                shiptoname        = ls_payload-shiptoname
                shiptoaddrline1   = ls_payload-shiptoaddrline1
                shiptoaddrline2   = ls_payload-shiptoaddrline2
                shiptocity        = ls_payload-shiptocity
                shiptostate       = ls_payload-shiptostate
                shiptopostal      = ls_payload-shiptopostal
                shiptocountry     = ls_payload-shiptocountry
                shipfromname      = ls_payload-shipfromname
                shipfromaddrline1 = ls_payload-shipfromaddrline1
                shipfromaddrline2 = ls_payload-shipfromaddrline2
                shipfromcity      = ls_payload-shipfromcity
                shipfrompostal    = ls_payload-shipfrompostal
                shipfromcountry   = ls_payload-shipfromcountry
                shipvia           = ls_payload-shipvia
                incoterms         = ls_payload-incoterms
                incotermsyear     = ls_payload-incotermsyear
                pol               = ls_payload-pol
                pod               = ls_payload-pod
                prepaidfreight    = flag( ls_payload-prepaidfreight )
                paymentterms      = ls_payload-paymentterms
                deliveryterms     = ls_payload-deliveryterms
                buyername         = ls_payload-buyername
                buyerdepartment   = ls_payload-buyerdepartment
                buyeremail        = ls_payload-buyeremail
                invoiceemail      = ls_payload-invoiceemail
                linessubtotal     = ls_payload-linessubtotal
                misccharge        = ls_payload-misccharge
                taxsubtotal       = ls_payload-taxsubtotal
                total             = ls_payload-total
                pocomment         = ls_payload-pocomment
                socomment         = ls_payload-socomment
                notes             = ls_payload-notes
                authorizedby      = ls_payload-authorizedby
                termsurl          = ls_payload-termsurl
                filename          = ls_payload-filename
                provider          = ls_payload-provider
              )
            )
            ENTITY zrschdr
            CREATE BY \_items
            FIELDS ( docuuid linenumber partnumber revision description productcode plant
                     orderqty uom unitprice extprice conditiontype
                     duedate shipbydate taxapplicable currency )
            WITH VALUE #( (
                      %cid_ref   = |HDR_{ ls_payload-docid }|
                      %target = VALUE #( FOR ls_item IN ls_payload-items INDEX INTO i (
                              %cid       = |ITM_{ ls_payload-docid }_{ i }|
                              docuuid    = ls_payload-docid
                              linenumber = ls_item-linenumber
                              productcode = ls_item-productcode
                              plant      = ls_item-plant
                              partnumber = ls_item-partnumber
                              revision   = ls_item-revision
                              description = ls_item-description
                              orderqty   = ls_item-orderqty
                              uom        = ls_item-uom
                              unitprice  = ls_item-unitprice
                              extprice   = ls_item-extprice
                              conditiontype = ls_item-conditiontype
                              duedate    = parse_date( CONV string( ls_item-duedate ) )
                              shipbydate = parse_date( CONV string( ls_item-shipbydate ) )
                              taxapplicable = flag( ls_item-taxapplicable )
                              currency   = ls_payload-currency
                        ) )
                ) )
            ENTITY zrschdr
            CREATE BY \_taxes
            FIELDS ( docuuid taxseq taxid taxableamount taxpercent taxamount currency )
            WITH VALUE #( (
              %cid_ref   = |HDR_{ ls_payload-docid }|
                      %target = VALUE #( FOR ls_tax IN ls_payload-taxes INDEX INTO j (
                          %cid          = |TAX_{ ls_payload-docid }_{ j }|
                          docuuid    = ls_payload-docid
                          taxid         = ls_tax-taxid
                          taxableamount = ls_tax-taxableamount
                          taxpercent    = ls_tax-taxpercent
                          taxamount     = ls_tax-taxamount
                          currency      = ls_payload-currency
                    ) )
              )
            )

          REPORTED DATA(ls_reported)
          FAILED   DATA(ls_failed)
          MAPPED   DATA(ls_mapped).

        " ─── Check for EML errors ──────────────────────────────────────
        IF ls_failed-zrschdr IS NOT INITIAL.
          DATA lv_errtxt TYPE string.
          LOOP AT ls_reported-zrschdr INTO DATA(ls_fail_hdr).
            IF ls_fail_hdr-%msg IS BOUND.
              lv_errtxt = ls_fail_hdr-%msg->if_message~get_text( ).
            ENDIF.
          ENDLOOP.
          send_json( response = response code = 500
                     json = |\{"isSuccess":false,"message":"EML create failed: { lv_errtxt }"\}| ).
          RETURN.
        ENDIF.

        COMMIT ENTITIES BEGIN
          RESPONSE OF zr_schdr
          FAILED DATA(ls_commit_failed)
          REPORTED DATA(ls_commit_reported).

        COMMIT ENTITIES END.


        MODIFY ENTITIES OF zr_dms
             ENTITY zrdms
             CREATE FIELDS ( category description doclink docnumber doctype docsize title docversion mimetype owner refobjectkey refobjecttype )
             AUTO FILL CID
             WITH VALUE #( (
                              category    = 'CONT'
                              description = ls_payload-ponumber
                              doclink     = |{ ls_payload-document-filepath }{ ls_payload-document-filename }|
                              docnumber   = '10'
                              doctype     = COND #( WHEN ls_payload-document-mimetype EQ 'application/pdf' THEN 'PDF' ELSE '' )
                              docsize     = ls_payload-document-filesize
                              title       = ls_payload-document-filename
                              docversion   = '1.0'
                              mimetype    = ls_payload-document-mimetype
                              owner       = sy-uname
                              refobjectkey = ls_payload-docid
                              refobjecttype = 'SC-STG'
                           ) )
             FAILED DATA(lt_failed)
             REPORTED DATA(lt_reported).
        COMMIT ENTITIES BEGIN
           RESPONSE OF zr_dms
           FAILED DATA(ls_commit_failed1)
           REPORTED DATA(ls_commit_reported1).

        COMMIT ENTITIES END.

        IF ls_commit_failed1 IS NOT INITIAL OR lt_failed IS NOT INITIAL.

          LOOP AT lt_reported-zrdms ASSIGNING FIELD-SYMBOL(<fs_error2>).
            DATA(lv_error) =  | { <fs_error2>-%msg->if_message~get_text( ) } |.
          ENDLOOP.

          LOOP AT ls_commit_reported1-zrdms ASSIGNING FIELD-SYMBOL(<fs_error>).
            lv_error =  | { <fs_error>-%msg->if_message~get_text( ) } |.
          ENDLOOP.

          DATA(sync_log) = VALUE zsync_logs(
                                 errorlog = lv_error
                                 ref_object_key = ls_payload-docid
                                 ref_object_type =  'SC-STG'
                                 uuid = cl_system_uuid=>create_uuid_x16_static(  )
                             ).

          INSERT zsync_logs FROM @sync_log.
        ENDIF.

        IF ls_commit_failed IS NOT INITIAL.
          send_json( response = response code = 500
                     json = '{"isSuccess":false,"message":"Commit failed"}' ).
          RETURN.
        ENDIF.

        send_json(
          response = response
          code     = 200
          json     = |\{"isSuccess":true,"message":"Sales order saved","docId":"{ ls_payload-docid }","poNumber":"{ ls_payload-ponumber }"\}|
        ).

      CATCH cx_root INTO DATA(lx_root).
        send_json( response = response code = 500
                   json = |\{"isSuccess":false,"message":"{ lx_root->get_text( ) }"\}| ).
    ENDTRY.
  ENDMETHOD.


METHOD handle_patch.
  DATA lv_body TYPE string.
  lv_body = request->get_text( ).

  IF lv_body IS INITIAL.
    send_json( response = response code = 400
               json = '{"isSuccess":false,"message":"Empty body"}' ).
    RETURN.
  ENDIF.

  TRY.
      DATA ls_payload TYPE ty_payload.
      /ui2/cl_json=>deserialize(
        EXPORTING json        = lv_body
                  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
        CHANGING  data        = ls_payload ).
*        ls_payload-docid = cl_system_uuid=>create_uuid_c32_static( ).


      MODIFY ENTITIES OF zr_scitm_01
       ENTITY zrscitm
       CREATE FIELDS ( docuuid linenumber partnumber revision description productcode plant
                    orderqty uom unitprice extprice conditiontype
                    duedate shipbydate taxapplicable currency )
       AUTO FILL CID
       WITH  VALUE #( FOR ls_item IN ls_payload-items INDEX INTO i (
                             docuuid = ls_payload-docid
                             %cid       = |ITM_{ ls_payload-docid }_{ i }|
                             linenumber = ls_item-LineNumber
                             productcode = ls_item-productcode
                             plant      = ls_item-plant
                             partnumber = ls_item-partnumber
                             revision   = ls_item-revision
                             description = ls_item-description
                             orderqty   = ls_item-orderqty
                             uom        = ls_item-uom
                             unitprice  = ls_item-unitprice
                             extprice   = ls_item-extprice
                             conditiontype = ls_item-conditiontype
                             duedate    = parse_date( CONV string( ls_item-duedate ) )
                             shipbydate = parse_date( CONV string( ls_item-shipbydate ) )
                             taxapplicable = flag( ls_item-taxapplicable )
                             currency   = ls_payload-currency
                       ) )

         REPORTED DATA(ls_reported1)
         FAILED   DATA(ls_failed1)
         MAPPED   DATA(ls_mapped1).

      IF ls_failed1-zrscitm IS NOT INITIAL.

        DATA lv_errtxt TYPE string.
        LOOP AT ls_reported1-zrscitm INTO DATA(ls_fail_hdr1).
          IF ls_fail_hdr1-%msg IS BOUND.
            lv_errtxt = ls_fail_hdr1-%msg->if_message~get_text( ).
          ENDIF.
        ENDLOOP.
        send_json( response = response code = 500
                   json = |\{"isSuccess":false,"message":"EML create failed: { lv_errtxt }"\}| ).
        RETURN.
      ENDIF.

      COMMIT ENTITIES
      RESPONSE OF zr_scitm_01
      FAILED DATA(ls_commit_failed1)
      REPORTED DATA(ls_commit_reported1).

      IF ls_commit_failed1 IS NOT INITIAL.
        send_json( response = response code = 500
                   json = '{"isSuccess":false,"message":"Commit failed"}' ).
        RETURN.
      ENDIF.

      MODIFY ENTITIES OF zr_schdr
        ENTITY zrschdr
        UPDATE FIELDS ( ispostedsap )
        WITH VALUE #(
             (
               %tky-docuuid = ls_payload-docid
               ispostedsap = abap_false
             )
           )
        REPORTED DATA(ls_reported)
        FAILED   DATA(ls_failed)
        MAPPED   DATA(ls_mapped).

      " ─── Check for EML errors ──────────────────────────────────────
      IF ls_failed-zrscitm IS NOT INITIAL.
        LOOP AT ls_reported-zrscitm INTO DATA(ls_fail_hdr).
          IF ls_fail_hdr-%msg IS BOUND.
            lv_errtxt = ls_fail_hdr-%msg->if_message~get_text( ).
          ENDIF.
        ENDLOOP.
        send_json( response = response code = 500
                   json = |\{"isSuccess":false,"message":"EML create failed: { lv_errtxt }"\}| ).
        RETURN.
      ENDIF.


      COMMIT ENTITIES
        RESPONSE OF zr_schdr
        FAILED DATA(ls_commit_failed)
        REPORTED DATA(ls_commit_reported).

      IF ls_commit_failed IS NOT INITIAL.
        send_json( response = response code = 500
                   json = '{"isSuccess":false,"message":"Commit failed"}' ).
        RETURN.
      ENDIF.

      send_json(
        response = response
        code     = 200
        json     = |\{"isSuccess":true,"message":"Sales order saved","docId":"{ ls_payload-docid }","poNumber":"{ ls_payload-ponumber }"\}|
      ).

    CATCH cx_root INTO DATA(lx_root).
      send_json( response = response code = 500
                 json = |\{"isSuccess":false,"message":"{ lx_root->get_text( ) }"\}| ).
  ENDTRY.
ENDMETHOD.


  METHOD send_json.
    response->set_status( i_code = code i_reason = '' ).
    response->set_header_field( i_name = 'Content-Type'                i_value = 'application/json' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_text( json ).
  ENDMETHOD.


  METHOD parse_date.
    rv_date = '00000000'.
    IF iv_str IS INITIAL OR strlen( iv_str ) < 10. RETURN. ENDIF.
    rv_date(4) = iv_str(4).
    rv_date+4(2) = iv_str+5(2).
    rv_date+6(2) = iv_str+8(2).
  ENDMETHOD.


  METHOD flag.
    rv_x = iv_bool.
  ENDMETHOD.
ENDCLASS.
