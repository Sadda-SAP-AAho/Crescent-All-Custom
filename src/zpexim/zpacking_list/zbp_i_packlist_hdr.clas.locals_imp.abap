CLASS lhc_zi_packlist_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_packlist_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_packlist_hdr RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_packlist_hdr~cancel RESULT result.
*
*    METHODS prnt FOR MODIFY
*      IMPORTING keys FOR ACTION zi_packlist_hdr~prnt RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_packlist_hdr~print RESULT result.

    METHODS domdprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_packlist_hdr~domdprint RESULT result.

    METHODS determinepackinglist FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_packlist_hdr~determinepackinglist.

    METHODS deliverydetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_packlist_hdr~deliverydetails.

    METHODS checkdel FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_packlist_hdr~checkdel.
    METHODS domprinthsn FOR MODIFY
      IMPORTING keys FOR ACTION zi_packlist_hdr~domprinthsn RESULT result.

    METHODS xporprinthsn FOR MODIFY
      IMPORTING keys FOR ACTION zi_packlist_hdr~xporprinthsn RESULT result.

ENDCLASS.

CLASS lhc_zi_packlist_hdr IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    result = VALUE #(
        FOR gs_head IN header
        ( %tky                   = gs_head-%tky
          %action-cancel         = COND #( WHEN gs_head-canind  IS NOT INITIAL
                                             OR <head>-packinglist  IS INITIAL
                                           THEN if_abap_behv=>fc-o-disabled
                                           ELSE if_abap_behv=>fc-o-enabled )
          %action-edit           = COND #( WHEN gs_head-canind  IS NOT INITIAL
                                           THEN if_abap_behv=>fc-o-disabled
                                           ELSE if_abap_behv=>fc-o-enabled )
        ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print.
DATA: lt_items TYPE TABLE FOR READ RESULT zi_packlist_hdr\_Item.
data : lt_itm type table of zdt_packlist_itm.
data ls_itm type zdt_packlist_itm.
    DATA : lv_gross TYPE i_deliverydocument-headergrossweight.
    DATA : lv_d_gross1 TYPE i_deliverydocument-headergrossweight.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                 ENTITY zi_packlist_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    LOOP AT item INTO DATA(ls_item).
      lv_gross = lv_gross + ls_item-growt.
      CLEAR : ls_item.
    ENDLOOP..

    SELECT SINGLE a~grossweight FROM zdt_mpod_tmg AS a
    INNER JOIN zdt_deldash_hdr AS b ON b~pod = a~podcodename AND b~consizen = a~contsize AND b~shpprtycode = a~transitdays
    WHERE b~delivery = @gfs_header-delivery AND b~canind <> 'X'
    INTO @DATA(lv_d_gross).

    IF lv_d_gross IS INITIAL.
      SELECT SINGLE a~grossweight FROM zdt_mpod_tmg AS a
      INNER JOIN zdt_deldash_hdr AS b ON b~pod = a~podcodename AND b~consizen = a~contsize
      WHERE b~delivery = @gfs_header-delivery AND b~canind <> 'X'
      INTO @lv_d_gross.
    ENDIF.

    lv_d_gross1 = lv_d_gross.
    IF ( lv_gross GT lv_d_gross1 AND lv_d_gross IS NOT INITIAL ) OR lv_d_gross IS INITIAL .
      DATA(lv_msg1) = |Delivery Weight Exceeds POD Weight Limit|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_packlist_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_packlist_hdr.
else.

     READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT lt_items.

 loop at lt_items ASSIGNING FIELD-SYMBOL(<ls_item_name>).

       SELECT SINGLE matlngtxt
                  FROM zi_matfld
                  WHERE product = @<ls_item_name>-Matnr
                  INTO @<ls_item_name>-Maktx.

 ls_itm-id          = <ls_item_name>-id .
 ls_itm-item        = <ls_item_name>-item .
 ls_itm-packinglist = <ls_item_name>-packinglist.
 ls_itm-delivery    = <ls_item_name>-delivery.
 ls_itm-posnr       = <ls_item_name>-posnr.
 ls_itm-plant       = <ls_item_name>-plant.         .
 ls_itm-matnr       = <ls_item_name>-matnr.
 ls_itm-maktx       = <ls_item_name>-maktx.
 ls_itm-meins       = <ls_item_name>-meins.
 ls_itm-qty         = <ls_item_name>-qty.
 ls_itm-packqty     = <ls_item_name>-packqty.
 ls_itm-priority    = <ls_item_name>-priority.
 ls_itm-packmat     = <ls_item_name>-packmat.
 ls_itm-packmatnwt  = <ls_item_name>-packmatnwt.
 ls_itm-eachnetwt   = <ls_item_name>-eachnetwt.
 ls_itm-matnetwt    = <ls_item_name>-matnetwt.
 ls_itm-eachgrowt   = <ls_item_name>-eachgrowt.
 ls_itm-netwt       = <ls_item_name>-netwt.
 ls_itm-growt       = <ls_item_name>-growt .
 ls_itm-wtunit      = <ls_item_name>-wtunit .
 ls_itm-packmattyp  = <ls_item_name>-packmattyp.
 ls_itm-mateachpkg  = <ls_item_name>-mateachpkg .
 ls_itm-copy        = <ls_item_name>-copy.

