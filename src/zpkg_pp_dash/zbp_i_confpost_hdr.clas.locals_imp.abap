CLASS lhc_zi_confpost_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_confpost_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_confpost_hdr RESULT result.

    METHODS getord FOR MODIFY
      IMPORTING keys FOR ACTION zi_confpost_hdr~getord RESULT result.

    METHODS post FOR MODIFY
      IMPORTING keys FOR ACTION zi_confpost_hdr~post RESULT result.

    METHODS gr FOR MODIFY
      IMPORTING keys FOR ACTION zi_confpost_hdr~gr RESULT result.

    METHODS gi FOR MODIFY
      IMPORTING keys FOR ACTION zi_confpost_hdr~gi RESULT result.

    METHODS scrap FOR MODIFY
      IMPORTING keys FOR ACTION zi_confpost_hdr~scrap RESULT result.

    METHODS getdet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_confpost_hdr~getdet.

    METHODS updata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_confpost_hdr~updata.

    METHODS checkdet FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_confpost_hdr~checkdet.

ENDCLASS.

CLASS lhc_zi_confpost_hdr IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zi_confpost_hdr WHERE shpflrno = @gfs_header-shpflrno INTO @DATA(ls_conf).
    SELECT SINGLE * FROM zdt_pp_delusr WHERE userid = @sy-uname INTO @DATA(ls_usr).

    result = VALUE #(
      FOR gs_header IN header
      ( %tky                            = gs_header-%tky
        %assoc-_ord                     = COND #( WHEN gfs_header-shpflrno IS INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-shpflrno IS NOT INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled )

       %assoc-_item                     = COND #( WHEN gfs_header-shpflrno IS INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-shpflrno IS NOT INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled )
*
       %action-edit                    = COND #( WHEN ls_conf IS INITIAL THEN
                                                       if_abap_behv=>fc-o-enabled
                                                 WHEN gs_header-status <> 'Completed' AND ( gfs_header-stat = 'P' OR gfs_header-stat IS INITIAL )
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 WHEN ls_conf IS NOT INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled )

