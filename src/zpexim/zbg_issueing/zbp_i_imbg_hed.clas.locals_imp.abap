CLASS lhc_zi_imbg_hed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_imbg_hed RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_imbg_hed RESULT result.
    METHODS updatedetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_imbg_hed~updatedetails.
    METHODS get_companydtls FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_imbg_hed~get_companydtls.
    METHODS get_bankdtls FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_imbg_hed~get_bankdtls.
    METHODS upd_tenure FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_imbg_hed~upd_tenure.
    METHODS upd_lcamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_imbg_hed~upd_lcamt.
    METHODS upd_lcamt_exchange FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_imbg_hed~upd_lcamt_exchange.

ENDCLASS.

CLASS lhc_zi_imbg_hed IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
               ENTITY zi_imbg_hed
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    result = VALUE #( FOR ls_header IN header
                     (
                          %tky                  = gfs_header-%tky

                          %field-bgexchangerate = COND #( WHEN ls_header-bgcurrencyfc = 'INR'
                                                           THEN if_abap_behv=>fc-f-read_only
                                                           ELSE if_abap_behv=>fc-f-mandatory
                                                         )

                          %field-bgcleanassign  = COND #( WHEN ls_header-bgcharacter = 'FD BASED'
                                                           THEN if_abap_behv=>fc-f-read_only
                                                           ELSE if_abap_behv=>fc-f-mandatory
                                                         )
                          %field-bgstat         = if_abap_behv=>fc-f-read_only

                      ) ).

  ENDMETHOD.

  METHOD updatedetails.

    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
               ENTITY zi_imbg_hed
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-bgbenefcode IS NOT INITIAL .
***      SELECT SINGLE * FROM zr_supplier_f4 WHERE supplier = @gfs_header-bgbenefcode INTO @DATA(ls_supplier).
      SELECT SINGLE * FROM zr_benefitcode_f4 WHERE code = @gfs_header-bgbenefcode INTO @DATA(ls_name).
      IF sy-subrc EQ 0.
        gfs_header-bgbenefname = ls_name-name.
      ENDIF.
    ENDIF.


    MODIFY ENTITIES OF zi_imbg_hed IN LOCAL MODE
             ENTITY zi_imbg_hed
             UPDATE
             FIELDS ( bgbenefname )
             WITH VALUE #( FOR key IN keys
                           ( %tky       = gfs_header-%tky

                             bgbenefname   = gfs_header-bgbenefname
*                            %control-postingdate   = if_abap_behv=>mk-on
                          ) ).

  ENDMETHOD.

  METHOD get_companydtls.

    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
               ENTITY zi_imbg_hed
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE a~companycode,a~companycodename,a~cityname,a~country,
                  b~countryname
    FROM i_companycode AS a
    INNER JOIN zi_country_f4 AS b ON a~country = b~country
    WHERE a~companycode = @gfs_header-companycode
    INTO @DATA(ls_companydtls).
    IF sy-subrc EQ 0.
      gfs_header-bgappnam   = ls_companydtls-companycodename.
      gfs_header-city       = ls_companydtls-cityname.
      gfs_header-country    = ls_companydtls-countryname.
    ENDIF.

    IF gfs_header-bgstat IS INITIAL .
      gfs_header-bgstat = 'OPEN'.
    ENDIF.

    IF gfs_header-bgcharacter IS INITIAL .
      gfs_header-bgcharacter = 'FD BASED'.
    ENDIF.

    gfs_header-bgcurrency     = 'INR'.
    gfs_header-bgexchangerate = '1.0000'.

    MODIFY ENTITIES OF zi_imbg_hed IN LOCAL MODE
             ENTITY zi_imbg_hed
             UPDATE
             FIELDS ( bgappnam city country bgstat bgcurrency bgexchangerate )
             WITH VALUE #( FOR key IN keys
                           ( %tky       = gfs_header-%tky

                             bgappnam       = gfs_header-bgappnam
                             city           = gfs_header-city
                             country        = gfs_header-country
                             bgstat         = gfs_header-bgstat
                             bgcurrency     = gfs_header-bgcurrency
                             bgexchangerate = gfs_header-bgexchangerate

*                                    %control-postingdate   = if_abap_behv=>mk-on
                              ) ).

  ENDMETHOD.

  METHOD get_bankdtls.

    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
               ENTITY zi_imbg_hed
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-hbkid IS NOT INITIAL.

      SELECT SINGLE * FROM zr_bankmast WHERE hbkid = @gfs_header-hbkid INTO @DATA(ls_bankmast).
      IF sy-subrc EQ 0 .
        gfs_header-bankaddr   = ls_bankmast-zaddress.
        gfs_header-bankbrnch  = ls_bankmast-zbranch.
        gfs_header-bankl      = ls_bankmast-bankl.
        gfs_header-banknam    = ls_bankmast-zbank.
        gfs_header-bankvendor = ls_bankmast-zvendor.
        gfs_header-zifsccode  = ls_bankmast-zifsccode.