append ls_itm to lt_itm.
 endloop.

  modify zdt_packlist_itm from TABLE @lt_itm.

      LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
        IF <fs_print> IS ASSIGNED.

          <fs_print>-dprint = 'X'.
          <fs_print>-zstatus = 'A'.

          MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                  ENTITY zi_packlist_hdr
                  UPDATE
                  FIELDS ( dprint zstatus )
                  WITH VALUE #( ( %tky          = <fs_print>-%tky
                                   dprint =  <fs_print>-dprint
                                   zstatus = <fs_print>-zstatus
                                    %control-dprint   = if_abap_behv=>mk-on
                                    %control-zstatus   = if_abap_behv=>mk-on
                                  ) ).

        ENDIF.
      ENDLOOP.
  ENDIF.



    " Fill the response table
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
         ENTITY  zi_packlist_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD domdprint.

    DATA : lv_gross TYPE i_deliverydocument-headergrossweight.
    DATA : lv_d_gross1 TYPE i_deliverydocument-headergrossweight.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                 ENTITY zi_packlist_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

*    LOOP AT item INTO DATA(ls_item).
*      lv_gross = lv_gross + ls_item-growt.
*      CLEAR : ls_item.
*    ENDLOOP..
*
*    SELECT SINGLE a~grossweight FROM zdt_mpod_tmg AS a
*    INNER JOIN zdt_deldash_hdr AS b ON b~pod = a~podcodename AND b~consizen = a~contsize AND b~shpprtycode = a~transitdays
*    WHERE b~delivery = @gfs_header-delivery AND b~canind <> 'X'
*    INTO @DATA(lv_d_gross).
*
*    IF lv_d_gross IS INITIAL.
*      SELECT SINGLE a~grossweight FROM zdt_mpod_tmg AS a
*      INNER JOIN zdt_deldash_hdr AS b ON b~pod = a~podcodename AND b~consizen = a~contsize
*      WHERE b~delivery = @gfs_header-delivery AND b~canind <> 'X'
*      INTO @lv_d_gross.
*    ENDIF.
*
*    lv_d_gross1 = lv_d_gross.
*    IF ( lv_gross GT lv_d_gross1 AND lv_d_gross IS NOT INITIAL ) OR lv_d_gross IS INITIAL.
*      DATA(lv_msg1) = |Delivery Weight Exceeds POD Weight Limit|.
*      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_packlist_hdr.
*
*      APPEND VALUE #( %tky        = gfs_header-%tky
*                      %state_area = 'Validate_Head'
*                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                           text     = lv_msg1 ) )
*      TO reported-zi_packlist_hdr.
*
*    ELSE.


      LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_domdprint>).
        IF <fs_domdprint> IS ASSIGNED.

          <fs_domdprint>-domprint = 'X'.
          <fs_domdprint>-zstatus = 'B'.

          MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                  ENTITY zi_packlist_hdr
                  UPDATE
                  FIELDS ( domprint zstatus )
                  WITH VALUE #( ( %tky          = <fs_domdprint>-%tky
                                   domprint =  <fs_domdprint>-domprint
                                   zstatus =  <fs_domdprint>-zstatus
                                    %control-domprint   = if_abap_behv=>mk-on
                                    %control-zstatus  = if_abap_behv=>mk-on
                                  ) ).

        ENDIF.
      ENDLOOP.
*    ENDIF.
    " Fill the response table
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
         ENTITY  zi_packlist_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD cancel.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-canind    = 'X'.
    gfs_header-cancelby  = sy-uname.
    gfs_header-status    = 'CLOSED'.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    gfs_header-cancelon = lv_date.

    MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
               ENTITY zi_packlist_hdr
               UPDATE FIELDS ( canind cancelby cancelon status )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               canind        = gfs_header-canind
                               cancelby      = gfs_header-cancelby
                               cancelon      = gfs_header-cancelon
                               status        = gfs_header-status
                           ) ).

    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

