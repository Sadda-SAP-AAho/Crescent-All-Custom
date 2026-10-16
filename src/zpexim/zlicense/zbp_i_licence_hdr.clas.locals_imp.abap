CLASS lhc_zi_licence_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_licence_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_licence_hdr RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_licence_hdr~cancel RESULT result.

    METHODS getlicencedtls FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_licence_hdr~getlicencedtls.
    METHODS getexptodate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_licence_hdr~getexptodate.

    METHODS getimptodate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_licence_hdr~getimptodate.
    METHODS updateamount FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_licence_hdr~updateamount.
    METHODS cal FOR MODIFY
      IMPORTING keys FOR ACTION zi_licence_hdr~cal RESULT result.

***    METHODS print FOR MODIFY
***      IMPORTING keys FOR ACTION zi_licence_hdr~print RESULT result.

ENDCLASS.

CLASS lhc_zi_licence_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel.
  ENDMETHOD.

***  METHOD print.
***  ENDMETHOD.

  METHOD getlicencedtls.

    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
       ENTITY zi_licence_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).
    " ---------------------------------------------------------------------
    " == Get Licence Details
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-licenceint IS NOT INITIAL AND gfs_header-licenceext IS INITIAL.
      SELECT SINGLE * FROM zdt_epcg_hdr  WHERE ecomno = @gfs_header-licenceint INTO @DATA(gfs_licencedtls).
      IF sy-subrc EQ 0.

        gfs_header-licenceext      = gfs_licencedtls-licno .
        gfs_header-licencedate     = gfs_licencedtls-licdate .
        gfs_header-liccurrency     = gfs_licencedtls-waers .
        gfs_header-licencestatus   = 'OPEN'.
        gfs_header-licenceval      = gfs_licencedtls-totalcifvalue.
        gfs_header-companycode     = gfs_licencedtls-bukrs.
***        gfs_header-plandutysaveinr = gfs_licencedtls-totaldutysave.
        gfs_header-plandutysaveinr = gfs_licencedtls-dutysaveval.
*            gfs_header-Actualdutysaveinr = gfs_licencedtls-.
***        gfs_header-remaindutysave  = gfs_licencedtls-totaldutysave.
        gfs_header-remaindutysave  = gfs_licencedtls-dutysaveval.
        gfs_header-licencetype     = 'EPCG'.

        MODIFY ENTITIES OF zi_licence_hdr IN LOCAL MODE
               ENTITY zi_licence_hdr
               UPDATE
               FIELDS ( licenceext licencedate liccurrency licenceval companycode
                         plandutysaveinr remaindutysave licencestatus licencetype )
               WITH VALUE #( ( %tky          = gfs_header-%tky

                                licenceext      = gfs_header-licenceext
                                licencedate     = gfs_header-licencedate
                                licenceval      = gfs_header-licenceval
                                liccurrency     = gfs_header-liccurrency
                                licencestatus   = gfs_header-licencestatus
                                companycode     = gfs_header-companycode
                                plandutysaveinr = gfs_header-plandutysaveinr
                                remaindutysave  = gfs_header-remaindutysave
                                licencetype     = gfs_header-licencetype

                               ) ).

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD getexptodate.

    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
           ENTITY zi_licence_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header)
           FAILED DATA(header_failed).
    " ---------------------------------------------------------------------
    " == Get Export To date
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-exportvalidfrom IS NOT INITIAL.

      gfs_header-exportvalidto     = gfs_header-exportvalidfrom + ( 365 * 6 ) .
      gfs_header-exportvalid4yfrom = gfs_header-exportvalidfrom .
      gfs_header-exportvalid4yto   = gfs_header-exportvalidfrom + ( 365 * 4 ) .
      gfs_header-exportvalid2yfrom = gfs_header-exportvalid4yto + 1.
      gfs_header-exportvalid2yto   = gfs_header-exportvalid2yfrom + ( 365 * 2 ) - 1.

      MODIFY ENTITIES OF zi_licence_hdr IN LOCAL MODE
             ENTITY zi_licence_hdr
             UPDATE
             FIELDS ( exportvalidto exportvalid2yfrom exportvalid2yto exportvalid4yfrom exportvalid4yto   )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                              exportvalidto      = gfs_header-exportvalidto
                              exportvalid2yfrom  = gfs_header-exportvalid2yfrom
                              exportvalid2yto    = gfs_header-exportvalid2yto
                              exportvalid4yfrom  = gfs_header-exportvalid4yfrom
                              exportvalid4yto    = gfs_header-exportvalid4yto

                             ) ).
    ENDIF.