*       %features-%action-Edit          = COND #( WHEN ls_conf IS INITIAL THEN
*                                                       if_abap_behv=>fc-o-enabled
*                                                  WHEN ls_conf IS NOT INITIAL THEN
*                                                       "if_abap_behv=>fc-o-disabled
*
*                                                       if_abap_behv=>fc-o-enabled )

       %delete                         = COND #( WHEN ls_usr IS NOT INITIAL THEN "ls_conf IS INITIAL THEN
                                                       if_abap_behv=>fc-o-enabled
                                                  WHEN ls_usr IS INITIAL THEN "ls_conf IS NOT INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled )

       %action-getord                   = COND #( WHEN ls_conf IS INITIAL
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-status = 'Completed'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN ( gfs_header-stat = 'R' OR gfs_header-stat = 'I' OR gfs_header-stat = 'S' )
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled  )

       %action-post                     = COND #( WHEN ls_conf IS INITIAL
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-stat <> 'R'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled  )

       %action-gr                       = COND #( WHEN ls_conf IS INITIAL
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-stat <> 'S'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled  )

       %action-gi                       = COND #( WHEN ls_conf IS INITIAL
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-status = 'Completed'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-stat = 'P' AND gfs_header-status <> 'Completed'
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  WHEN gfs_header-stat IS NOT INITIAL
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled  )

      %action-scrap                     = COND #( WHEN ls_conf IS INITIAL
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  WHEN gfs_header-stat <> 'I'
                                                  THEN if_abap_behv=>fc-o-disabled
                                                  ELSE if_abap_behv=>fc-o-enabled  )

      %field-docudt                     = COND #( WHEN ls_conf IS INITIAL
                                                  THEN if_abap_behv=>fc-f-read_only
                                                  WHEN gfs_header-status = 'Completed'
                                                  THEN if_abap_behv=>fc-f-read_only
                                                  WHEN gfs_header-stat = 'P' AND gfs_header-status <> 'Completed'
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  WHEN gfs_header-stat IS NOT INITIAL
                                                  THEN if_abap_behv=>fc-f-read_only
                                                  ELSE if_abap_behv=>fc-o-enabled  )
      ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getdet.
    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
              ENTITY zi_confpost_hdr
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    SELECT SINGLE * FROM zdt_conf_hdr WHERE shpflrno = @gfs_header-shpflrno
    INTO @DATA(ls_data).

    gfs_header-keyid      = ls_data-keyid.
    gfs_header-dept       = ls_data-dept.
    gfs_header-deptname   = ls_data-deptname.
    gfs_header-opr        = ls_data-opr.
    gfs_header-oprname    = ls_data-oprname.
    gfs_header-cont       = ls_data-cont.
    gfs_header-contname   = ls_data-contname.
    gfs_header-plant      = ls_data-plant.
    gfs_header-plantid    = ls_data-plantid.
    gfs_header-shpflrdt   = ls_data-shpflrdt.
    gfs_header-refid      = ls_data-id.
    gfs_header-skilab     = ls_data-skilab.
    gfs_header-sskilab    = ls_data-sskilab.
    gfs_header-uskilab    = ls_data-uskilab.


    MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
             ENTITY zi_confpost_hdr
             UPDATE FIELDS ( refid keyid dept deptname opr oprname cont contname plant plantid shpflrdt skilab sskilab uskilab )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             refid         = gfs_header-refid
                             keyid         = gfs_header-keyid
                             dept          = gfs_header-dept
                             deptname      = gfs_header-deptname
                             opr           = gfs_header-opr
                             oprname       = gfs_header-oprname
                             cont          = gfs_header-cont
                             contname      = gfs_header-contname
                             plant         = gfs_header-plant
                             plantid       = gfs_header-plantid
                             shpflrdt      = gfs_header-shpflrdt
                             skilab        = gfs_header-skilab
                             sskilab       = gfs_header-sskilab
                             uskilab       = gfs_header-uskilab
                         ) ).


  ENDMETHOD.

  METHOD updata.

    DATA : gs_item TYPE zdt_confpost_itm.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
             ENTITY zi_confpost_hdr
             UPDATE FIELDS ( status )
             WITH VALUE #( ( %tky          = gfs_header-%tky
                             status        = 'Created'
                         ) ).

    SELECT * FROM zdt_conf_itm WHERE shpflrno = @gfs_header-shpflrno AND ( status = 'C' OR status = 'P' )
    INTO TABLE @DATA(lt_tab).

    LOOP AT lt_tab INTO DATA(ls_tab).

      gs_item-shpflrno  = ls_tab-shpflrno.
      gs_item-matnr     = ls_tab-matnr.
      gs_item-maktx     = ls_tab-maktx.
      gs_item-totmou    = ls_tab-totmou.
      gs_item-totmouqty = ls_tab-totmouqty.
      gs_item-goodcast  = ls_tab-goodcast.
      gs_item-rejqty1   = ls_tab-rejqty1.
      gs_item-rejrea1   = ls_tab-rejrea1.
      gs_item-rejqty2   = ls_tab-rejqty2.
      gs_item-rejrea2   = ls_tab-rejrea2.
      gs_item-rejqty3   = ls_tab-rejqty3.
      gs_item-rejrea3   = ls_tab-rejrea3.
      gs_item-rejqty4   = ls_tab-rejqty4.
      gs_item-rejrea4   = ls_tab-rejrea4.
      gs_item-rejqty5   = ls_tab-rejqty5.
      gs_item-rejrea5   = ls_tab-rejrea5.
      gs_item-rejqty6   = ls_tab-rejqty6.
      gs_item-rejrea6   = ls_tab-rejrea6.
      gs_item-rejqty7   = ls_tab-rejqty7.
      gs_item-rejrea7   = ls_tab-rejrea7.
      gs_item-rejqty8   = ls_tab-rejqty8.
      gs_item-rejrea8   = ls_tab-rejrea8.
      gs_item-rejqty9   = ls_tab-rejqty9.
      gs_item-rejrea9   = ls_tab-rejrea9.
      gs_item-totcast   = ls_tab-totcast.
      gs_item-meins     = ls_tab-meins.
      gs_item-noofhead  = ls_tab-noofhead.
      gs_item-stdwt     = ls_tab-stdwt.
      gs_item-actwt     = ls_tab-actwt.
      gs_item-wtunit    = ls_tab-wtunit.
      gs_item-refid     = ls_tab-id.
      gs_item-refitem   = ls_tab-item.
      gs_item-totqty    = ls_tab-totqty.
      gs_item-allocqty  = ls_tab-allocqty.
      gs_item-balqty    = ls_tab-balqty.

      MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
       ENTITY zi_confpost_hdr
       CREATE BY \_item
       FROM VALUE #( ( id      = gfs_header-id
                       %target = VALUE #( (     %cid                = gs_item-shpflrno && gs_item-matnr

                                                shpflrno            = gs_item-shpflrno
                                                matnr               = gs_item-matnr
                                                maktx               = gs_item-maktx
                                                totmou              = gs_item-totmou
                                                totmouqty           = gs_item-totmouqty
                                                goodcast            = gs_item-goodcast
                                                rejqty1             = gs_item-rejqty1
                                                rejrea1             = gs_item-rejrea1
                                                rejqty2             = gs_item-rejqty2
                                                rejrea2             = gs_item-rejrea2
                                                rejqty3             = gs_item-rejqty3
                                                rejrea3             = gs_item-rejrea3
                                                rejqty4             = gs_item-rejqty4
                                                rejrea4             = gs_item-rejrea4
                                                rejqty5             = gs_item-rejqty5
                                                rejrea5             = gs_item-rejrea5
                                                rejqty6             = gs_item-rejqty6
                                                rejrea6             = gs_item-rejrea6
                                                rejqty7             = gs_item-rejqty7
                                                rejrea7             = gs_item-rejrea7
                                                rejqty8             = gs_item-rejqty8
                                                rejrea8             = gs_item-rejrea8
                                                rejqty9             = gs_item-rejqty9
                                                rejrea9             = gs_item-rejrea9
                                                totcast             = gs_item-totcast
                                                meins               = gs_item-meins
                                                noofhead            = gs_item-noofhead
                                                stdwt               = gs_item-stdwt
                                                actwt               = gs_item-actwt
                                                wtunit              = gs_item-wtunit
                                                refid               = gs_item-refid
                                                refitem             = gs_item-refitem
                                                totqty              = gs_item-totqty
                                                balqty              = gs_item-balqty
                                                allocqty            = gs_item-allocqty


                                                %control-shpflrno     = if_abap_behv=>mk-on
                                                %control-matnr        = if_abap_behv=>mk-on
                                                %control-maktx        = if_abap_behv=>mk-on
                                                %control-totmou       = if_abap_behv=>mk-on
                                                %control-totmouqty    = if_abap_behv=>mk-on
                                                %control-goodcast     = if_abap_behv=>mk-on
                                                %control-rejqty1      = if_abap_behv=>mk-on
                                                %control-rejrea1      = if_abap_behv=>mk-on
                                                %control-rejqty2      = if_abap_behv=>mk-on
                                                %control-rejrea2      = if_abap_behv=>mk-on
                                                %control-rejqty3      = if_abap_behv=>mk-on
                                                %control-rejrea3      = if_abap_behv=>mk-on
                                                %control-rejqty4      = if_abap_behv=>mk-on
                                                %control-rejrea4      = if_abap_behv=>mk-on
                                                %control-rejqty5      = if_abap_behv=>mk-on
                                                %control-rejrea5      = if_abap_behv=>mk-on
                                                %control-rejqty6      = if_abap_behv=>mk-on
                                                %control-rejrea6      = if_abap_behv=>mk-on
                                                %control-rejqty7      = if_abap_behv=>mk-on
                                                %control-rejrea7      = if_abap_behv=>mk-on
                                                %control-rejqty8      = if_abap_behv=>mk-on
                                                %control-rejrea8      = if_abap_behv=>mk-on
                                                %control-rejqty9      = if_abap_behv=>mk-on
                                                %control-rejrea9      = if_abap_behv=>mk-on
                                                %control-totcast      = if_abap_behv=>mk-on
                                                %control-meins        = if_abap_behv=>mk-on
                                                %control-noofhead     = if_abap_behv=>mk-on
                                                %control-stdwt        = if_abap_behv=>mk-on
                                                %control-actwt        = if_abap_behv=>mk-on
                                                %control-wtunit       = if_abap_behv=>mk-on
                                                %control-refid        = if_abap_behv=>mk-on
                                                %control-refitem      = if_abap_behv=>mk-on
                                                %control-totqty       = if_abap_behv=>mk-on
                                                %control-balqty       = if_abap_behv=>mk-on
                                                %control-allocqty     = if_abap_behv=>mk-on
                                         ) ) ) )
                       MAPPED FINAL(ls_mapped)
                       FAILED FINAL(ls_failed)
                       REPORTED FINAL(ls_reported).

      CLEAR : ls_tab.
    ENDLOOP.

  ENDMETHOD.

  METHOD getord.

    DATA : gs_ord TYPE zdt_confpost_ord.
    DATA : lv_item TYPE zi_confpost_itm-item.
    DATA : lv_p    TYPE p,
           lv_flag TYPE char1.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
             ENTITY zi_confpost_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_confpost_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    READ ENTITY zi_confpost_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord).


    SELECT SINGLE * FROM zdr_confpost_hdr WHERE id = @gfs_header-id AND shpflrno = @gfs_header-shpflrno INTO @DATA(ls_shp).

    IF ls_shp IS NOT INITIAL.

      DATA(lv_msg) = |Please save or discard then click on Get Order Button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_confpost_hdr.

    ELSE.

      SELECT * FROM zdt_cont_ord WHERE shpflrno = @gfs_header-shpflrno AND status = 'C'
      INTO TABLE @DATA(lt_ord).

      LOOP AT lt_ord INTO DATA(ls_ord).

        IF ( gfs_header-opr = '0050' OR gfs_header-opr = '0060' OR gfs_header-opr = '0080' OR gfs_header-opr = '0070'
             OR gfs_header-opr = '0040' ).
          SELECT SINGLE serialnumberprofile FROM i_productplantbasic
          WHERE product = @ls_ord-matnr AND plant = @ls_ord-plant
          INTO @DATA(lv_ser).
          IF lv_ser = 'Z001' AND ls_ord-serial IS INITIAL.
            DATA(lv_skip) = 'X'.
          ENDIF.
        ENDIF.
        IF lv_skip <> 'X'.
          READ TABLE ord INTO DATA(ls_order) WITH KEY refid = ls_ord-id refitem = ls_ord-item reford = ls_ord-ord.
          IF ls_order IS INITIAL.

            READ TABLE item INTO DATA(ls_item) WITH KEY refid = ls_ord-id refitem = ls_ord-item.
            IF ls_item IS NOT INITIAL.

              lv_p += 1.

              TRY.
                  lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                CATCH cx_uuid_error.
              ENDTRY.
              lv_item = lv_p && lv_item.
              lv_flag = 'X'.
              MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                    ENTITY zi_confpost_hdr
                    CREATE BY \_ord
                    FROM VALUE #( ( id      = gfs_header-id
                                   %target = VALUE #( (     %cid                = lv_item
                                                            item                = ls_item-item
                                                            ord                 = lv_item
                                                            shpflrno            = ls_ord-shpflrno
                                                            matnr               = ls_ord-matnr
                                                            meins               = ls_ord-meins
                                                            prodord             = ls_ord-prodord
                                                            pendprqty           = ls_ord-pendprqty
                                                            postqty             = ls_ord-pendprqty
                                                            balqty              = 0
                                                            rej                 = ls_ord-rej
                                                            heatno              = ls_ord-heatno
                                                            serial              = ls_ord-serial
                                                            plant               = ls_ord-plant
                                                            refid               = ls_ord-id
                                                            refitem             = ls_ord-item
                                                            reford              = ls_ord-ord

                                                            %control-item         = if_abap_behv=>mk-on
                                                            %control-ord          = if_abap_behv=>mk-on
                                                            %control-matnr        = if_abap_behv=>mk-on
                                                            %control-meins        = if_abap_behv=>mk-on
                                                            %control-shpflrno     = if_abap_behv=>mk-on
                                                            %control-prodord      = if_abap_behv=>mk-on
                                                            %control-pendprqty    = if_abap_behv=>mk-on
                                                            %control-balqty       = if_abap_behv=>mk-on
                                                            %control-postqty      = if_abap_behv=>mk-on
                                                            %control-rej          = if_abap_behv=>mk-on
                                                            %control-plant        = if_abap_behv=>mk-on
                                                            %control-refid        = if_abap_behv=>mk-on
                                                            %control-refitem      = if_abap_behv=>mk-on
                                                            %control-reford       = if_abap_behv=>mk-on
                                                            %control-serial       = if_abap_behv=>mk-on
                                                            %control-heatno       = if_abap_behv=>mk-on

                                                     ) ) ) )
                                   MAPPED FINAL(ls_mapped)
                                   FAILED FINAL(ls_failed)
                                   REPORTED FINAL(ls_reported).
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR : ls_ord, ls_order, ls_item, lv_ser, lv_skip.
      ENDLOOP.


      IF lv_flag = 'X'.
        SELECT * FROM zdt_conf_itm WHERE shpflrno = @gfs_header-shpflrno AND status = 'C'
        INTO TABLE @DATA(lt_item).

        LOOP AT item INTO DATA(ls_item_1).
          READ TABLE lt_item INTO DATA(ls_item_2) WITH KEY id = ls_item_1-refid item = ls_item_1-refid.
          IF ls_item_2 IS NOT INITIAL.

            ls_item_1-allocqty = ls_item_2-allocqty.
            ls_item_1-balqty   = ls_item_2-balqty.

            MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                    ENTITY zi_confpost_itm
                    UPDATE FIELDS ( allocqty balqty )
                    WITH VALUE #( id = gfs_header-id
                                  ( %tky         = ls_item_1-%tky
                                    allocqty     = ls_item_1-allocqty
                                    balqty       = ls_item_1-balqty
                                ) ).

          ENDIF.
          CLEAR : ls_item_1, ls_item_2.
        ENDLOOP.
      ENDIF.

    ENDIF.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

  METHOD post.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
               ENTITY zi_confpost_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_confpost_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord).

    SELECT a~prodord, a~meins, b~manufacturingorderoperation,
           SUM( a~postqty ) AS pendprqty, "SUM( a~pendprqty ) AS pendprqty,
           CAST( @space AS CHAR( 1 ) ) AS flag
        FROM @ord AS a
        INNER JOIN i_manufacturingorderoperation AS b ON b~manufacturingorder = a~prodord AND b~operationcontrolprofile = 'ZMC2'
        WHERE a~ordersta = 'R'
        GROUP BY a~prodord, a~meins, b~manufacturingorderoperation
        INTO TABLE @DATA(lt_ord).

    MODIFY ENTITIES OF i_productionordconfirmationtp
              ENTITY productionorderconfirmation
              CREATE FROM VALUE #( FOR ls_gr_1 IN lt_ord
                                   (
                                   %cid                        = ls_gr_1-prodord
                                   orderid                     = ls_gr_1-prodord
                                   orderoperation              = ls_gr_1-manufacturingorderoperation
                                   sequence                    = '000000'
                                   confirmationyieldquantity   = ls_gr_1-pendprqty
                                   confirmationunitsapcode     = ls_gr_1-meins
                                   "finalconfirmationtype       = '1'
                                   postingdate                 = gfs_header-docudt "shpflrdt
                                   confirmedexecutionstartdate = gfs_header-docudt "shpflrdt
                                   confirmedsetupenddate       = gfs_header-docudt "shpflrdt
    ) )
              MAPPED DATA(mapped_conf)
              FAILED DATA(failed_conf)
              REPORTED DATA(reported_conf).

    IF reported_conf-productionorderconfirmation IS NOT INITIAL.
      APPEND VALUE #(
      %tky                        = gfs_header-%tky
      %state_area                 = 'Validate_Head'
      %msg                        = new_message_with_text(
      severity = if_abap_behv_message=>severity-error
      text     = 'Error in Confirmation'
      )
      ) TO reported-zi_confpost_hdr.

      APPEND VALUE #(
       %tky = gfs_header-%tky
      ) TO failed-zi_confpost_hdr.

    ELSE.

      WAIT UP TO 3 SECONDS.

      APPEND VALUE #(
      %tky                        = gfs_header-%tky
      %state_area                 = 'Validate_Head'
      %msg                        = new_message_with_text(
      severity = if_abap_behv_message=>severity-success
      text     = 'Confirmation Successfull'
      )
      ) TO reported-zi_confpost_hdr.

      DATA : lv_log TYPE zi_confpost_log-log.
      DATA : lv_p    TYPE p.
      DATA lv_date TYPE datn.
      DATA lv_time TYPE timn.
      DATA : lv_postqty TYPE zdt_confpost_ord-postqty.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      LOOP AT ord INTO DATA(ls_ord) WHERE ordersta = 'R'.
        lv_postqty = ls_ord-postqty.
        ls_ord-alpostqty = ls_ord-alpostqty + ls_ord-postqty.
        ls_ord-postqty = ls_ord-balqty.
        MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                    ENTITY zi_confpost_ord
                    UPDATE FIELDS ( ordersta docsta status postqty alpostqty )
                    WITH VALUE #( id = gfs_header-id
                                  ( %tky         = ls_ord-%tky
                                    postqty      = ls_ord-postqty
                                    alpostqty    = ls_ord-alpostqty
                                    ordersta     = 'P'
                                    docsta       = 'P'
                                    status       = 'Confirmed'
                                ) ).

        lv_p += 1.

        TRY.
            lv_log = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
        ENDTRY.
        lv_log = lv_p && lv_log.
        MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
              ENTITY zi_confpost_hdr
              CREATE BY \_log
              FROM VALUE #( ( id      = gfs_header-id
                             %target = VALUE #( (     %cid                = lv_log
                                                      log                 = lv_log
                                                      refitem             = ls_ord-item
                                                      reford              = ls_ord-ord
                                                      shpflrno            = ls_ord-shpflrno
                                                      matnr               = ls_ord-matnr
                                                      meins               = ls_ord-meins
                                                      prodord             = ls_ord-prodord
                                                      qty                 = lv_postqty "ls_ord-postqty "pendprqty
                                                      postedby            = sy-uname
                                                      postedon            = lv_date
                                                      postedat            = lv_time
                                                      uniqueid            = gfs_header-uniqueid
                                                      movtype             = 'CON'

                                                      %control-log          = if_abap_behv=>mk-on
                                                      %control-refitem      = if_abap_behv=>mk-on
                                                      %control-reford       = if_abap_behv=>mk-on
                                                      %control-matnr        = if_abap_behv=>mk-on
                                                      %control-meins        = if_abap_behv=>mk-on
                                                      %control-shpflrno     = if_abap_behv=>mk-on
                                                      %control-prodord      = if_abap_behv=>mk-on
                                                      %control-qty          = if_abap_behv=>mk-on
                                                      %control-postedby     = if_abap_behv=>mk-on
                                                      %control-postedon     = if_abap_behv=>mk-on
                                                      %control-postedat     = if_abap_behv=>mk-on
                                                      %control-uniqueid     = if_abap_behv=>mk-on
                                                      %control-movtype     = if_abap_behv=>mk-on

                                               ) ) ) )
                             MAPPED FINAL(ls_mapped)
                             FAILED FINAL(ls_failed)
                             REPORTED FINAL(ls_reported).

        CLEAR : lv_log, lv_postqty.

      ENDLOOP.

      READ ENTITY zi_confpost_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord_2).

      LOOP AT ord_2 INTO DATA(ls_ord_u) WHERE balqty IS NOT INITIAL.
        ls_ord_u-postqty = ls_ord_u-balqty.
        MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                    ENTITY zi_confpost_ord
                    UPDATE FIELDS ( postqty )
                    WITH VALUE #( id = gfs_header-id
                                  ( %tky         = ls_ord_u-%tky
                                    postqty      = ls_ord_u-postqty
                                ) ).

      ENDLOOP.

      DATA : lv_quan1 TYPE menge_d,
             lv_quan2 TYPE menge_d.
      READ ENTITY zi_confpost_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord_1).

      LOOP AT ord_1 INTO DATA(ls_ord2). " WHERE ordersta <> 'P'.
        lv_quan1 = lv_quan1 + ls_ord-pendprqty.
        IF ls_ord2-ordersta <> 'P'.
          DATA(lv_flag) = 'X'.
          EXIT.
        ELSE.
          IF ls_ord2-postqty IS NOT INITIAL.
            lv_flag = 'X'.
            EXIT.
          ENDIF.
        ENDIF.
      ENDLOOP.

      READ ENTITY zi_confpost_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item_1).

      LOOP AT item_1 INTO DATA(ls_itm_1).
        lv_quan2 = lv_quan2 + ls_itm_1-totcast.
        IF ls_itm_1-balqty <> 0.
          lv_flag = 'X'.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_quan1 <> lv_quan2.
        lv_flag = 'X'.
      ENDIF.
      CLEAR : lv_quan1, lv_quan2.


      IF lv_flag = 'X'.
        gfs_header-status = 'Partially Completed'.
      ELSE.
        gfs_header-status = 'Completed'.
      ENDIF.

      gfs_header-stat = 'P'.
      CLEAR :gfs_header-docudt.
      MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
        ENTITY zi_confpost_hdr
        UPDATE FIELDS ( status stat docudt )
        WITH VALUE #( ( %tky   = gfs_header-%tky
                        status = gfs_header-status
                        docudt = gfs_header-docudt
                        stat   = gfs_header-stat ) ).
    ENDIF.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

  METHOD gr.

    TYPES : BEGIN OF ty_gr,
              matnr TYPE matnr,
              plant TYPE werks_d,
              lgort TYPE lgort_d,
              quant TYPE zdt_confpost_ord-pendprqty,
              meins TYPE meins,
              sdate TYPE zdt_confpost_hdr-shpflrdt,
              pord  TYPE zdt_confpost_ord-prodord,
              pitm  TYPE i_manufacturingorderitem-manufacturingorderitem,
            END OF ty_gr.

    TYPES : BEGIN OF ty_ser,
              matnr TYPE matnr,
              plant TYPE werks_d,
              lgort TYPE lgort_d,
              sernr TYPE i_equipmatlserialnumbertp-serialnumber,
              pord  TYPE zdt_confpost_ord-prodord,
            END OF ty_ser.

    DATA : lt_gr    TYPE STANDARD TABLE OF ty_gr,
           lt_gr_1  TYPE STANDARD TABLE OF ty_gr,
           ls_gr    TYPE ty_gr,
           lt_sernr TYPE STANDARD TABLE OF ty_ser,
           ls_sernr TYPE ty_ser.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                 ENTITY zi_confpost_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_confpost_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    READ ENTITY zi_confpost_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord).

  LOOP AT ORD INTO DATA(gs_ord) GROUP BY ( Item = gs_ord-Item ) into data(ls_sum_qty).

   DATA(lv_sum) = REDUCE i(
                   INIT x = 0
                   FOR ls_qty IN GROUP ls_sum_qty
                   NEXT x = x + ls_qty-Pendprqty ).

  ENDLOOP.



    LOOP AT ord INTO DATA(ls_ord) WHERE ordersta = 'S'.
      ls_gr-matnr = ls_ord-matnr.
      ls_gr-plant = ls_ord-plant.
      SELECT SINGLE * FROM i_product WHERE product = @ls_ord-matnr
          INTO @DATA(ls_mat).
      IF ls_ord-rej = 'X'.
        IF ls_ord-plant = '1100'.
          ls_gr-lgort = 'SARJ'.
        ELSEIF ls_ord-plant = '1200'.
          IF ls_mat-producttype = 'ZSFG'.
            ls_gr-lgort = 'KUSG'.
          ELSEIF ls_mat-producttype = 'ZFG'.
            ls_gr-lgort = 'KUFG'.
          ENDIF.
        ELSEIF ls_ord-plant = '1300'.
          IF ls_mat-producttype = 'ZSFG'.
            ls_gr-lgort = 'BGSG'.
          ELSEIF ls_mat-producttype = 'ZFG'.
            ls_gr-lgort = 'BGFG'.
          ENDIF.
        ELSEIF ls_ord-plant = '1400'.
          ls_gr-lgort = 'BARJ'.
        ENDIF.
      ELSE.
        IF ls_mat-producttype = 'ZSFG'.
          IF ls_ord-plant = '1100'.
            ls_gr-lgort = 'SASG'.
          ELSEIF ls_ord-plant = '1200'.
            ls_gr-lgort = 'KUSG'.
          ELSEIF ls_ord-plant = '1300'.
            ls_gr-lgort = 'BGSG'.
          ELSEIF ls_ord-plant = '1400'.
            ls_gr-lgort = 'BASG'.
          ENDIF.
        ELSEIF ls_mat-producttype = 'ZFG'.
          IF ls_ord-plant = '1100'.
            ls_gr-lgort = 'SAFG'.
          ELSEIF ls_ord-plant = '1200'.
            ls_gr-lgort = 'KUFG'.
          ELSEIF ls_ord-plant = '1300'.
            ls_gr-lgort = 'BGFG'.
          ELSEIF ls_ord-plant = '1400'.
            ls_gr-lgort = 'BAFG'.
          ENDIF.
        ENDIF.
      ENDIF.
      ls_gr-quant = ls_ord-postqty."pendprqty.
      ls_gr-meins = ls_ord-meins.
      ls_gr-sdate = gfs_header-shpflrno.
      ls_gr-pord  = ls_ord-prodord.
      SELECT SINGLE manufacturingorderitem FROM i_manufacturingorderitem
      WHERE manufacturingorder = @ls_gr-pord
      INTO @ls_gr-pitm.

      APPEND  ls_gr TO lt_gr_1.
      CLEAR :ls_gr.
    ENDLOOP.

    DATA(lv_cid) = 'CID_'.
    DATA(lv_cid_item) = 'CID_ITEM_'.
    DATA(lv_cid_ser) = 'CID_ITEM_SER_'.
    IF lt_gr_1[] IS NOT INITIAL.
      IF ( gfs_header-plant = '1200' OR gfs_header-plant = '1300' OR gfs_header-plant = '1100' ) "Changed by SP on 1.9.25
      AND ( gfs_header-opr = '0040' OR gfs_header-opr = '0050' OR gfs_header-opr = '0060' OR
            gfs_header-opr = '0070' OR gfs_header-opr = '0080' ).

        SELECT a~matnr, a~plant, a~lgort, SUM( a~quant ) AS quant, a~meins, a~sdate, a~pord, a~pitm
        FROM @lt_gr_1 AS a
        GROUP BY a~matnr, a~plant, a~lgort, a~meins, a~sdate, a~pord, a~pitm
        INTO TABLE @lt_gr.

        LOOP AT ord INTO ls_ord WHERE (  ordersta = 'S' AND serial IS NOT INITIAL ).
          SELECT SINGLE serialnumberprofile FROM i_productplantbasic
          WHERE product = @ls_ord-matnr AND plant = @ls_ord-plant
          INTO @DATA(lv_ser).
          IF lv_ser = 'Z001'.
            ls_sernr-matnr = ls_ord-matnr.
            ls_sernr-plant = ls_ord-plant.
            SELECT SINGLE * FROM i_product WHERE product = @ls_ord-matnr
            INTO @DATA(ls_mat_1).
            IF ls_ord-rej = 'X'.
              IF ls_ord-plant = '1100'.
                ls_sernr-lgort = 'SARJ'.
              ELSEIF ls_ord-plant = '1200'.
                IF ls_mat-producttype = 'ZSFG'.
                  ls_sernr-lgort = 'KUSG'.
                ELSEIF ls_mat-producttype = 'ZFG'.
                  ls_sernr-lgort = 'KUFG'.
                ENDIF.
              ELSEIF ls_ord-plant = '1300'.
                IF ls_mat-producttype = 'ZSFG'.
                  ls_sernr-lgort = 'BGSG'.
                ELSEIF ls_mat-producttype = 'ZFG'.
                  ls_sernr-lgort = 'BGFG'.
                ENDIF.
              ELSEIF ls_ord-plant = '1400'.
                ls_sernr-lgort = 'BARJ'.
              ENDIF.
            ELSE.
              IF ls_mat-producttype = 'ZSFG'.
                IF ls_ord-plant = '1100'.
                  ls_sernr-lgort = 'SASG'.
                ELSEIF ls_ord-plant = '1200'.
                  ls_sernr-lgort = 'KUSG'.
                ELSEIF ls_ord-plant = '1300'.
                  ls_sernr-lgort = 'BGSG'.
                ELSEIF ls_ord-plant = '1400'.
                  ls_sernr-lgort = 'BASG'.
                ENDIF.
              ELSEIF ls_mat-producttype = 'ZFG'.
                IF ls_ord-plant = '1100'.
                  ls_sernr-lgort = 'SAFG'.
                ELSEIF ls_ord-plant = '1200'.
                  ls_sernr-lgort = 'KUFG'.
                ELSEIF ls_ord-plant = '1300'.
                  ls_sernr-lgort = 'BGFG'.
                ELSEIF ls_ord-plant = '1400'.
                  ls_sernr-lgort = 'BAFG'.
                ENDIF.
              ENDIF.
            ENDIF.
            ls_sernr-sernr = ls_ord-serial.
            ls_sernr-pord = ls_ord-prodord.

            APPEND  ls_sernr TO lt_sernr.
          ENDIF.
          CLEAR :ls_sernr.
        ENDLOOP.

        MODIFY ENTITIES OF i_materialdocumenttp
        ENTITY materialdocument
        CREATE FROM VALUE #( ( %cid                                = lv_cid
                               goodsmovementcode                   = '02'
                               postingdate                         = gfs_header-docudt "shpflrdt
                               documentdate                        = cl_abap_context_info=>get_system_date( )
                               materialdocumentheadertext          = gfs_header-shpflrno
                               referencedocument                   = gfs_header-uniqueid
                               %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                               %control-postingdate                = cl_abap_behv=>flag_changed
                               %control-documentdate               = cl_abap_behv=>flag_changed
                               %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
                               %control-referencedocument          = cl_abap_behv=>flag_changed
                           ) )
        ENTITY materialdocument
        CREATE BY \_materialdocumentitem
        FROM VALUE #(
                             (
                               %cid_ref                            = lv_cid
                               %target                             = VALUE #( FOR ls_gr_2 IN lt_gr
                                                ( %cid                         = lv_cid_item && ls_gr_2-matnr && ls_gr_2-lgort && ls_gr_2-pord
                                                  plant                        = ls_gr_2-plant
                                                  material                     = ls_gr_2-matnr
                                                  goodsmovementtype            = '101'
                                                  storagelocation              = ls_gr_2-lgort
                                                  quantityinentryunit          = ls_gr_2-quant
                                                  entryunit                    = ls_gr_2-meins
                                                  manufacturedate              = ls_gr_2-sdate
                                                  manufacturingorder           = ls_gr_2-pord
                                                  manufacturingorderitem       = ls_gr_2-pitm
                                                  goodsmovementrefdoctype      = 'F'
                                                  "Batch                        = ls_gr_2-batch
                                                  "SalesOrder                   = ls_gr_2-vbeln
                                                  "SalesOrderItem               = ls_gr_2-posnr


                                                  %control-plant               = cl_abap_behv=>flag_changed
                                                  %control-material            = cl_abap_behv=>flag_changed
                                                  %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                  %control-storagelocation     = cl_abap_behv=>flag_changed
                                                  %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                  %control-entryunit           = cl_abap_behv=>flag_changed
                                                  %control-manufacturedate     = cl_abap_behv=>flag_changed
                                                  %control-manufacturingorder  = cl_abap_behv=>flag_changed
                                                  %control-manufacturingorderitem = cl_abap_behv=>flag_changed

                                                  "%control-Batch               = cl_abap_behv=>flag_changed
                                                  "%control-SalesOrder          = cl_abap_behv=>flag_changed
                                                  "%control-SalesOrderItem      = cl_abap_behv=>flag_changed

                                                )
                                                )
                             ) )
      ENTITY materialdocumentitem
            CREATE BY \_serialnumber
            FROM VALUE #( FOR ls_gr1 IN lt_gr
                          (
                               %cid_ref                       = lv_cid_item && ls_gr1-matnr && ls_gr1-lgort && ls_gr1-pord
                               %target                        = VALUE #( FOR ls_gr_3 IN lt_sernr WHERE ( matnr = ls_gr1-matnr AND lgort = ls_gr1-lgort AND pord = ls_gr1-pord )
                             ( %cid                           = lv_cid_item && ls_gr_3-matnr && ls_gr_3-sernr
                               serialnumber                   = ls_gr_3-sernr
                               %control-serialnumber          = cl_abap_behv=>flag_changed
                              ) )
             ) )

        MAPPED DATA(mapped_101)
        FAILED DATA(failed_101)
        REPORTED DATA(reported_101).

      ELSE.

        SELECT a~matnr, a~plant, a~lgort, SUM( a~quant ) AS quant, a~meins, a~sdate, a~pord, a~pitm
          FROM @lt_gr_1 AS a
          GROUP BY a~matnr, a~plant, a~lgort, a~meins, a~sdate, a~pord, a~pitm
          INTO TABLE @lt_gr.

        MODIFY ENTITIES OF i_materialdocumenttp
            ENTITY materialdocument
            CREATE FROM VALUE #( ( %cid                                = lv_cid
                                   goodsmovementcode                   = '02'
                                   postingdate                         = gfs_header-docudt "shpflrdt
                                   documentdate                        = cl_abap_context_info=>get_system_date( )
                                   materialdocumentheadertext          = gfs_header-shpflrno
                                   referencedocument                   = gfs_header-uniqueid
                                   %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                   %control-postingdate                = cl_abap_behv=>flag_changed
                                   %control-documentdate               = cl_abap_behv=>flag_changed
                                   %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
                               ) )
            ENTITY materialdocument
            CREATE BY \_materialdocumentitem
            FROM VALUE #(
                                 (
                                   %cid_ref                            = lv_cid
                                   %target                             = VALUE #( FOR ls_gr_2 IN lt_gr
                                                    ( %cid                         = lv_cid_item && ls_gr_2-matnr && ls_gr_2-lgort && ls_gr_2-pord
                                                      plant                        = ls_gr_2-plant
                                                      material                     = ls_gr_2-matnr
                                                      goodsmovementtype            = '101'
                                                      storagelocation              = ls_gr_2-lgort
                                                      quantityinentryunit          = ls_gr_2-quant
                                                      entryunit                    = ls_gr_2-meins
                                                      manufacturedate              = ls_gr_2-sdate
                                                      manufacturingorder           = ls_gr_2-pord
                                                      manufacturingorderitem       = ls_gr_2-pitm
                                                      goodsmovementrefdoctype      = 'F'
                                                      "Batch                        = ls_gr_2-batch
                                                      "SalesOrder                   = ls_gr_2-vbeln
                                                      "SalesOrderItem               = ls_gr_2-posnr


                                                      %control-plant               = cl_abap_behv=>flag_changed
                                                      %control-material            = cl_abap_behv=>flag_changed
                                                      %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                      %control-storagelocation     = cl_abap_behv=>flag_changed
                                                      %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                      %control-entryunit           = cl_abap_behv=>flag_changed
                                                      %control-manufacturedate     = cl_abap_behv=>flag_changed
                                                      %control-manufacturingorder  = cl_abap_behv=>flag_changed
                                                      %control-manufacturingorderitem = cl_abap_behv=>flag_changed

                                                      "%control-Batch               = cl_abap_behv=>flag_changed
                                                      "%control-SalesOrder          = cl_abap_behv=>flag_changed
                                                      "%control-SalesOrderItem      = cl_abap_behv=>flag_changed


                                                    )  )
            ) )


            MAPPED mapped_101
            FAILED failed_101
            REPORTED reported_101.

      ENDIF.

      IF reported_101-materialdocument IS NOT INITIAL.
        APPEND VALUE #(
        %tky                        = gfs_header-%tky
        %state_area                 = 'Validate_Head'
        %msg                        = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Error in Goods Mvt 101'
        ) ) TO reported-zi_confpost_hdr.

        APPEND VALUE #(
        %tky = gfs_header-%tky
        ) TO failed-zi_confpost_hdr.

      ELSE.

        DATA : lv_log TYPE zi_confpost_log-log.
        DATA : lv_p    TYPE p.
        DATA lv_date TYPE datn.
        DATA lv_time TYPE timn.

        TRY.
            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

        LOOP AT ord INTO DATA(ls_ord1) WHERE ordersta = 'S'.
          MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                      ENTITY zi_confpost_ord
                      UPDATE FIELDS ( ordersta docsta status )
                      WITH VALUE #( id = gfs_header-id
                                    ( %tky         = ls_ord1-%tky
                                      ordersta     = 'R'
                                      docsta       = 'R'
                                      status       = 'GR'
                                  ) ).

          lv_p += 1.

          TRY.
              lv_log = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.
          lv_log = lv_p && lv_log.
          MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                ENTITY zi_confpost_hdr
                CREATE BY \_log
                FROM VALUE #( ( id      = gfs_header-id
                               %target = VALUE #( (     %cid                = lv_log
                                                        log                 = lv_log
                                                        refitem             = ls_ord-item
                                                        reford              = ls_ord-ord
                                                        shpflrno            = ls_ord-shpflrno
                                                        matnr               = ls_ord-matnr
                                                        meins               = ls_ord-meins
                                                        prodord             = ls_ord-prodord
                                                        qty                 = ls_ord-postqty "ls_ord-pendprqty
                                                        postedby            = sy-uname
                                                        postedon            = lv_date
                                                        postedat            = lv_time
                                                        uniqueid            = gfs_header-uniqueid
                                                        movtype             = '101'

                                                        %control-log          = if_abap_behv=>mk-on
                                                        %control-refitem      = if_abap_behv=>mk-on
                                                        %control-reford       = if_abap_behv=>mk-on
                                                        %control-matnr        = if_abap_behv=>mk-on
                                                        %control-meins        = if_abap_behv=>mk-on
                                                        %control-shpflrno     = if_abap_behv=>mk-on
                                                        %control-prodord      = if_abap_behv=>mk-on
                                                        %control-qty          = if_abap_behv=>mk-on
                                                        %control-postedby     = if_abap_behv=>mk-on
                                                        %control-postedon     = if_abap_behv=>mk-on
                                                        %control-postedat     = if_abap_behv=>mk-on
                                                        %control-uniqueid     = if_abap_behv=>mk-on
                                                        %control-movtype     = if_abap_behv=>mk-on

                                                 ) ) ) )
                               MAPPED FINAL(ls_mapped)
                               FAILED FINAL(ls_failed)
                               REPORTED FINAL(ls_reported).

          CLEAR : lv_log.

        ENDLOOP.



        gfs_header-status = 'Partially Completed'.

        MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
          ENTITY zi_confpost_hdr
          UPDATE FIELDS ( status stat )
          WITH VALUE #( ( %tky   = gfs_header-%tky
                          status = gfs_header-status
                          stat   = 'R' ) ).

      ENDIF.
    ENDIF.

    WAIT UP TO 3 SECONDS.


    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

  METHOD gi.
    TYPES : BEGIN OF ty_gr,
              matnr_1 TYPE matnr,
              matnr   TYPE matnr,
              plant   TYPE werks_d,
              lgort   TYPE lgort_d,
              quant   TYPE zdt_confpost_ord-pendprqty,
              meins   TYPE meins,
              sdate   TYPE zdt_confpost_hdr-shpflrdt,
              pord    TYPE zdt_confpost_ord-prodord,
              res     TYPE i_reservationdocumentheader-reservation,
              resitm  TYPE i_materialdocumentitemtp-reservationitem,
              pitm    TYPE i_manufacturingorderitem-manufacturingorderitem,
              docitm  TYPE i_materialdocumentitemtp-materialdocumentitem,
            END OF ty_gr.

    TYPES : BEGIN OF ty_ser,
              matnr  TYPE matnr,
              plant  TYPE werks_d,
              lgort  TYPE lgort_d,
              sernr  TYPE i_equipmatlserialnumbertp-serialnumber,
              pord   TYPE zdt_confpost_ord-prodord,
              docitm TYPE i_materialdocumentitemtp-materialdocumentitem,
            END OF ty_ser.

    DATA : lt_gr    TYPE STANDARD TABLE OF ty_gr,
           lt_gr_1  TYPE STANDARD TABLE OF ty_gr,
           ls_gr    TYPE ty_gr,
           lt_sernr TYPE STANDARD TABLE OF ty_ser,
           ls_sernr TYPE ty_ser.

    DATA lv_date1 TYPE datn.
    DATA lv_time1 TYPE timn.
    data lv_ord   type aufnr.

    DATA : lv_uniqueid TYPE char15,
           lv_date_e   TYPE sydate.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                 ENTITY zi_confpost_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zdr_confpost_hdr WHERE id = @gfs_header-id AND shpflrno = @gfs_header-shpflrno INTO @DATA(ls_shp).

    IF ls_shp IS NOT INITIAL.

      DATA(lv_msg) = |Please save or discard then click on GI Button|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_confpost_hdr.

    ELSE.

      IF gfs_header-docudt IS NOT INITIAL.

        TRY.
            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date1 TIME lv_time1.

        lv_date_e = lv_date1 - 4.
        IF gfs_header-docudt BETWEEN lv_date_e AND lv_date1.

          READ ENTITY zi_confpost_hdr
                BY \_item
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(item).

          READ ENTITY zi_confpost_hdr
                BY \_ord
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(ord).

          LOOP AT ord INTO DATA(ls_ord1_1) WHERE ( ordersta IS INITIAL OR ordersta = 'P' ) AND postqty IS NOT INITIAL.
            SELECT a~* FROM i_manufacturingorderitem AS a
            INNER JOIN i_mfgorderwithstatus AS b ON b~manufacturingorder = a~manufacturingorder
                                           AND b~orderistechnicallycompleted <> 'X'
                                           AND b~orderisdeleted <> 'X'
                                           AND b~orderisclosed <> 'X'
                                           AND b~orderismarkedfordeletion <> 'X'
            WHERE a~manufacturingorder = @ls_ord1_1-prodord
              AND a~manufacturingordercategory = '10' AND a~orderisreleased = 'X'
              AND a~product = @ls_ord1_1-matnr
            INTO TABLE @DATA(lt_ord1_1).
            IF lt_ord1_1 IS INITIAL.
              lv_ord = ls_ord1_1-prodord.
              DATA(lv_flag_1) = 'X'.
              EXIT.
            ENDIF.
            CLEAR : ls_ord1_1, lt_ord1_1[].
          ENDLOOP.

          IF lv_flag_1 <> 'X'.
            SELECT b~matnr AS matnr_1, c~product AS matnr, b~plant, c~storagelocation AS lgort,
                   ( division( ( b~postqty * e~requiredquantity ), f~mfgorderplannedtotalqty, 3 ) ) AS quant, "billofmaterialitemquantity / v
                   c~entryunit AS meins, @gfs_header-shpflrdt AS sdate, b~prodord AS pord, a~reservation AS res,
                   c~reservationitem AS resitm
            FROM @ord AS b
            INNER JOIN i_reservationdocumentheader AS a ON a~orderid = b~prodord
            INNER JOIN i_reservationdocumentitem AS c ON c~reservation = a~reservation AND c~goodsmovementtype = '261'
            INNER JOIN i_billofmaterialtp_2 AS d ON d~material = b~matnr AND d~plant = b~plant
        "    INNER JOIN i_billofmaterialitemtp_2 AS e ON e~material = b~matnr AND e~plant = b~plant
        "                                            AND e~billofmaterialcomponent = c~product
            INNER JOIN i_mfgorderoperationcomponent AS e ON e~assembly = b~matnr AND e~plant = b~plant
                                                        AND e~manufacturingorder = b~prodord AND e~material = c~product
            INNER JOIN i_manufacturingorder AS f ON f~manufacturingorder = b~prodord
            WHERE ( ( b~ordersta IS INITIAL AND b~postqty IS NOT INITIAL ) OR ( b~ordersta = 'P' AND b~postqty IS NOT INITIAL ) ) AND c~reservationitmismarkedfordeltn <> 'X'
            INTO TABLE @lt_gr_1.

            SELECT a~matnr_1, a~matnr, a~plant, a~lgort, SUM( a~quant ) AS quant, a~meins, a~sdate, a~pord, a~res, a~resitm
            FROM @lt_gr_1 AS a
            GROUP BY matnr_1, matnr, plant, lgort, meins, sdate, pord, res, resitm
            INTO TABLE @lt_gr.


            SELECT SINGLE MAX( uniqueid ) FROM zdt_confpost_log INTO @lv_uniqueid.
            IF lv_uniqueid IS INITIAL.
              lv_uniqueid = 1.
            ELSE.
              lv_uniqueid = lv_uniqueid + 1.
            ENDIF.
            gfs_header-uniqueid = lv_uniqueid.
            CONDENSE gfs_header-uniqueid.