*  METHOD prnt.
*  ENDMETHOD.

  METHOD determinepackinglist.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA lv_packlist1(10) TYPE n.
    DATA : gs_item TYPE zdt_packlist_itm.

    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           FAILED FINAL(head_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-packinglist IS INITIAL.
      SELECT SINGLE MAX( revision ) FROM zdt_packlist_hdr
      WHERE delivery = @gfs_header-delivery INTO @DATA(lv_rev).

      gfs_header-packinglist = gfs_header-delivery."lv_packlist1.
      gfs_header-revision = lv_rev + 1.
      gfs_header-createdby   = sy-uname.
      gfs_header-changeddby  = sy-uname.
      CLEAR : lv_rev.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-createdon = lv_date.
      gfs_header-changedon = lv_date.
      gfs_header-createdat = lv_time.
      gfs_header-changedat = lv_time.
      gfs_header-status    = 'CREATED'.

      SELECT * FROM i_deliverydocumentitem WHERE deliverydocument = @gfs_header-delivery
      INTO TABLE @DATA(lt_docitm).


      LOOP AT lt_docitm INTO DATA(ls_docitm).
        gs_item-packinglist = gfs_header-packinglist.
        gs_item-delivery    = gfs_header-delivery.
        gs_item-plant       = gfs_header-plant.
        gs_item-posnr       = ls_docitm-deliverydocumentitem.
        gs_item-matnr       = ls_docitm-material.
        gs_item-qty         = ls_docitm-actualdeliveryquantity.

        SELECT SINGLE productdescription FROM i_productdescription
        WHERE product = @ls_docitm-product AND language = 'E'
        INTO @gs_item-maktx.

        gs_item-meins       = ls_docitm-baseunit.


        SELECT SINGLE netweight, weightunit FROM i_product WHERE product = @gs_item-matnr INTO @DATA(gs_mara).

        gs_item-matnetwt   = gs_mara-netweight.
        gs_item-wtunit     = gs_mara-weightunit.

        " gs_item-eachgrowt   = gs_item-eachnetwt + gs_item-packmatnwt.

        SELECT SINGLE b~billofmaterialcomponent
        FROM i_materialbomlink AS a
        INNER JOIN i_billofmaterialitembasic AS b ON b~billofmaterial = a~billofmaterial
        INNER JOIN i_product AS c ON c~product = b~billofmaterialcomponent
                                 AND c~productgroup IN ( 'Z041', 'Z042', 'Z010', 'Z011', 'Z012', 'Z013' )
        WHERE a~material = @ls_docitm-material
        INTO @gs_item-packmat.
        IF gs_item-packmat IS NOT INITIAL.
          SELECT SINGLE b~billofmaterialitemquantity
          FROM i_materialbomlink AS a
          INNER JOIN i_billofmaterialitembasic AS b ON b~billofmaterial = a~billofmaterial
          INNER JOIN i_product AS c ON c~product = b~billofmaterialcomponent
                                   AND c~productgroup IN ( 'Z041', 'Z042', 'Z010', 'Z011', 'Z012', 'Z013' )
          WHERE b~billofmaterialcomponent = @gs_item-packmat AND a~material = @ls_docitm-material
          INTO @gs_item-packqty.

          SELECT SINGLE netweight FROM i_product WHERE product = @gs_item-packmat INTO @gs_item-packmatnwt.
        ENDIF.
        gs_item-netwt     = gs_item-eachnetwt * gs_item-packqty.
        "gs_item-growt     = gs_item-netwt + gs_item-packmatnwt.

        MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
        ENTITY zi_packlist_hdr
        CREATE BY \_item
        FROM VALUE #( ( id      = gfs_header-id
                        %target = VALUE #( (     %cid                = gs_item-packinglist && gfs_header-revision && gs_item-posnr

                                                 packinglist         = gs_item-packinglist
                                                 delivery            = gs_item-delivery
                                                 posnr               = gs_item-posnr
                                                 plant               = gs_item-plant
                                                 matnr               = gs_item-matnr
                                                 maktx               = gs_item-maktx
                                                 meins               = gs_item-meins
                                                 qty                 = gs_item-qty
                                                 packmatnwt          = gs_item-packmatnwt
                                                 eachnetwt           = gs_item-eachnetwt
                                                 eachgrowt           = gs_item-eachgrowt
                                                 packmat             = gs_item-packmat
                                                 packqty             = gs_item-packqty
                                                 netwt               = gs_item-netwt
                                                 growt               = gs_item-growt
                                                 wtunit              = gs_item-wtunit
                                                 matnetwt            = gs_item-matnetwt

                                                 %control-packinglist  = if_abap_behv=>mk-on
                                                 %control-delivery     = if_abap_behv=>mk-on
                                                 %control-posnr        = if_abap_behv=>mk-on
                                                 %control-plant        = if_abap_behv=>mk-on
                                                 %control-matnr        = if_abap_behv=>mk-on
                                                 %control-maktx        = if_abap_behv=>mk-on
                                                 %control-meins        = if_abap_behv=>mk-on
                                                 %control-qty          = if_abap_behv=>mk-on
                                                 %control-packmatnwt   = if_abap_behv=>mk-on
                                                 %control-eachnetwt    = if_abap_behv=>mk-on
                                                 %control-eachgrowt    = if_abap_behv=>mk-on
                                                 %control-packmat      = if_abap_behv=>mk-on
                                                 %control-packqty      = if_abap_behv=>mk-on
                                                 %control-netwt        = if_abap_behv=>mk-on
                                                 %control-growt        = if_abap_behv=>mk-on
                                                 %control-wtunit       = if_abap_behv=>mk-on
                                                 %control-matnetwt       = if_abap_behv=>mk-on
                                          ) ) ) )
                        MAPPED FINAL(ls_mapped)
                        FAILED FINAL(ls_failed)
                        REPORTED FINAL(ls_reported).

      ENDLOOP.


      MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                ENTITY zi_packlist_hdr
                UPDATE FIELDS ( packinglist revision createdby createdon createdat changeddby changedon changedat status )
                WITH VALUE #( ( %tky          = gfs_header-%tky
                                packinglist   = gfs_header-packinglist
                                revision      = gfs_header-revision
                                createdby     = gfs_header-createdby
                                createdon     = gfs_header-createdon
                                createdat     = gfs_header-createdat
                                changeddby    = gfs_header-changeddby
                                changedon     = gfs_header-changedon
                                changedat     = gfs_header-createdat
                                status        = gfs_header-status
                            ) ).

    ENDIF.
  ENDMETHOD.

  METHOD deliverydetails.

    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE deliverydocument, salesorganization,soldtoparty
           FROM i_deliverydocument
           WHERE deliverydocument = @gfs_header-delivery INTO @DATA(ls_del).
    IF ls_del IS NOT INITIAL.

      gfs_header-salesorg = ls_del-salesorganization.
      SELECT SINGLE plant FROM i_deliverydocumentitem WHERE deliverydocument = @gfs_header-delivery INTO @gfs_header-plant.

      gfs_header-customercode = ls_del-soldtoparty.
      SELECT SINGLE * FROM i_customer WHERE customer = @ls_del-soldtoparty INTO @DATA(ls_customer).
      gfs_header-customername = ls_customer-customerfullname .

      MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                 ENTITY zi_packlist_hdr
                 UPDATE FIELDS ( salesorg plant customercode customername )
                 WITH VALUE #( ( %tky          = gfs_header-%tky
                                 salesorg      = gfs_header-salesorg
                                 plant         = gfs_header-plant
                                 customercode  = gfs_header-customercode
                                 customername  = gfs_header-customername
                             ) ).

    ENDIF.
  ENDMETHOD.

  METHOD checkdel.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE deliverydocument, salesorganization
          FROM i_deliverydocument
          WHERE deliverydocument = @gfs_header-delivery INTO @DATA(ls_del).
    IF ls_del IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_packlist_hdr WHERE delivery = @gfs_header-delivery AND canind <> 'X'
      INTO @DATA(ls_packlist_hdr).
      IF ls_packlist_hdr IS NOT INITIAL.
        DATA(lv_msg1) = |Packing List already created for this Delivery Number|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_packlist_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_packlist_hdr.
      ENDIF.

    ELSE.
      lv_msg1 = |Please provide valid Delivery Number|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_packlist_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_packlist_hdr.
    ENDIF.
  ENDMETHOD.
  METHOD Domprinthsn.
    DATA : lv_gross TYPE i_deliverydocument-headergrossweight.
    DATA : lv_d_gross1 TYPE i_deliverydocument-headergrossweight.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                 ENTITY zi_packlist_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).


      LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_domdprint>).
        IF <fs_domdprint> IS ASSIGNED.

          <fs_domdprint>-Domprinthsn = 'X'.
          <fs_domdprint>-zstatus = 'S'.

          MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                  ENTITY zi_packlist_hdr
                  UPDATE
                  FIELDS ( domprint zstatus )
                  WITH VALUE #( ( %tky          = <fs_domdprint>-%tky
                                   Domprinthsn =  <fs_domdprint>-domprint
                                   zstatus =  <fs_domdprint>-zstatus
                                    %control-Domprinthsn   = if_abap_behv=>mk-on
                                    %control-zstatus  = if_abap_behv=>mk-on
                                  ) ).

        ENDIF.
      ENDLOOP.
