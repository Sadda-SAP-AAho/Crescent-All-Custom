CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS fdheaddetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~fdheaddetails.

    METHODS fdheadcheck FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~fdheadcheck.

    METHODS fdpost FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~fdpost.

    METHODS fdclose FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~fdclose.

    METHODS fdchange FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~fdchange.

ENDCLASS.


CLASS lhc_head IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    FINAL(ls_header_t) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    SELECT SINGLE * FROM zr_fdhead
      WHERE id = @ls_header_t-id
      INTO @FINAL(ls_fdhead).

    result = VALUE #(
        FOR ls_header IN lt_header
        ( %tky                  = ls_header-%tky

          %field-bankkey        = COND #( WHEN ls_header-bankkey IS INITIAL
                                          THEN if_abap_behv=>fc-f-mandatory
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-bankname       = if_abap_behv=>fc-f-read_only

*          %field-amount         = COND #( WHEN ls_header-amount IS INITIAL
*                                          THEN if_abap_behv=>fc-f-mandatory
*                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-rateofinterest = COND #( WHEN ls_header-rateofinterest IS INITIAL
                                          THEN if_abap_behv=>fc-f-mandatory
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-remarkopen     = COND #( WHEN ls_header-remarkopen IS INITIAL AND ls_header-statuscode <> '2'
                                          THEN if_abap_behv=>fc-f-mandatory
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-remarkclose    = COND #( WHEN ls_header-remarkclose IS INITIAL AND ls_header-statuscode <> '3'
                                          THEN if_abap_behv=>fc-f-mandatory
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-revfdmaturedate    = COND #( WHEN ls_header-postfd IS NOT INITIAL
                                          THEN if_abap_behv=>fc-f-read_only
                                          ELSE if_abap_behv=>fc-f-unrestricted )

          %field-revrateofinterest    = COND #( WHEN ls_header-postfd IS NOT INITIAL
                                          THEN if_abap_behv=>fc-f-read_only
                                          ELSE if_abap_behv=>fc-f-unrestricted )

          %field-renewal    = COND #( WHEN ls_header-postclose IS NOT INITIAL
                                          THEN if_abap_behv=>fc-f-read_only
                                          ELSE if_abap_behv=>fc-f-unrestricted )

          %field-postclose      = COND #( WHEN ls_header-postclose = '' AND ls_fdhead-postfd IS NOT INITIAL
                                          THEN if_abap_behv=>fc-f-unrestricted
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-closedocumentdate      = COND #( WHEN ls_header-postclose = '' AND ls_fdhead-postfd IS NOT INITIAL
                                          THEN if_abap_behv=>fc-f-unrestricted
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-closepostingdate      = COND #( WHEN ls_header-postclose = '' AND ls_fdhead-postfd IS NOT INITIAL
                                          THEN if_abap_behv=>fc-f-unrestricted
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-postfd         = COND #( WHEN ls_fdhead-id IS NOT INITIAL AND ls_header-postfd IS INITIAL
                                          THEN if_abap_behv=>fc-f-unrestricted
                                          WHEN ( sy-uname = 'CB9980000000' )
                                          THEN if_abap_behv=>fc-f-unrestricted
                                          ELSE if_abap_behv=>fc-f-read_only )

          %field-bg         = COND #( WHEN ls_header-postclose = ''
                                          THEN if_abap_behv=>fc-f-unrestricted
                                          ELSE if_abap_behv=>fc-f-read_only )

          %assoc-_incgl         = COND #( WHEN ls_header-postclose = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )

          %assoc-_outgl         = COND #( WHEN ls_header-postfd = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )

          %assoc-_interest      = COND #( WHEN ls_header-postclose = '' AND ls_header-postfd IS NOT INITIAL
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD fdheaddetails.
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).
    IF lt_header IS NOT INITIAL.

      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
      IF ls_header IS NOT INITIAL.

        SELECT SINGLE * FROM i_bank_2
          WHERE bank = @ls_header-bankkey
          INTO @FINAL(ls_bank).

        IF ls_header-statuscode IS INITIAL.
          ls_header-statuscode = '1'.
          ls_header-statusdesc = 'Created'.
        ENDIF.

        MODIFY ENTITIES OF zr_fdhead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( bankname statuscode statusdesc )
               WITH VALUE #( ( %tky       = ls_header-%tky
                               bankname   = ls_bank-bankname
                               statuscode = ls_header-statuscode
                               statusdesc = ls_header-statusdesc ) ).
      ENDIF.
    ENDIF.
    CLEAR ls_header.
  ENDMETHOD.

  METHOD fdheadcheck.
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_fdhead
         BY \_outgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_outgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_outgl_failed).

    READ ENTITY zr_fdhead
         BY \_incgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_incgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_incgl_failed).

    READ ENTITY zr_fdhead
         BY \_interest
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_interest)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_interest_failed).

    IF lt_header IS NOT INITIAL.

      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
      IF ls_header IS NOT INITIAL.

        SELECT SINGLE * FROM zdt_fd_head
          WHERE fdcertificateno = @ls_header-fdcertificateno AND id <> @ls_header-id
        " TODO: variable is assigned but never used (ABAP cleaner)
          INTO @FINAL(ls_head).
        IF sy-subrc = 0.
          APPEND VALUE #( %tky            = ls_header-%tky
                          %state_area     = 'Validate_Head'
                          %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = 'Duplicate Certificate Number' )
                          %element-amount = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-remarkopen IS INITIAL AND ls_header-statuscode = '1'.
          APPEND VALUE #(
              %tky                 = ls_header-%tky
              %state_area          = 'Validate_Head'
              %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text     = 'Please provide the Opening Remarks' )
              %element-remarkclose = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-remarkopen IS INITIAL.
          APPEND VALUE #( %tky                = ls_header-%tky
                          %state_area         = 'Validate_Head'
                          %msg                = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                       text     = 'Please provide the Opening Remarks' )
                          %element-remarkopen = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-revfdmaturedate IS NOT INITIAL AND ls_header-revfdmaturedate < ls_header-fdmaturedate.
          APPEND VALUE #( %tky                = ls_header-%tky
                          %state_area         = 'Validate_Head'
                          %msg                = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                       text     = 'Revised Maturity Date must be greater than Initial Maturity Date' )
                          %element-remarkopen = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-bankkey IS INITIAL.
          APPEND VALUE #( %tky            = ls_header-%tky
                          %state_area     = 'Validate_Head'
                          %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = 'Please provide the Bank Key' )
                          %element-amount = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-amount IS INITIAL.
          APPEND VALUE #( %tky            = ls_header-%tky
                          %state_area     = 'Validate_Head'
                          %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = 'Please provide the amount' )
                          %element-amount = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-rateofinterest IS INITIAL.
          APPEND VALUE #( %tky                    = ls_header-%tky
                          %state_area             = 'Validate_Head'
                          %msg                    = new_message_with_text(
                                                        severity = if_abap_behv_message=>severity-error
                                                        text     = 'Please provide the Rate of Interest' )
                          %element-rateofinterest = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF lines( lt_outgl ) <> 1.
          APPEND VALUE #( %tky                    = ls_header-%tky
                          %state_area             = 'Validate_Head'
                          %msg                    = new_message_with_text(
                                                        severity = if_abap_behv_message=>severity-error
                                                        text     = 'At least one entry required in Outgoing Bank GL' )
                          %element-rateofinterest = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF lines( lt_incgl ) <> 1.
          APPEND VALUE #( %tky                    = ls_header-%tky
                          %state_area             = 'Validate_Head'
                          %msg                    = new_message_with_text(
                                                        severity = if_abap_behv_message=>severity-error
                                                        text     = 'At least one entry required in Incoming Bank GL' )
                          %element-rateofinterest = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        FINAL(ls_incgl) = VALUE #( lt_incgl[ 1 ] OPTIONAL ).
        IF ls_incgl-bankreference IS INITIAL AND ls_header-postclose = 'X'.
          APPEND VALUE #( %tky            = ls_header-%tky
                          %state_area     = 'Validate_Head'
                          %msg            = new_message_with_text(
                                                severity = if_abap_behv_message=>severity-error
                                                text     = 'Please provide the Bank Reference in the Incoming GL' )
                          %element-amount = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.

        IF ls_header-remarkclose IS INITIAL AND ls_header-postclose IS NOT INITIAL.
          APPEND VALUE #(
              %tky                 = ls_header-%tky
              %state_area          = 'Validate_Head'
              %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text     = 'Please provide the Closing Remarks' )
              %element-remarkclose = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR ls_header.
  ENDMETHOD.

  METHOD fdpost.
    DATA lv_cid     TYPE abp_behv_cid.
    DATA lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
    DATA lt_je_val  TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.
    DATA lv_text    TYPE char128.

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_fdhead
         BY \_outgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_outgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_outgl_failed).

    READ ENTITY zr_fdhead
         BY \_incgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_incgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_incgl_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    FINAL(ls_outgl) = VALUE #( lt_outgl[ 1 ] OPTIONAL ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(ls_incgl) = VALUE #( lt_incgl[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zr_fdhead
      WHERE id = @ls_header-id
      INTO @FINAL(ls_fdhead).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " FD Open Accounting
    IF NOT (     ls_header-statuscode  = '1'
             AND ls_header-postfd     IS NOT INITIAL
             AND ls_fdhead-postfd     IS INITIAL
             AND lines( lt_outgl )     = 1 ).
      RETURN.
    ENDIF.

    CLEAR lv_cid.
    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
    ENDTRY.

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid   = lv_cid.
    <je_deep>-%param = VALUE #(
        companycode                  = '1000'
        documentreferenceid          = ls_header-fdcertificateno
        createdbyuser                = sy-uname
        businesstransactiontype      = 'RFBU'
        accountingdocumenttype       = 'SA'
        documentdate                 = ls_header-documentdate
        postingdate                  = ls_header-postingdate
        accountingdocumentheadertext = ls_header-fdcertificateno
        _glitems                     = VALUE #(
            profitcenter     = ls_header-profitcenter
            documentitemtext = |FD Booked - { ls_header-fdcertificateno }|
            yy1_fdnumber_jei = ls_header-fdcertificateno
            ( glaccountlineitem   = |001|
              glaccount           = ls_header-fdgl
              assignmentreference = ls_header-fdcertificateno
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ls_header-amount * ls_header-exchangerate
                                               currency               = ls_header-currency ) ) )
            ( glaccountlineitem   = |002|
              glaccount           = ls_outgl-glaccount " Comment for Cutover GL
***              glaccount           = '0099800030'
              housebank           = ls_outgl-housebankid
              housebankaccount    = ls_outgl-accountid
              assignmentreference = ls_outgl-bankreference
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ls_header-amount * -1 * ls_header-exchangerate
                                               currency               = ls_header-currency ) ) ) ) ).

    lt_je_val = CORRESPONDING #( lt_je_deep ).
    READ ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE validate FROM lt_je_val
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_check_result)
         FAILED FINAL(ls_failed_deep01)
         REPORTED FINAL(ls_reported_deep01).
    IF ls_failed_deep01 IS NOT INITIAL.

      LOOP AT ls_reported_deep01-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep01>).
        FINAL(lv_result01) = <ls_reported_deep01>-%msg->if_message~get_text( ).
        IF sy-tabix = 1.
          lv_text = lv_result01.
        ELSE.
          lv_text = |{ lv_text } / { lv_result01 }|.
        ENDIF.
      ENDLOOP.

      APPEND VALUE #( %tky                    = ls_header-%tky
                      %state_area             = 'Validate_Head'
                      %msg                    = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                       text     = lv_text )
                      %element-rateofinterest = if_abap_behv=>mk-on )
             TO reported-head.

    ELSE.

      MODIFY ENTITIES OF i_journalentrytp
             PRIVILEGED
             ENTITY journalentry
             EXECUTE post FROM lt_je_deep
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed_deep)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported_deep)
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped_deep).

      ls_header-statuscode = '2'.
      ls_header-statusdesc = 'FD Booked'.

      MODIFY ENTITIES OF zr_fdhead IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS ( statuscode statusdesc )
             WITH VALUE #( ( %tky       = ls_header-%tky
                             statuscode = ls_header-statuscode
                             statusdesc = ls_header-statusdesc ) ).

    ENDIF.
  ENDMETHOD.

  METHOD fdclose.
    DATA lv_cid     TYPE abp_behv_cid.
    DATA lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
    DATA lt_je_val  TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.
    DATA lv_text    TYPE char128.

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_fdhead
         BY \_outgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_outgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_outgl_failed).

    READ ENTITY zr_fdhead
         BY \_incgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_incgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_incgl_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(ls_outgl) = VALUE #( lt_outgl[ 1 ] OPTIONAL ).
    FINAL(ls_incgl) = VALUE #( lt_incgl[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zr_fdhead
      WHERE id = @ls_header-id
      INTO @FINAL(ls_fdhead).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " FD Close Accounting
    IF NOT (     ls_header-statuscode  = '2'
             AND ls_header-postclose  IS NOT INITIAL
             AND ls_fdhead-postclose  IS INITIAL
             AND lines( lt_incgl )     = 1 ).
      RETURN.
    ENDIF.

    CLEAR lv_cid.
    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
    ENDTRY.

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid   = lv_cid.
    <je_deep>-%param = VALUE #(
        companycode                  = '1000'
        documentreferenceid          = ls_header-fdcertificateno
        createdbyuser                = sy-uname
        businesstransactiontype      = 'RFBU'
        accountingdocumenttype       = 'SA'
        documentdate                 = ls_header-closedocumentdate
        postingdate                  = ls_header-closepostingdate
        accountingdocumentheadertext = ls_header-fdcertificateno
        _glitems                     = VALUE #(
            profitcenter     = ls_header-profitcenter
            documentitemtext = |FD Closed - { ls_header-fdcertificateno }|
            yy1_fdnumber_jei = ls_header-fdcertificateno
            ( glaccountlineitem   = |001|
              glaccount           = ls_header-fdgl
              assignmentreference = ls_header-fdcertificateno
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ls_header-amount * -1 * ls_header-exchangerate
                                               currency               = ls_header-currency ) ) )
            ( glaccountlineitem   = |002|
              glaccount           = ls_incgl-glaccount
***              glaccount           = '0099800030' "Cut Over GL
              housebank           = ls_incgl-housebankid
              housebankaccount    = ls_incgl-accountid
              assignmentreference = ls_incgl-bankreference
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ls_header-amount * ls_header-exchangerate
                                               currency               = ls_header-currency ) ) ) ) ).

    lt_je_val = CORRESPONDING #( lt_je_deep ).
    READ ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE validate FROM lt_je_val
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_check_result)
         FAILED FINAL(ls_failed_deep01)
         REPORTED FINAL(ls_reported_deep01).
    IF ls_failed_deep01 IS NOT INITIAL.

      LOOP AT ls_reported_deep01-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep01>).
        FINAL(lv_result01) = <ls_reported_deep01>-%msg->if_message~get_text( ).
        IF sy-tabix = 1.
          lv_text = lv_result01.
        ELSE.
          lv_text = |{ lv_text } / { lv_result01 }|.
        ENDIF.
      ENDLOOP.

      APPEND VALUE #( %tky                    = ls_header-%tky
                      %state_area             = 'Validate_Head'
                      %msg                    = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                       text     = lv_text )
                      %element-rateofinterest = if_abap_behv=>mk-on )
             TO reported-head.

    ELSE.

      MODIFY ENTITIES OF i_journalentrytp
             PRIVILEGED
             ENTITY journalentry
             EXECUTE post FROM lt_je_deep
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed_deep)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported_deep)
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped_deep).

      ls_header-statuscode = '3'.
      ls_header-statusdesc = 'FD Closed'.

      MODIFY ENTITIES OF zr_fdhead IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS ( statuscode statusdesc )
             WITH VALUE #( ( %tky       = ls_header-%tky
                             statuscode = ls_header-statuscode
                             statusdesc = ls_header-statusdesc ) ).

    ENDIF.
  ENDMETHOD.

  METHOD fdchange.
                                                            "12200020
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    IF lt_header IS NOT INITIAL.

      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
      IF ls_header IS NOT INITIAL.
        ls_header-fdgl = '0012200020'.

        MODIFY ENTITIES OF zr_fdhead IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( fdgl )
               WITH VALUE #( ( %tky  = ls_header-%tky
                               fdgl = ls_header-fdgl  ) ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_incgl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR incgl RESULT result.