*        gfs_header-hktid      = ls_bankmast-hktid.

        IF ls_bankmast-zvendor IS NOT INITIAL.
          SELECT SINGLE * FROM i_supplier WHERE supplier = @ls_bankmast-zvendor INTO @DATA(lv_suppname) .
          gfs_header-bankvendorname = lv_suppname-supplierfullname .
          CLEAR lv_suppname.
        ENDIF.

        SELECT SINGLE * FROM zr_bank_limit
                        WHERE hbkid = @gfs_header-hbkid AND
                              hktid = @gfs_header-hktid AND
                              bukrs = @gfs_header-companycode AND
                              bglimit <> '0.00'
                        INTO @DATA(ls_bank_limit) .
        IF sy-subrc EQ 0.
          gfs_header-banklimit    = ls_bank_limit-bglimit .
          gfs_header-bgcleanlimit = ls_bank_limit-bglimit - ls_bank_limit-bgutilised.
        ENDIF.

        gfs_header-zifsccode = ls_bankmast-zifsccode .

        MODIFY ENTITIES OF zi_imbg_hed IN LOCAL MODE
               ENTITY zi_imbg_hed
               UPDATE
               FIELDS ( bankaddr bankbrnch bankl banknam bankvendor bankvendorname zifsccode
                        banklimit bgcleanlimit )
               WITH VALUE #( FOR key IN keys
                             ( %tky       = gfs_header-%tky

                               bankaddr       = gfs_header-bankaddr
                               bankbrnch      = gfs_header-bankbrnch
                               bankl          = gfs_header-bankl
                               banknam        = gfs_header-banknam
                               bankvendor     = gfs_header-bankvendor
                               bankvendorname = gfs_header-bankvendorname
                               zifsccode      = gfs_header-zifsccode
                               banklimit      = gfs_header-banklimit
                               bgcleanlimit   = gfs_header-bgcleanlimit
*                               hktid          = gfs_header-hktid

*                                    %control-postingdate   = if_abap_behv=>mk-on
                                ) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD upd_tenure.

    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
               ENTITY zi_imbg_hed
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    IF gfs_header-bgeffdt IS NOT INITIAL AND gfs_header-bgclaimexpdt IS NOT INITIAL.
      gfs_header-bgtenure = gfs_header-bgclaimexpdt - gfs_header-bgeffdt + 1 .


      MODIFY ENTITIES OF zi_imbg_hed IN LOCAL MODE
             ENTITY zi_imbg_hed
             UPDATE
             FIELDS ( bgtenure )
             WITH VALUE #( FOR key IN keys
                           ( %tky       = gfs_header-%tky

                             bgtenure   = gfs_header-bgtenure
                           ) ).
    ENDIF.

  ENDMETHOD.

  METHOD upd_lcamt.
    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
             ENTITY zi_imbg_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    IF gfs_header-bgamt IS NOT INITIAL AND gfs_header-bgcurrencyfc IS NOT INITIAL.
      IF gfs_header-bgcurrencyfc = 'INR'.
        gfs_header-bgexchangerate = '1.0000'.
      ENDIF.

      gfs_header-bglcamt    = gfs_header-bgamt * gfs_header-bgexchangerate.
      gfs_header-netbglimit = gfs_header-bglcamt .
    ENDIF.

    MODIFY ENTITIES OF zi_imbg_hed IN LOCAL MODE
       ENTITY zi_imbg_hed
       UPDATE
       FIELDS ( bglcamt netbglimit bgexchangerate )
       WITH VALUE #( FOR key IN keys
                     ( %tky       = gfs_header-%tky

                       bglcamt         = gfs_header-bglcamt
                       netbglimit      = gfs_header-netbglimit
                       bgexchangerate  = gfs_header-bgexchangerate
                     ) ).


  ENDMETHOD.

  METHOD upd_lcamt_exchange.

    READ ENTITIES OF zi_imbg_hed IN LOCAL MODE
             ENTITY zi_imbg_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    IF gfs_header-bgamt IS NOT INITIAL AND gfs_header-bgcurrencyfc IS NOT INITIAL.
      IF gfs_header-bgcurrencyfc = 'INR'.
        gfs_header-bgexchangerate = '1.0000'.
      ENDIF.

      gfs_header-bglcamt    = gfs_header-bgamt * gfs_header-bgexchangerate.
      gfs_header-netbglimit = gfs_header-bglcamt .
    ENDIF.

    MODIFY ENTITIES OF zi_imbg_hed IN LOCAL MODE
       ENTITY zi_imbg_hed
       UPDATE
       FIELDS ( bglcamt netbglimit )
       WITH VALUE #( FOR key IN keys
                     ( %tky       = gfs_header-%tky

                       bglcamt         = gfs_header-bglcamt
                       netbglimit      = gfs_header-netbglimit
                     ) ).

  ENDMETHOD.

ENDCLASS.