*    ENDIF.
    " Fill the response table
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
         ENTITY  zi_packlist_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).



  ENDMETHOD.

  METHOD Xporprinthsn.
  DATA: items TYPE TABLE FOR READ RESULT zi_packlist_hdr\_Item.
data : itm type table of zdt_packlist_itm.
data : itms type zdt_packlist_itm.
  DATA : lv_gross TYPE i_deliverydocument-headergrossweight.
    DATA : lv_d_gross1 TYPE i_deliverydocument-headergrossweight.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                 ENTITY zi_packlist_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT items.



 loop at items ASSIGNING FIELD-SYMBOL(<ls_item_name>).

       SELECT SINGLE matlngtxt
                  FROM zi_matfld
                  WHERE product = @<ls_item_name>-Matnr
                  INTO @<ls_item_name>-Maktx.

 itms-id          = <ls_item_name>-id .
 itms-item        = <ls_item_name>-item .
 itms-packinglist = <ls_item_name>-packinglist.
 itms-delivery    = <ls_item_name>-delivery.
 itms-posnr       = <ls_item_name>-posnr.
 itms-plant       = <ls_item_name>-plant.         .
 itms-matnr       = <ls_item_name>-matnr.
 itms-maktx       = <ls_item_name>-maktx.
 itms-meins       = <ls_item_name>-meins.
 itms-qty         = <ls_item_name>-qty.
 itms-packqty     = <ls_item_name>-packqty.
 itms-priority    = <ls_item_name>-priority.
 itms-packmat     = <ls_item_name>-packmat.
 itms-packmatnwt  = <ls_item_name>-packmatnwt.
 itms-eachnetwt   = <ls_item_name>-eachnetwt.
 itms-matnetwt    = <ls_item_name>-matnetwt.
 itms-eachgrowt   = <ls_item_name>-eachgrowt.
 itms-netwt       = <ls_item_name>-netwt.
 itms-growt       = <ls_item_name>-growt .
 itms-wtunit      = <ls_item_name>-wtunit .
 itms-packmattyp  = <ls_item_name>-packmattyp.
 itms-mateachpkg  = <ls_item_name>-mateachpkg .
 itms-copy        = <ls_item_name>-copy.