*    LOOP AT lt_gr ASSIGNING FIELD-SYMBOL(<fs_gr>).
*      SELECT SINGLE manufacturingorderitem FROM i_manufacturingorderitem
*      WHERE manufacturingorder = @<fs_gr>-pord
*      INTO @<fs_gr>-pitm.
*    ENDLOOP.

            DATA(lv_cid) = 'CID_'.
            DATA(lv_cid_item) = 'CID_ITEM_'.

            IF lt_gr IS NOT INITIAL.

*            SELECT a~matnr, a~pord FROM @lt_gr AS a GROUP BY a~matnr, a~pord
*            INTO TABLE @DATA(lt_gr_2).
*
*            LOOP AT lt_gr_2 INTO DATA(ls_gr_2).
*              SELECT SINGLE * FROM zdt_confpost_log
*              WHERE shpflrno = @gfs_header-shpflrno AND matnr = @ls_gr_2-matnr AND prodord = @ls_gr_2-pord
*                AND uniqueid = @gfs_header-uniqueid AND movtype = '261' INTO @DATA(ls_log).
*              IF ls_log IS INITIAL.
*              ELSE.
*                SELECT SINGLE a~materialdocument
*                FROM i_materialdocumentheader_2 AS a
*                INNER JOIN i_materialdocumentitem_2 AS b ON b~materialdocument = a~materialdocument
*                                                        AND b~materialdocumentyear = a~materialdocumentyear
*                WHERE a~materialdocumentheadertext = @gfs_header-shpflrno AND a~referencedocument = @gfs_header-uniqueid
*                  AND b~material = @ls_gr_2-matnr AND b~orderid = @ls_gr_2-pord and b~GoodsMovementType = '261'
*                INTO @DATA(ls_data).
*                IF ls_data IS INITIAL.
*                  DATA(lv_flag) = 'X'.
*                  EXIT.
*                ENDIF.
*              ENDIF.
*              CLEAR : ls_gr_2, ls_data, ls_log.
*            ENDLOOP.
*
*            IF lv_flag <> 'X'.
              IF ( gfs_header-plant = '1200' OR gfs_header-plant = '1300' OR gfs_header-plant = '1100' ) "Changed by SP on 1.9.25
              AND ( gfs_header-opr = '0050' OR gfs_header-opr = '0060' OR
                    gfs_header-opr = '0070' OR gfs_header-opr = '0080' ).

                LOOP AT lt_gr INTO DATA(ls_gr_1).
                  SELECT SINGLE serialnumberprofile FROM i_productplantbasic
                  WHERE product = @ls_gr_1-matnr AND plant = @ls_gr_1-plant
                  INTO @DATA(lv_ser).
                  IF lv_ser = 'Z001'.
                    LOOP AT ord INTO DATA(ls_ord) WHERE matnr = ls_gr_1-matnr_1 AND plant = ls_gr_1-plant AND prodord = ls_gr_1-pord AND postqty IS NOT INITIAL.
                      ls_sernr-matnr = ls_gr_1-matnr.
                      ls_sernr-plant = ls_gr_1-plant.
                      ls_sernr-lgort = ls_gr_1-lgort.
                      ls_sernr-sernr = ls_ord-serial.
                      ls_sernr-pord  = ls_gr_1-pord.
                      APPEND  ls_sernr TO lt_sernr.
                      CLEAR : ls_sernr.
                    ENDLOOP.
                  ENDIF.
                  CLEAR :ls_sernr.
                ENDLOOP.

                MODIFY ENTITIES OF i_materialdocumenttp
                   ENTITY materialdocument
                   CREATE FROM VALUE #( ( %cid                                = lv_cid
                                          goodsmovementcode                   = '03'
                                          postingdate                         = gfs_header-docudt "shpflrdt
                                          documentdate                        = cl_abap_context_info=>get_system_date( )
                                          materialdocumentheadertext          = gfs_header-shpflrno
                                          referencedocument                   = gfs_header-uniqueid
                                          %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                          %control-postingdate                = cl_abap_behv=>flag_changed
                                          %control-documentdate               = cl_abap_behv=>flag_changed
                                          %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
                                          %control-referencedocument          = cl_abap_behv=>flag_changed
                                      ) )
                   ENTITY materialdocument
                   CREATE BY \_materialdocumentitem
                   FROM VALUE #(
                                        (
                                          %cid_ref                            = lv_cid
                                          %target                             = VALUE #( FOR ls_gr1 IN lt_gr
                                                           ( %cid                         = lv_cid_item && ls_gr1-matnr && ls_gr1-lgort && ls_gr1-pord

                                                             plant                        = ls_gr1-plant
                                                             material                     = ls_gr1-matnr
                                                             goodsmovementtype            = '261'
                                                             storagelocation              = ls_gr1-lgort
                                                             quantityinentryunit          = ls_gr1-quant
                                                             entryunit                    = ls_gr1-meins
                                                             manufacturingorder           = ls_gr1-pord
                                                             manufacturingorderitem       = ls_gr1-pitm
                                                             manufacturedate              = ls_gr1-sdate
                                                             reservation                  = ls_gr1-res
                                                             reservationitem              = ls_gr1-resitm

                                                             %control-plant               = cl_abap_behv=>flag_changed
                                                             %control-material            = cl_abap_behv=>flag_changed
                                                             %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                             %control-storagelocation     = cl_abap_behv=>flag_changed
                                                             %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                             %control-entryunit           = cl_abap_behv=>flag_changed
                                                             %control-manufacturingorder  = cl_abap_behv=>flag_changed
                                                             %control-manufacturingorderitem   = cl_abap_behv=>flag_changed
                                                             %control-manufacturedate     = cl_abap_behv=>flag_changed
                                                             %control-reservation = cl_abap_behv=>flag_changed
                                                             %control-reservationitem = cl_abap_behv=>flag_changed
                                                           ) )
                                        ) )
                  ENTITY materialdocumentitem
                  CREATE BY \_serialnumber
                  FROM VALUE #( FOR ls_gr1 IN lt_gr
                                (
                                     %cid_ref                       = lv_cid_item && ls_gr1-matnr && ls_gr1-lgort && ls_gr1-pord
                                     %target                        = VALUE #( FOR ls_gr_3 IN lt_sernr WHERE ( matnr = ls_gr1-matnr  AND lgort = ls_gr1-lgort AND pord = ls_gr1-pord )
                                   ( %cid                           = lv_cid_item && ls_gr_3-matnr && ls_gr_3-sernr
                                     serialnumber                   = ls_gr_3-sernr
                                     %control-serialnumber          = cl_abap_behv=>flag_changed
                                    ) )
                   ) )

                   MAPPED DATA(mapped_261)
                   FAILED DATA(failed_261)
                   REPORTED DATA(reported_261).

              ELSE.

                MODIFY ENTITIES OF i_materialdocumenttp
                ENTITY materialdocument
                CREATE FROM VALUE #( ( %cid                                = lv_cid
                                       goodsmovementcode                   = '03'
                                       postingdate                         = gfs_header-docudt "shpflrdt
                                       documentdate                        = cl_abap_context_info=>get_system_date( )
                                       materialdocumentheadertext          = gfs_header-shpflrno
                                       referencedocument                   = gfs_header-uniqueid
                                       %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                       %control-postingdate                = cl_abap_behv=>flag_changed
                                       %control-documentdate               = cl_abap_behv=>flag_changed
                                       %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
                                       %control-referencedocument          = cl_abap_behv=>flag_changed
                                   ) )
                ENTITY materialdocument
                CREATE BY \_materialdocumentitem
                FROM VALUE #(
                                     (
                                       %cid_ref                            = lv_cid
                                       %target                             = VALUE #( FOR ls_gr1 IN lt_gr
                                                        ( %cid                         = lv_cid_item && ls_gr1-matnr && ls_gr1-lgort  && ls_gr1-pord
                                                          plant                        = ls_gr1-plant
                                                          material                     = ls_gr1-matnr
                                                          goodsmovementtype            = '261'
                                                          storagelocation              = ls_gr1-lgort
                                                          quantityinentryunit          = ls_gr1-quant
                                                          entryunit                    = ls_gr1-meins
                                                          manufacturingorder           = ls_gr1-pord
                                                          manufacturingorderitem       = ls_gr1-pitm
                                                          manufacturedate              = ls_gr1-sdate
                                                          reservation                  = ls_gr1-res
                                                          reservationitem              = ls_gr1-resitm

                                                          %control-plant               = cl_abap_behv=>flag_changed
                                                          %control-material            = cl_abap_behv=>flag_changed
                                                          %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                          %control-storagelocation     = cl_abap_behv=>flag_changed
                                                          %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                          %control-entryunit           = cl_abap_behv=>flag_changed
                                                          %control-manufacturingorder  = cl_abap_behv=>flag_changed
                                                          %control-manufacturingorderitem   = cl_abap_behv=>flag_changed
                                                          %control-manufacturedate     = cl_abap_behv=>flag_changed
                                                          %control-reservation = cl_abap_behv=>flag_changed
                                                          %control-reservationitem = cl_abap_behv=>flag_changed
                                                        )
                                                        )
                                     ) )

                MAPPED mapped_261
                FAILED failed_261
                REPORTED reported_261.

              ENDIF.


              IF reported_261-materialdocument IS NOT INITIAL.
                APPEND VALUE #(
                %tky                        = gfs_header-%tky
                %state_area                 = 'Validate_Head'
                %msg                        = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'Error in Goods Mvt 261'
                ) ) TO reported-zi_confpost_hdr.

                APPEND VALUE #(
                %tky = gfs_header-%tky
                ) TO failed-zi_confpost_hdr.

              ELSE.

                DATA : lv_log TYPE zi_confpost_log-log.
                DATA : lv_p    TYPE p.
                DATA lv_date TYPE datn.
                DATA lv_time TYPE timn.

                TRY.
                    CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                            INTO TIME STAMP FINAL(lv_timestamp1) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
                  CATCH cx_abap_context_info_error.
                ENDTRY.

                CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

                LOOP AT ord INTO DATA(ls_ord1) WHERE ( ordersta IS INITIAL OR ordersta = 'P' ) AND postqty IS NOT INITIAL.
                  MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                              ENTITY zi_confpost_ord
                              UPDATE FIELDS ( ordersta docsta status uniqueid )
                              WITH VALUE #( id = gfs_header-id
                                            ( %tky         = ls_ord1-%tky
                                              ordersta     = 'I'
                                              docsta       = 'I'
                                              status       = 'GI'
                                              uniqueid     = gfs_header-uniqueid
                                          ) ).


                  lv_p += 1.

                  TRY.
                      lv_log = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                    CATCH cx_uuid_error.
                  ENDTRY.
                  lv_log = lv_p && lv_log.
                  MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                        ENTITY zi_confpost_hdr
                        CREATE BY \_log
                        FROM VALUE #( ( id      = gfs_header-id
                                       %target = VALUE #( (     %cid                = lv_log
                                                                log                 = lv_log
                                                                refitem             = ls_ord1-item
                                                                reford              = ls_ord1-ord
                                                                shpflrno            = ls_ord1-shpflrno
                                                                matnr               = ls_ord1-matnr
                                                                meins               = ls_ord1-meins
                                                                prodord             = ls_ord1-prodord
                                                                qty                 = ls_ord1-postqty "pendprqty
                                                                postedby            = sy-uname
                                                                postedon            = lv_date
                                                                postedat            = lv_time
                                                                uniqueid            = gfs_header-uniqueid
                                                                 movtype            = '261'


                                                                %control-log          = if_abap_behv=>mk-on
                                                                %control-refitem      = if_abap_behv=>mk-on
                                                                %control-reford       = if_abap_behv=>mk-on
                                                                %control-matnr        = if_abap_behv=>mk-on
                                                                %control-meins        = if_abap_behv=>mk-on
                                                                %control-shpflrno     = if_abap_behv=>mk-on
                                                                %control-prodord      = if_abap_behv=>mk-on
                                                                %control-qty          = if_abap_behv=>mk-on
                                                                %control-postedby     = if_abap_behv=>mk-on
                                                                %control-postedon     = if_abap_behv=>mk-on
                                                                %control-postedat     = if_abap_behv=>mk-on
                                                                %control-uniqueid     = if_abap_behv=>mk-on
                                                                %control-movtype      = if_abap_behv=>mk-on

                                                         ) ) ) )
                                       MAPPED FINAL(ls_mapped)
                                       FAILED FINAL(ls_failed)
                                       REPORTED FINAL(ls_reported).

                  CLEAR : lv_log.

                ENDLOOP.

                gfs_header-status = 'Partially Completed'.
                MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                  ENTITY zi_confpost_hdr
                  UPDATE FIELDS ( status stat uniqueid )
                  WITH VALUE #( ( %tky   = gfs_header-%tky
                                  status = gfs_header-status
                                  uniqueid = gfs_header-uniqueid
                                  stat   = 'I' ) ).

              ENDIF.