***    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
***       ENTITY zi_licence_hdr
***       ALL FIELDS
***       WITH CORRESPONDING #( keys )
***       RESULT DATA(header)
***       FAILED DATA(header_failed).
***    " ---------------------------------------------------------------------
***    " == Get Export To date
***    " ---------------------------------------------------------------------
***    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
***    IF gfs_header-importvalidfrom IS NOT INITIAL.
***
***      gfs_header-importvalidto = gfs_header-importvalidfrom + ( 365 * 2 ) .
***
***      MODIFY ENTITIES OF zi_licence_hdr IN LOCAL MODE
***             ENTITY zi_licence_hdr
***             UPDATE
***             FIELDS ( importvalidto )
***             WITH VALUE #( ( %tky          = gfs_header-%tky
***
***                              importvalidto      = gfs_header-importvalidto
***                             ) ).
***    ENDIF.

  ENDMETHOD.

  METHOD getimptodate.

    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
       ENTITY zi_licence_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).
    " ---------------------------------------------------------------------
    " == Get Export To date
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-importvalidfrom IS NOT INITIAL.

      gfs_header-importvalidto = gfs_header-importvalidfrom + ( 365 * 2 ) .

      MODIFY ENTITIES OF zi_licence_hdr IN LOCAL MODE
             ENTITY zi_licence_hdr
             UPDATE
             FIELDS ( importvalidto )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                              importvalidto      = gfs_header-importvalidto
                             ) ).
    ENDIF.

  ENDMETHOD.

  METHOD updateamount.

***    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
***       ENTITY zi_licence_hdr
***       ALL FIELDS
***       WITH CORRESPONDING #( keys )
***       RESULT DATA(header)
***       FAILED DATA(header_failed).
***    " ---------------------------------------------------------------------
***    " == Update Amount
***    " ---------------------------------------------------------------------
***    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
***    IF gfs_header-importvalidfrom IS NOT INITIAL.
***
***      gfs_header-importvalidto = gfs_header-importvalidfrom + ( 365 * 2 ) .
***
***      MODIFY ENTITIES OF zi_licence_hdr IN LOCAL MODE
***             ENTITY zi_licence_hdr
***             UPDATE
***             FIELDS ( importvalidto )
***             WITH VALUE #( ( %tky          = gfs_header-%tky
***
***                              importvalidto      = gfs_header-importvalidto
***                             ) ).
***    ENDIF.

  ENDMETHOD.

  METHOD cal.
    DATA: lt_epcg_ultdata TYPE STANDARD TABLE OF zr_licence_hdr.

    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
       ENTITY zi_licence_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    CLEAR:lt_epcg_ultdata[].

* //== Get All Utilization EPCG license Data ==//
* //== Import Section ==//
    SELECT * FROM zr_licence_hdr WHERE licenceint = @gfs_header-licenceint
             APPENDING CORRESPONDING FIELDS OF TABLE @lt_epcg_ultdata.

    READ TABLE lt_epcg_ultdata INTO DATA(ls_epcg_ultdata) WITH KEY licenceint = gfs_header-licenceint.
    IF sy-subrc EQ 0.
      gfs_header-actualdutysaveinr = ( ls_epcg_ultdata-boeusage + ls_epcg_ultdata-shipusage ).
      gfs_header-remaindutysave    = gfs_header-plandutysaveinr - gfs_header-actualdutysaveinr .

      IF ls_epcg_ultdata-shipusage IS NOT INITIAL.
        gfs_header-explicutilisedinr = ls_epcg_ultdata-shipusage  * 6 .
      ENDIF.

    ENDIF.

* //== Get All Utilization EPCG license Data ==
* //== Export Section ==//
    SELECT SINGLE * FROM zdt_epcg_hdr  WHERE ecomno = @gfs_header-licenceint INTO @DATA(gfs_epcglic).
    IF sy-subrc EQ 0.
      gfs_header-expobigationinr = gfs_epcglic-plannedexpobg.
      gfs_header-explicremaininr = gfs_header-expobigationinr.

      IF ls_epcg_ultdata-explicutilisedinr IS NOT INITIAL.
        gfs_header-explicremaininr = gfs_header-explicremaininr - gfs_header-explicutilisedinr .
      ENDIF.
    ENDIF.

* //== Modify Header ==//
    MODIFY ENTITIES OF zi_licence_hdr IN LOCAL MODE
               ENTITY zi_licence_hdr
               UPDATE FIELDS ( actualdutysaveinr remaindutysave expobigationinr explicremaininr explicutilisedinr )
               WITH VALUE #( ( %tky               = gfs_header-%tky

                               actualdutysaveinr  = gfs_header-actualdutysaveinr
                               remaindutysave     = gfs_header-remaindutysave
                               expobigationinr    = gfs_header-expobigationinr
                               explicremaininr    = gfs_header-explicremaininr
                               explicutilisedinr  = gfs_header-explicutilisedinr
                           ) ).

    READ ENTITIES OF zi_licence_hdr IN LOCAL MODE
           ENTITY zi_licence_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).

    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.