append itms to itm.
 endloop.

 sort itm by posnr.

  modify zdt_packlist_itm from TABLE @itm.

      LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_domdprint>).
        IF <fs_domdprint> IS ASSIGNED.

          <fs_domdprint>-Xportprinthsn = 'X'.
          <fs_domdprint>-zstatus = 'X'.

          MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
                  ENTITY zi_packlist_hdr
                  UPDATE
                  FIELDS ( Xportprinthsn zstatus )
                  WITH VALUE #( ( %tky          = <fs_domdprint>-%tky
                                   Xportprinthsn =  <fs_domdprint>-Xportprinthsn
                                   zstatus =  <fs_domdprint>-zstatus
                                    %control-Xportprinthsn   = if_abap_behv=>mk-on
                                    %control-zstatus  = if_abap_behv=>mk-on
                                  ) ).

        ENDIF.
      ENDLOOP.
*    ENDIF.
    " Fill the response table
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
         ENTITY  zi_packlist_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_packlist_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_packlist_itm RESULT result.

    METHODS updatedate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_packlist_itm~updatedate.

    "    METHODS calcqty FOR DETERMINE ON MODIFY
    "      IMPORTING keys FOR zi_packlist_itm~calcqty.

    METHODS updateval FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_packlist_itm~updateval.

    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION zi_packlist_itm~copy RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_packlist_itm RESULT result.

ENDCLASS.

CLASS lhc_zi_packlist_itm IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

    IF header IS INITIAL.
      RETURN.
    ENDIF.
    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).

    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_itm
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(item_failed).

    result = VALUE #(
          FOR gs_item IN item
          ( %tky                = gs_item-%tky

            %field-priority     = COND #( WHEN ls_head-canind <> 'X'
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-f-read_only )
            %field-qty          = COND #( WHEN ls_head-canind <> 'X'
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-f-read_only )
            %field-packqty      = COND #( WHEN ls_head-canind <> 'X'
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-f-read_only )
           %field-packmatnwt     = COND #( WHEN ls_head-canind <> 'X'
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-f-read_only )
           %action-copy         = COND #( WHEN ls_head-canind  IS NOT INITIAL
                                           THEN if_abap_behv=>fc-o-disabled
                                           ELSE if_abap_behv=>fc-o-enabled )

          ) ).
  ENDMETHOD.
  METHOD updatedate.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-changeddby  = sy-uname.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

    gfs_header-changedon = lv_date.
    gfs_header-createdat = lv_time.

    MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
              ENTITY zi_packlist_hdr
              UPDATE FIELDS ( changeddby changedon changedat )
              WITH VALUE #( ( %tky          = gfs_header-%tky
                              changeddby    = gfs_header-changeddby
                              changedon     = gfs_header-changedon
                              changedat     = gfs_header-createdat
                          ) ).
  ENDMETHOD.