*            ELSE.
*              lv_msg = |GR not possible as GI not done|.
*              APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.
*
*              APPEND VALUE #( %tky        = gfs_header-%tky
*                              %state_area = 'Validate_Header'
*                              %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                   text     = lv_msg ) )
*              TO reported-zi_confpost_hdr.
            ENDIF.

            WAIT UP TO 3 SECONDS.
          ELSE.
            lv_msg = |Order | && lv_ord &&  | is deleted/closed|.
            clear : lv_ord.
            APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

            APPEND VALUE #( %tky        = gfs_header-%tky
                            %state_area = 'Validate_Header'
                            %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = lv_msg ) )
            TO reported-zi_confpost_hdr.
          ENDIF.
        ELSE.
          lv_msg = |Please provide valid document date|.
          APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

          APPEND VALUE #( %tky        = gfs_header-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_confpost_hdr.
        ENDIF.

      ELSE.

        lv_msg = |Please provide document date|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_confpost_hdr.


      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).


  ENDMETHOD.

  METHOD scrap.

    TYPES : BEGIN OF ty_gr,
              matnr_1 TYPE matnr,
              matnr   TYPE matnr,
              plant   TYPE werks_d,
              lgort   TYPE lgort_d,
              quant   TYPE zdt_confpost_ord-pendprqty,
              meins   TYPE meins,
              sdate   TYPE zdt_confpost_hdr-shpflrdt,
              pord    TYPE zdt_confpost_ord-prodord,
              res     TYPE i_reservationdocumentheader-reservation,
              resitm  TYPE i_materialdocumentitemtp-reservationitem,
              pitm    TYPE i_manufacturingorderitem-manufacturingorderitem,
            END OF ty_gr.
    DATA : lt_gr   TYPE STANDARD TABLE OF ty_gr,
           lt_gr_1 TYPE STANDARD TABLE OF ty_gr,
           ls_gr   TYPE ty_gr.

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                 ENTITY zi_confpost_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_confpost_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    READ ENTITY zi_confpost_hdr
          BY \_ord
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(ord).



    SELECT b~matnr AS matnr_1, c~product AS matnr, b~plant, c~storagelocation AS lgort,
          ( division( ( b~postqty * e~requiredquantity ), f~mfgorderplannedtotalqty, 3 ) ) AS quant,
          " ( division( ( b~postqty * e~billofmaterialitemquantity ), d~bomheaderquantityinbaseunit, 3 ) ) AS quant,
           c~entryunit AS meins, @gfs_header-shpflrdt AS sdate, b~prodord AS pord, a~reservation AS res,
           c~reservationitem AS resitm
    FROM @ord AS b
    INNER JOIN i_reservationdocumentheader AS a ON a~orderid = b~prodord
    INNER JOIN i_reservationdocumentitem AS c ON c~reservation = a~reservation AND c~goodsmovementtype = '531'
    INNER JOIN i_billofmaterialtp_2 AS d ON d~material = b~matnr AND d~plant = b~plant