ENDCLASS.


CLASS lhc_incgl IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY incgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_incgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_incgl_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_incgl IN lt_incgl
                      ( %tky    = ls_incgl-%tky

                        %delete = COND #( WHEN ls_header-postclose = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.
ENDCLASS.


CLASS lhc_outgl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR outgl RESULT result.

ENDCLASS.


CLASS lhc_outgl IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY outgl
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_outgl)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_outgl_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_outgl IN lt_outgl
                      ( %tky    = ls_outgl-%tky

                        %delete = COND #( WHEN ls_header-postfd = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.
ENDCLASS.


CLASS lhc_interest DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR interest RESULT result.

    METHODS fdinterest FOR DETERMINE ON SAVE
      IMPORTING keys FOR interest~fdinterest.

ENDCLASS.


CLASS lhc_interest IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY interest
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_interest)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_interest_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_interest IN lt_interest
                      ( %tky    = ls_interest-%tky

                        %update = COND #( WHEN ls_header-postclose = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )

                        %delete = COND #( WHEN ls_header-postclose = ''
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD fdinterest.
    DATA lv_cid     TYPE abp_behv_cid.
    DATA lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
    DATA lt_je_val  TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.
    DATA lv_text    TYPE char128.

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zr_fdhead IN LOCAL MODE
         ENTITY interest
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_interest)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_interest_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    FINAL(ls_interest) = VALUE #( lt_interest[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zr_fdhead
      WHERE id = @ls_header-id
      " TODO: variable is assigned but never used (ABAP cleaner)
      INTO @FINAL(ls_fdhead).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " FD Close Accounting
    IF NOT (     ls_header-statuscode  = '2'
             AND ls_header-postfd     IS NOT INITIAL
             AND ls_header-postclose  IS INITIAL ).
      RETURN.
    ENDIF.

    CLEAR lv_cid.
    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
    ENDTRY.

    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid   = lv_cid.
    <je_deep>-%param = VALUE #(
        companycode                  = '1000'
        documentreferenceid          = ls_interest-referenceno
        createdbyuser                = sy-uname
        businesstransactiontype      = 'RFBU'
        accountingdocumenttype       = 'SA'
        documentdate                 = ls_header-documentdate
        postingdate                  = ls_header-postingdate
        accountingdocumentheadertext = ls_header-fdcertificateno
        _glitems                     = VALUE #(
            profitcenter     = ls_header-profitcenter
            documentitemtext = |FD Interest - { ls_header-fdcertificateno }|
            yy1_fdnumber_jei = ls_header-fdcertificateno
            ( glaccountlineitem   = |001|
              glaccount           = ls_interest-interestgl
              assignmentreference = ls_header-fdcertificateno
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ( ls_interest-amount + ls_interest-tdsamount ) * ls_header-exchangerate * -1
                                               currency               = ls_header-currency ) ) )
            ( glaccountlineitem   = |002|
              glaccount           = ls_interest-bankgl " Comment for Cutover
***              glaccount           = '0099800030'
              housebank           = ls_interest-housebankid
              housebankaccount    = ls_interest-accountid
              assignmentreference = ls_interest-referenceno
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ( ls_interest-amount ) * ls_header-exchangerate
                                               currency               = ls_header-currency ) ) )

            ( glaccountlineitem   = |003|
              glaccount           = ls_interest-tdsgl
              assignmentreference = ls_interest-referenceno
              _currencyamount     = VALUE #( ( currencyrole           = '00'
                                               journalentryitemamount = ls_interest-tdsamount * ls_header-exchangerate
                                               currency               = ls_header-currency ) ) )
                                               ) ).

    lt_je_val = CORRESPONDING #( lt_je_deep ).
    READ ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE validate FROM lt_je_val
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_check_result)
         FAILED FINAL(ls_failed_deep01)
         REPORTED FINAL(ls_reported_deep01).
    IF ls_failed_deep01 IS NOT INITIAL.

      LOOP AT ls_reported_deep01-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep01>).
        FINAL(lv_result01) = <ls_reported_deep01>-%msg->if_message~get_text( ).
        IF sy-tabix = 1.
          lv_text = lv_result01.
        ELSE.
          lv_text = |{ lv_text } / { lv_result01 }|.
        ENDIF.
      ENDLOOP.

      APPEND VALUE #( %tky                    = ls_header-%tky
                      %state_area             = 'Validate_Head'
                      %msg                    = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                       text     = lv_text )
                      %element-rateofinterest = if_abap_behv=>mk-on )
             TO reported-head.

    ELSE.

      MODIFY ENTITIES OF i_journalentrytp
             PRIVILEGED
             ENTITY journalentry
             EXECUTE post FROM lt_je_deep
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed_deep)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported_deep)
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped_deep).

      ls_header-interestcum += ls_interest-amount.

      MODIFY ENTITIES OF zr_fdhead IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS ( interestcum )
             WITH VALUE #( ( %tky        = ls_header-%tky
                             interestcum = ls_header-interestcum ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