*  METHOD calcqty.
*    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
*           ENTITY zi_packlist_hdr
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(header)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(header_failed).
*
*    IF header IS INITIAL.
*      RETURN.
*    ENDIF.
*    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).
*
*    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
*           ENTITY zi_packlist_itm
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(item)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(item_failed).
*
*    LOOP AT item INTO DATA(ls_item).
*
*      ls_item-netwt     = ls_item-eachnetwt * ls_item-packqty.
*      ls_item-growt     = ls_item-netwt + ls_item-Packmatnwt.
*
*      MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
*                ENTITY zi_packlist_itm
*                UPDATE FIELDS ( eachgrowt netwt growt )
*                WITH VALUE #( id = ls_item-id
*                              ( %tky          = ls_item-%tky
*                                eachgrowt     = ls_item-eachgrowt
*                                netwt         = ls_item-netwt
*                                growt         = ls_item-growt
*                            ) ).
*    ENDLOOP.
*  ENDMETHOD.
  METHOD copy.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

    gfs_header-changedon = lv_date.
    gfs_header-createdat = lv_time.

    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
           ENTITY zi_packlist_itm
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item).

    DATA : lv_item TYPE zi_packlist_itm-item.
    DATA: lv_p TYPE p.

    LOOP AT item INTO DATA(gs_item).
      lv_p += 1.

      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.
      lv_item = lv_p && lv_item.

      MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
      ENTITY zi_packlist_hdr
      CREATE BY \_item
      FROM VALUE #( ( id      = gfs_header-id
                     %target = VALUE #( (     %cid                = lv_date && lv_time && gs_item-packinglist && gfs_header-revision &&  gs_item-posnr
                                              item                = lv_item
                                              packinglist         = gs_item-packinglist
                                              delivery            = gs_item-delivery
                                              posnr               = gs_item-posnr
                                              plant               = gs_item-plant
                                              matnr               = gs_item-matnr
                                              maktx               = gs_item-maktx
                                              meins               = gs_item-meins
                                              qty                 = gs_item-qty
                                              packmatnwt          = gs_item-packmatnwt
                                              eachnetwt           = gs_item-eachnetwt
                                              eachgrowt           = gs_item-eachgrowt
                                              packmat             = gs_item-packmat
                                              packqty             = gs_item-packqty
                                              netwt               = gs_item-netwt
                                              growt               = gs_item-growt
                                              matnetwt            = gs_item-matnetwt
                                              wtunit              = gs_item-wtunit

                                              %control-item         = if_abap_behv=>mk-on
                                              %control-packinglist  = if_abap_behv=>mk-on
                                              %control-delivery     = if_abap_behv=>mk-on
                                              %control-posnr        = if_abap_behv=>mk-on
                                              %control-plant        = if_abap_behv=>mk-on
                                              %control-matnr        = if_abap_behv=>mk-on
                                              %control-maktx        = if_abap_behv=>mk-on
                                              %control-meins        = if_abap_behv=>mk-on
                                              %control-qty          = if_abap_behv=>mk-on
                                              %control-packmatnwt   = if_abap_behv=>mk-on
                                              %control-eachnetwt    = if_abap_behv=>mk-on
                                              %control-eachgrowt    = if_abap_behv=>mk-on
                                              %control-packmat      = if_abap_behv=>mk-on
                                              %control-packqty      = if_abap_behv=>mk-on
                                              %control-netwt        = if_abap_behv=>mk-on
                                              %control-growt        = if_abap_behv=>mk-on
                                              %control-matnetwt     = if_abap_behv=>mk-on
                                              %control-wtunit       = if_abap_behv=>mk-on
                                       ) ) ) )
                     MAPPED FINAL(ls_mapped)
                     FAILED FINAL(ls_failed)
                     REPORTED FINAL(ls_reported).

    ENDLOOP.

    READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item_upd).

    result = VALUE #( FOR ls_item1 IN item_upd
                          ( %tky   = ls_item1-%tky
                            %param = ls_item1 ) ).


  ENDMETHOD.

  METHOD updateval.
    READ ENTITIES OF zi_packlist_hdr IN LOCAL MODE
             ENTITY zi_packlist_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_packlist_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).


    SELECT a~priority, a~packqty FROM @item AS a
    WHERE a~priority IS NOT INITIAL AND a~packqty IS NOT INITIAL
    INTO TABLE @DATA(item_2).

    LOOP AT item INTO DATA(ls_item) WHERE priority IS NOT INITIAL.

      READ TABLE item_2 INTO DATA(ls_item_2) WITH KEY priority = ls_item-priority.
      IF  ls_item_2 IS NOT INITIAL.
        ls_item-mateachpkg = ( ls_item-qty / ls_item_2-packqty ).
        ls_item-eachnetwt = ( ls_item-qty / ls_item_2-packqty ) * ls_item-matnetwt.
        ls_item-netwt = ls_item-qty * ls_item-matnetwt.

        MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
        ENTITY zi_packlist_itm
        UPDATE FIELDS ( eachnetwt netwt mateachpkg )
        WITH VALUE #( id = ls_item-id
                      ( %tky          = ls_item-%tky
                        eachnetwt     = ls_item-eachnetwt
                        netwt         = ls_item-netwt
                        mateachpkg    = ls_item-mateachpkg
                      ) ).
      ENDIF.
      CLEAR : ls_item, ls_item_2.
    ENDLOOP.

    READ ENTITY zi_packlist_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item_upd).

    SELECT a~priority, SUM( a~eachnetwt ) AS eachnetwt, SUM( a~netwt ) AS netwt
    FROM @item_upd AS a
    WHERE a~priority IS NOT INITIAL
    GROUP BY a~priority
    INTO TABLE @DATA(item_upd2).

    LOOP AT item_upd INTO DATA(ls_item_upd)
    WHERE priority IS NOT INITIAL.
      READ TABLE item_upd2 INTO DATA(ls_item_upd2) WITH KEY priority = ls_item_upd-priority.
      IF ls_item_upd IS NOT INITIAL.
        IF ls_item_upd-packqty IS NOT INITIAL.
          ls_item_upd-eachgrowt = ls_item_upd2-eachnetwt + ls_item_upd-packmatnwt.
          ls_item_upd-growt = ls_item_upd2-netwt + ( ls_item_upd-packmatnwt * ls_item_upd-packqty ).
        ELSE.
          CLEAR : ls_item_upd-eachgrowt, ls_item_upd-growt.
        ENDIF.
        MODIFY ENTITIES OF zi_packlist_hdr IN LOCAL MODE
        ENTITY zi_packlist_itm
        UPDATE FIELDS ( eachgrowt growt )
        WITH VALUE #( id = ls_item_upd-id
                      ( %tky          = ls_item_upd-%tky
                        eachgrowt     = ls_item_upd-eachgrowt
                        growt         = ls_item_upd-growt
                      ) ).
      ENDIF.
      CLEAR : ls_item_upd, ls_item_upd2.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.