"    INNER JOIN i_billofmaterialitemtp_2 AS e ON e~material = b~matnr AND e~plant = b~plant
"                                            AND e~billofmaterialcomponent = c~product
    INNER JOIN i_mfgorderoperationcomponent AS e ON e~assembly = b~matnr AND e~plant = b~plant
                                                AND e~manufacturingorder = b~prodord AND e~material = c~product
    INNER JOIN i_manufacturingorder AS f ON f~manufacturingorder = b~prodord
    WHERE b~ordersta = 'I' AND c~reservationitmismarkedfordeltn <> 'X'
    INTO TABLE @lt_gr_1.

*    LOOP AT lt_gr ASSIGNING FIELD-SYMBOL(<fs_gr>).
*      SELECT SINGLE manufacturingorderitem FROM i_manufacturingorderitem
*      WHERE manufacturingorder = @<fs_gr>-pord
*      INTO @<fs_gr>-pitm.
*    ENDLOOP.

    SELECT a~matnr_1, a~matnr, a~plant, a~lgort, SUM( CASE WHEN a~quant LE 0 THEN ( -1 * a~quant ) ELSE a~quant END ) AS quant,
           a~meins, a~sdate, a~pord, a~res, a~resitm
     FROM @lt_gr_1 AS a
     GROUP BY matnr_1, matnr, plant, lgort, meins, sdate, pord, res, resitm
     INTO TABLE @lt_gr.

    DATA(lv_cid) = 'CID_'.
    DATA(lv_cid_item) = 'CID_ITEM_'.

