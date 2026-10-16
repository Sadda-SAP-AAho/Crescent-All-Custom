CLASS lhc_zi_exim_bank_mast DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_exim_bank_mast RESULT result.
    METHODS get_instance_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR zi_exim_bank_mast RESULT result.
    METHODS save_details FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_exim_bank_mast~save_details.
    METHODS banktypedetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_exim_bank_mast~banktypedetails.
    METHODS get_compdata FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_exim_bank_mast~get_compdata.

ENDCLASS.


CLASS lhc_zi_exim_bank_mast IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_exim_bank_mast IN LOCAL MODE
               ENTITY zi_exim_bank_mast
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(header_failed).

    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    result = VALUE #(
    FOR gs_header IN header
    ( %tky                            = gs_header-%tky

*          %field-customercode             = COND #( WHEN gs_header-type = 'PO' OR gs_header-gatepass IS NOT INITIAL OR gs_header-type = 'NONPO / SERVICE' OR gs_header-type = 'RGP' OR gs_header-type = 'STO'
*                                                    THEN if_abap_behv=>fc-f-read_only
*                                                    ELSE if_abap_behv=>fc-o-enabled )
      %field-hktid                     = COND #( WHEN gs_header-banktype = 'OTHER BANK'
                                                THEN if_abap_behv=>fc-f-read_only
                                                ELSE if_abap_behv=>fc-f-mandatory )

      %field-hbkid                     = COND #( WHEN gs_header-banktype = 'OTHER BANK'
                                                THEN if_abap_behv=>fc-f-read_only
                                                ELSE if_abap_behv=>fc-f-mandatory )
      %field-zland1                     = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
                                                THEN if_abap_behv=>fc-f-read_only
                                                ELSE if_abap_behv=>fc-o-enabled )
      %field-zifsccode                  = COND #( WHEN gs_header-banktype = 'OTHER BANK'
                                                THEN if_abap_behv=>fc-f-read_only
                                                ELSE if_abap_behv=>fc-o-enabled )
      %field-zvendor                    = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
                                                THEN if_abap_behv=>fc-f-mandatory
                                                ELSE if_abap_behv=>fc-f-unrestricted )
      %field-zbankgl                    = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
                                                THEN if_abap_behv=>fc-f-mandatory
                                                ELSE if_abap_behv=>fc-f-unrestricted )
*      %field-hbkid                    = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
*                                                THEN if_abap_behv=>fc-f-mandatory
*                                                ELSE if_abap_behv=>fc-f-unrestricted )
*      %field-hktid                    = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
*                                                THEN if_abap_behv=>fc-f-mandatory
*                                                ELSE if_abap_behv=>fc-f-unrestricted )
      %field-zincgl                    = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
                                                THEN if_abap_behv=>fc-f-mandatory
                                                ELSE if_abap_behv=>fc-f-unrestricted )
      %field-zoutgl                   = COND #( WHEN gs_header-banktype = 'HOUSE BANK'
                                                THEN if_abap_behv=>fc-f-mandatory
                                                ELSE if_abap_behv=>fc-f-unrestricted )


                                                ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD save_details.
    DATA: lv_msg TYPE string .

    READ ENTITIES OF zi_exim_bank_mast IN LOCAL MODE
           ENTITY zi_exim_bank_mast
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

*//--- Bank Id & Account Id validation
    IF gfs_header-hbkid IS INITIAL OR gfs_header-hktid IS INITIAL.
      lv_msg = |Please Maintain House Bank and House Bank Account |.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_exim_bank_mast.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_exim_bank_mast.
      RETURN.
    ENDIF.

    IF gfs_header-bukrs IS NOT INITIAL AND gfs_header-banktype = 'HOUSE BANK' .
      SELECT SINGLE * FROM zexim_bank_mast WHERE bukrs = @gfs_header-bukrs AND
                                                 hbkid = @gfs_header-hbkid AND
                                                 hktid = @gfs_header-hktid
            INTO @DATA(lv_bankid).
      IF sy-subrc = 0 AND lv_bankid IS NOT INITIAL.

        lv_msg = |Same House Bank and House Bank Account Already Exist|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_exim_bank_mast.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_exim_bank_mast.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD banktypedetails.

  ENDMETHOD.

  METHOD get_compdata.

    READ ENTITIES OF zi_exim_bank_mast IN LOCAL MODE
             ENTITY zi_exim_bank_mast
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-bukrs IS NOT INITIAL AND gfs_header-banktype = 'HOUSE BANK'.
      SELECT SINGLE * FROM i_companycode
      WHERE companycode = @gfs_header-bukrs
      INTO @DATA(ls_company) .
      IF sy-subrc EQ 0.
        gfs_header-zland1 = ls_company-country .
      ENDIF.

      MODIFY ENTITIES OF zi_exim_bank_mast IN LOCAL MODE
             ENTITY zi_exim_bank_mast
             UPDATE
             FIELDS ( zland1 )
             WITH VALUE #( ( %tky   = gfs_header-%tky

                             zland1 = gfs_header-zland1
                             ) ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