CLASS lsc_zi_packlist_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_packlist_hdr IMPLEMENTATION.

  METHOD save_modified.
    IF update-zi_packlist_hdr IS NOT INITIAL.

      DATA: lv_printq TYPE char32.

      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.

      DATA(lt_head) = update-zi_packlist_hdr.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).


      IF wa_head-zstatus = 'A'.


        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_D_DRAFTPL' ) .

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'DRAFTPACKINGLIST' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                  lo_store->set_schema(
*                    iv_form_name = 'DRAFTPACKINGLIST'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
            lt_keys[ name = 'DELIVERYDOCUMENT' ]-value = lt_head[ 1 ]-delivery.
            lt_keys[ name = 'REVISION' ]-value = lt_head[ 1 ]-revision.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY.
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'DRAFTPACKINGLIST'
              iv_template_name = 'DRAFTPACKINGLIST'
            ).
*            cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml
*                                                  iv_xdp_layout   = ls_template-xdp_template
*                                                  iv_locale       = 'en_US'
*                                                  is_options      = VALUE #(
*                                                              trace_level = 4 )
*                                        IMPORTING ev_pdf          = DATA(lv_pdf01)
*                                                  ev_trace_string = DATA(lv_trace01)
*                                                   ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'DRAFTPACK_LIST'
                iv_xml_data     = lv_xml
                iv_xdp_layout   = ls_template-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace)
                ev_pdl          = DATA(lv_pdf)
            ).

            DATA: lv_text TYPE char120.
            DATA: lv_drpl type char120.
            lv_drpl = lt_head[ 1 ]-delivery.

            Select * from I_BillingDocumentItem
             with privileged access
             where REFERENCESDDOCUMENT = @lv_drpl
             INTO table @DATA(LT_BILLINGDOC1).

      DATA: lv_custinv TYPE string.

      LOOP AT LT_BILLINGDOC1 INTO data(LS_BILLINGDOC1).

        Select single DocumentReferenceID from I_BillingDocument with privileged access
        where BillingDocument = @ls_billingdoc1-BillingDocument
          and AccountingTransferStatus <> 'E'
        into @data(lv_custinvs).

        lv_custinv = lv_custinvs.

      ENDLOOP.
            lv_text = |DRAFT PACKING LIST | && lv_drpl.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'DRAFTPACK_LIST'
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_text
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.


      ENDIF.
      IF wa_head-zstatus = 'B'.


        TRY.
            "Initialize Template Store Client
            DATA(lo_store1) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util1) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_D_DOMPL' ) .


            TRY.
                lo_store1->get_schema_by_name( iv_form_name = 'DOMDRAFTPL' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error1).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error1->mv_http_status_code = 404 OR lo_tmpl_error1->mv_http_status_code = 403 .