*==531 Movement
    IF lt_gr IS NOT INITIAL.

      MODIFY ENTITIES OF i_materialdocumenttp
      ENTITY materialdocument
      CREATE FROM VALUE #( ( %cid                                = lv_cid
                             goodsmovementcode                   = '03'
                             postingdate                         = gfs_header-docudt "shpflrdt
                             documentdate                        = cl_abap_context_info=>get_system_date( )
                             materialdocumentheadertext          = gfs_header-shpflrno
                             referencedocument                   = gfs_header-uniqueid
                             %control-referencedocument          = cl_abap_behv=>flag_changed
                             %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                             %control-postingdate                = cl_abap_behv=>flag_changed
                             %control-documentdate               = cl_abap_behv=>flag_changed
                             %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
                         ) )
      ENTITY materialdocument
      CREATE BY \_materialdocumentitem
      FROM VALUE #(
                           (
                             %cid_ref                            = lv_cid
                             %target                             = VALUE #( FOR ls_gr1 IN lt_gr
                                              ( %cid                         = lv_cid_item && ls_gr1-matnr && ls_gr1-lgort && ls_gr1-pord
                                                plant                        = ls_gr1-plant
                                                material                     = ls_gr1-matnr
                                                goodsmovementtype            = '531'
                                                storagelocation              = ls_gr1-lgort
                                                quantityinentryunit          = ls_gr1-quant
                                                entryunit                    = ls_gr1-meins
                                                manufacturingorder           = ls_gr1-pord
                                                manufacturingorderitem       = ls_gr1-pitm
                                                manufacturedate              = ls_gr1-sdate
                                                reservation                  = ls_gr1-res
                                                reservationitem              = ls_gr1-resitm

                                                %control-plant               = cl_abap_behv=>flag_changed
                                                %control-material            = cl_abap_behv=>flag_changed
                                                %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                %control-storagelocation     = cl_abap_behv=>flag_changed
                                                %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                %control-entryunit           = cl_abap_behv=>flag_changed
                                                %control-manufacturingorder  = cl_abap_behv=>flag_changed
                                                %control-manufacturingorderitem   = cl_abap_behv=>flag_changed
                                                %control-manufacturedate     = cl_abap_behv=>flag_changed
                                                %control-reservation         = cl_abap_behv=>flag_changed
                                                %control-reservationitem     = cl_abap_behv=>flag_changed

                                              )
                                              )
                           ) )

      MAPPED DATA(mapped_531)
      FAILED DATA(failed_531)
      REPORTED DATA(reported_531).


      IF reported_531-materialdocument IS NOT INITIAL.
        APPEND VALUE #(
        %tky                        = gfs_header-%tky
        %state_area                 = 'Validate_Head'
        %msg                        = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = 'Error in Goods Mvt 531'
        ) ) TO reported-zi_confpost_hdr.

        APPEND VALUE #(
        %tky = gfs_header-%tky
        ) TO failed-zi_confpost_hdr.

      ELSE.

        DATA : lv_log TYPE zi_confpost_log-log.
        DATA : lv_p    TYPE p.
        DATA lv_date TYPE datn.
        DATA lv_time TYPE timn.

        TRY.
            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

        LOOP AT ord INTO DATA(ls_ord1) WHERE ordersta = 'I'.
          MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                      ENTITY zi_confpost_ord
                      UPDATE FIELDS ( ordersta docsta status )
                      WITH VALUE #( id = gfs_header-id
                                    ( %tky         = ls_ord1-%tky
                                      ordersta     = 'S'
                                      docsta       = 'S'
                                      status       = 'SCRAP'
                                  ) ).

          lv_p += 1.

          TRY.
              lv_log = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.
          lv_log = lv_p && lv_log.
          MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                ENTITY zi_confpost_hdr
                CREATE BY \_log
                FROM VALUE #( ( id      = gfs_header-id
                               %target = VALUE #( (     %cid                = lv_log
                                                        log                 = lv_log
                                                        refitem             = ls_ord1-item
                                                        reford              = ls_ord1-ord
                                                        shpflrno            = ls_ord1-shpflrno
                                                        matnr               = ls_ord1-matnr
                                                        meins               = ls_ord1-meins
                                                        prodord             = ls_ord1-prodord
                                                        qty                 = ls_ord1-postqty "pendprqty
                                                        postedby            = sy-uname
                                                        postedon            = lv_date
                                                        postedat            = lv_time
                                                        uniqueid            = gfs_header-uniqueid
                                                        movtype             = '531'


                                                        %control-log          = if_abap_behv=>mk-on
                                                        %control-refitem      = if_abap_behv=>mk-on
                                                        %control-reford       = if_abap_behv=>mk-on
                                                        %control-matnr        = if_abap_behv=>mk-on
                                                        %control-meins        = if_abap_behv=>mk-on
                                                        %control-shpflrno     = if_abap_behv=>mk-on
                                                        %control-prodord      = if_abap_behv=>mk-on
                                                        %control-qty          = if_abap_behv=>mk-on
                                                        %control-postedby     = if_abap_behv=>mk-on
                                                        %control-postedon     = if_abap_behv=>mk-on
                                                        %control-postedat     = if_abap_behv=>mk-on
                                                        %control-uniqueid     = if_abap_behv=>mk-on
                                                        %control-movtype      = if_abap_behv=>mk-on

                                                 ) ) ) )
                               MAPPED FINAL(ls_mapped)
                               FAILED FINAL(ls_failed)
                               REPORTED FINAL(ls_reported).

          CLEAR : lv_log.

        ENDLOOP.

        gfs_header-status = 'Partially Completed'.
        MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
          ENTITY zi_confpost_hdr
          UPDATE FIELDS ( status  stat )
          WITH VALUE #( ( %tky   = gfs_header-%tky
                          status = gfs_header-status
                          stat   = 'S' ) ).

      ENDIF.

    ELSE.

      LOOP AT ord INTO ls_ord1 WHERE ordersta = 'I'.
        MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
                    ENTITY zi_confpost_ord
                    UPDATE FIELDS ( ordersta docsta status )
                    WITH VALUE #( id = gfs_header-id
                                  ( %tky         = ls_ord1-%tky
                                    ordersta     = 'S'
                                    docsta       = 'S'
                                    status       = 'SCRAP'
                                ) ).

      ENDLOOP.

      gfs_header-status = 'Partially Completed'.
      MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
        ENTITY zi_confpost_hdr
        UPDATE FIELDS ( status stat )
        WITH VALUE #( ( %tky   = gfs_header-%tky
                        status = gfs_header-status
                        stat   = 'S' ) ).

    ENDIF.

    WAIT UP TO 3 SECONDS.


    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

  METHOD checkdet.

    DATA : lv_msg TYPE char100.
    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
             ENTITY zi_confpost_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zdt_confpost_hdr WHERE shpflrno = @gfs_header-shpflrno
    INTO @DATA(ls_check).

    IF ls_check IS NOT INITIAL.
      lv_msg = |Data created against this Shop Floor Number|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_confpost_hdr.

    ENDIF.

    SELECT SINGLE * FROM zdt_cont_ord WHERE shpflrno = @gfs_header-shpflrno AND status = 'C'
    INTO @DATA(ls_c_ord).
    IF ls_c_ord IS INITIAL.
      lv_msg = |No Confirmed order present against this Shop Floor|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_confpost_hdr.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_conf_ord DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_confpost_ord RESULT result.
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR zi_confpost_ord RESULT result.
    METHODS calqty FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_confpost_ord~calqty.
    METHODS checkord FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_confpost_ord~checkord.