*                  lo_store1->set_schema(
*                    iv_form_name = 'DOMDRAFTPL'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util1->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys1)     = lo_fdp_util1->get_keys( ).
            lt_keys1[ name = 'DELIVERYDOCUMENT' ]-value = lt_head[ 1 ]-delivery.
            lt_keys1[ name = 'REVISION' ]-value = lt_head[ 1 ]-revision.
            TRY.
                DATA(lv_xml1) = lo_fdp_util1->read_to_xml( lt_keys1 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception1).
            ENDTRY.
            DATA(ls_template1) = lo_store1->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'DOMDRAFTPL'
              iv_template_name = 'DOMDRAFTPL'
            ).
*            cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml1
*                                                  iv_xdp_layout   = ls_template1-xdp_template
*                                                  iv_locale       = 'en_US'
*                                                  is_options      = VALUE #(
*                                                              trace_level = 4 )
*                                        IMPORTING ev_pdf          = DATA(lv_pdf02)
*                                                  ev_trace_string = DATA(lv_trace02)
*                                                   ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'DOMDRAFTPACK_LIST'
                iv_xml_data     = lv_xml1
                iv_xdp_layout   = ls_template1-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace1)
                ev_pdl          = DATA(lv_pdf1)
            ).

            DATA: lv_text1 TYPE char120.
            lv_text1 = |DOMESTIC DRAFT PACKING LIST | && lt_head[ 1 ]-delivery.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'DOMDRAFTPACK_LIST'
              iv_print_data       = lv_pdf1
              iv_name_of_main_doc = lv_text1
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.


      ENDIF.
       IF wa_head-zstatus = 'X'.


        TRY.

            lo_store = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            lo_fdp_util = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_D_DRAFTPL' ) .

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'DRAFTPACKINGLISTHSN' ).
              CATCH zcx_fp_tmpl_store_error1 INTO lo_tmpl_error.

            ENDTRY.

           lt_keys     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'DELIVERYDOCUMENT' ]-value = lt_head[ 1 ]-delivery.
            lt_keys[ name = 'REVISION' ]-value = lt_head[ 1 ]-revision.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
               lv_xml = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO lo_exception.
            ENDTRY.
          ls_template = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'DRAFTPACKINGLISTHSN'
              iv_template_name = 'DRAFTPACKINGLISTHSN'
            ).
*                                                   ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq
                iv_xml_data     = lv_xml
                iv_xdp_layout   = ls_template-xdp_template
                is_options      = VALUE #(
                  trace_level = 4
            )
              IMPORTING
                ev_trace_string = lv_trace
                ev_pdl          = lv_pdf
            ).

            lv_drpl = lt_head[ 1 ]-delivery.

            Select * from I_BillingDocumentItem
             with privileged access
             where REFERENCESDDOCUMENT = @lv_drpl
             INTO table @LT_BILLINGDOC1.

      LOOP AT LT_BILLINGDOC1 INTO LS_BILLINGDOC1.

        Select single DocumentReferenceID from I_BillingDocument with privileged access
        where BillingDocument = @ls_billingdoc1-BillingDocument
          and AccountingTransferStatus <> 'E'
        into @lv_custinvs.

        lv_custinv = lv_custinvs.

      ENDLOOP.
            lv_text = |DRAFT PACKING LIST-HSN | && lv_drpl.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_text
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.


      ENDIF.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