ENDCLASS.
CLASS lhc_zi_conf_ord IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(ord_failed).


    result = VALUE #(
          FOR gs_item IN ord
          ( %tky                       = gs_item-%tky
            %field-postqty             = COND #( WHEN gs_item-pendprqty = gs_item-alpostqty " and gs_item-ordersta = 'P'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 WHEN gs_item-ordersta = 'S' OR gs_item-ordersta = 'I' OR gs_item-ordersta = 'R'
                                                 THEN if_abap_behv=>fc-f-read_only
                                                 ELSE if_abap_behv=>fc-o-enabled  )

          ) ).

  ENDMETHOD.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

  METHOD calqty.
    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
            ENTITY zi_confpost_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
           ENTITY zi_confpost_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(ord_failed).

    LOOP AT ord INTO DATA(ls_ord).
      ls_ord-balqty = ls_ord-pendprqty - ( ls_ord-alpostqty + ls_ord-postqty ).
      MODIFY ENTITIES OF zi_confpost_hdr IN LOCAL MODE
              ENTITY zi_confpost_ord
              UPDATE FIELDS ( balqty )
              WITH VALUE #( id = ls_ord-id
                            ( %tky         = ls_ord-%tky
                              balqty       = ls_ord-balqty
                          ) ).
      CLEAR : ls_ord.
    ENDLOOP.
  ENDMETHOD.
  METHOD checkord.
    DATA : lv_msg TYPE char100.
    READ ENTITIES OF zi_confpost_hdr IN LOCAL MODE
             ENTITY zi_confpost_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_confpost_hdr
           BY \_ord
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(ord).

    LOOP AT ord INTO DATA(ls_ord).
      IF ls_ord-pendprqty LT ( ls_ord-alpostqty + ls_ord-postqty ).
        lv_msg = |Posting quantity is greater than available quantity|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_confpost_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_confpost_hdr.
      ENDIF.
      CLEAR : ls_ord.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
