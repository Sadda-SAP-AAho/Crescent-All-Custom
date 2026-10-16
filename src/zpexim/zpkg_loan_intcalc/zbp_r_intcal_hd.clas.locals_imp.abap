CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS determine_items FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~determine_items.

    METHODS post FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~post.

    METHODS uniqueid FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~uniqueid.

ENDCLASS.


CLASS lhc_head IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).
    IF header IS INITIAL.
      RETURN.
    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).
    SELECT SINGLE * FROM zr_intcal_hd WHERE id = @ls_header-id INTO @FINAL(ls_zr_intcal_hd).

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    result = VALUE #( FOR ls_header_t IN header
                      ( %tky                = ls_header_t-%tky

                        %field-post         = COND #( WHEN ls_zr_intcal_hd-status = 1
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-exchangerate = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %delete             = COND #( WHEN lv_user = 'CB9980000020'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      WHEN ls_header_t-post IS NOT INITIAL
                                                      THEN if_abap_behv=>fc-o-disabled
                                                      ELSE
                                                      if_abap_behv=>fc-o-enabled )

                        %field-bankgl       = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-interestgl   = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-costcenter   = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-penalty      = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-penaltyfc    = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-housebankid  = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %field-accountid    = COND #( WHEN ls_header_t-post IS INITIAL
                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                      ELSE if_abap_behv=>fc-f-read_only )

                        %assoc-_item        = if_abap_behv=>fc-o-disabled ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determine_items.
    DATA lv_enddate         TYPE budat.
    DATA lv_startdate       TYPE budat.
    DATA lv_duedate         TYPE begda.
    DATA lv_days            TYPE i.
    DATA lv_rate            TYPE dmbtr.
    DATA lv_calcinterest    TYPE dmbtr.
    DATA lv_adjsinterest    TYPE dmbtr.
    DATA lv_totlinterestinr TYPE dmbtr.
    DATA lv_totlinterest    TYPE dmbtr.
    DATA lv_daysyear    TYPE i.
    DATA lv_item            TYPE zr_intcal_it-item.
    DATA lv_dateinst TYPE datum.
    DATA lv_balance TYPE dmbtr.
    DATA lv_totalinterestonthatmonth TYPE dmbtr.
    DATA lv_totalinterestonthatmnoninr TYPE dmbtr.
    DATA lv_totalamountonthatmonth TYPE dmbtr.
    DATA lv_lastmonthbalanceamount TYPE dmbtr.
    DATA lv_postablebalance TYPE dmbtr.

    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).
    IF header IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL OR ls_header-status <> ''.
      RETURN.
    ENDIF.

    lv_enddate = ls_header-enddate.
    lv_startdate = ls_header-startdate.

    SELECT * FROM zi_pcrhdr
      WHERE loanacno = @ls_header-loanacno
        AND duedt    >= @lv_startdate
        AND duedt    <= @lv_enddate
        AND bankname  = @ls_header-bankname
        AND waers     = @ls_header-currency
        AND accpost  IS NOT INITIAL
      APPENDING TABLE @DATA(lt_pcrhdr).

    SELECT * FROM zi_pcrhdr
      WHERE loanacno = @ls_header-loanacno
        AND extduedt >= @lv_startdate
        AND extduedt <= @lv_enddate
        AND bankname  = @ls_header-bankname
        AND waers     = @ls_header-currency
        AND accpost  IS NOT INITIAL
      APPENDING TABLE @lt_pcrhdr.

    SELECT * FROM zi_pcrhdr
      WHERE loanacno = @ls_header-loanacno
        AND bookingdt <= @lv_enddate
        AND duedt     >= @lv_enddate
        AND bankname   = @ls_header-bankname
        AND waers      = @ls_header-currency
        AND accpost   IS NOT INITIAL
      APPENDING TABLE @lt_pcrhdr.

    SELECT * FROM zi_pcrhdr
      WHERE loanacno = @ls_header-loanacno
        AND bookingdt <= @lv_enddate
        AND extduedt  >= @lv_enddate
        AND bankname   = @ls_header-bankname
        AND waers      = @ls_header-currency
        AND accpost   IS NOT INITIAL
      APPENDING TABLE @lt_pcrhdr.

    SORT lt_pcrhdr BY id.
    DELETE ADJACENT DUPLICATES FROM lt_pcrhdr COMPARING id.
    IF lt_pcrhdr IS NOT INITIAL.
      SORT lt_pcrhdr BY loanacno.

      SELECT * FROM zi_pcritm1
        FOR ALL ENTRIES IN @lt_pcrhdr
        WHERE id           = @lt_pcrhdr-id
          AND validfromdt >= @lv_startdate
          AND validtodt   <= @lv_enddate
        INTO TABLE @DATA(lt_pcritm1).
      IF sy-subrc = 0.
        SORT lt_pcritm1 BY id.
      ENDIF.

      SELECT * FROM zi_pcritm
        FOR ALL ENTRIES IN @lt_pcrhdr
        WHERE id          = @lt_pcrhdr-id
          AND instructdt >= @lv_startdate
          AND instructdt <= @lv_enddate
        INTO TABLE @DATA(lt_pcritm).
      IF sy-subrc = 0.
        SORT lt_pcritm BY id.
      ENDIF.
    ENDIF.

    " Get Previous record
    IF lt_pcrhdr IS NOT INITIAL.
      SELECT * FROM zr_intcal_it
        FOR ALL ENTRIES IN @lt_pcrhdr
        WHERE loanacno = @lt_pcrhdr-loanacno
        INTO TABLE @DATA(lt_intcat_it).
      IF sy-subrc = 0.
        SORT lt_intcat_it BY loanacno newduedt DESCENDING.

        SELECT * FROM zr_intcal_hd
          FOR ALL ENTRIES IN @lt_intcat_it
          WHERE id = @lt_intcat_it-id
          INTO TABLE @DATA(lt_intcat_hd).
        IF sy-subrc = 0.
          SORT lt_intcat_hd BY id enddate DESCENDING.
        ENDIF.
      ENDIF.
    ENDIF.

    LOOP AT lt_pcrhdr INTO DATA(ls_pcrhdr).

      CLEAR: lv_rate.
      IF ls_pcrhdr-benchmarktype = 'EURO' OR ls_pcrhdr-benchmarktype = 'SOFR'.
        DATA(ls_pcritm1) = VALUE #( lt_pcritm1[ id = ls_pcrhdr-id ] OPTIONAL ).
        IF ls_pcritm1 IS INITIAL.
          lv_rate = ls_pcrhdr-benchintrate + ls_pcrhdr-intratesp.
        ELSE.
          lv_rate = ls_pcritm1-sofr + ls_pcrhdr-intratesp.
        ENDIF.
      ELSE.
        lv_rate = ls_pcrhdr-benchintrate + ls_pcrhdr-intratesp.
      ENDIF.
      CLEAR: ls_pcritm1.

      IF ls_header-currency = 'INR'.
        lv_daysyear = 365.
      ELSE.
        lv_daysyear = 360.
      ENDIF.

      IF ls_header-fullcalc IS NOT INITIAL.

        CLEAR: lv_totalinterestonthatmonth,
               lv_totalamountonthatmonth.
        LOOP AT lt_pcritm INTO DATA(ls_pcritm_1) WHERE id = ls_pcrhdr-id.

          lv_dateinst = ls_pcritm_1-instructdt+0(6) && |01|.
          IF ls_pcrhdr-bookingdt > lv_dateinst.
            lv_dateinst = ls_pcrhdr-bookingdt.
          ENDIF.
          lv_days = ls_pcritm_1-instructdt -  lv_dateinst.
          lv_days = lv_days + 1.

          DATA(ls_intcat_it) = VALUE #( lt_intcat_it[   loanacno = ls_pcrhdr-loanacno
                                                        invno = ls_pcritm_1-invno
                                                        invdt = ls_pcritm_1-invdt
                                                   ] OPTIONAL ).
          IF ls_intcat_it IS  INITIAL.

            lv_calcinterest = lv_totlinterestinr = ( ls_pcritm_1-adjamt * ls_header-exchangerate * lv_rate * ( lv_days / lv_daysyear ) ) / 100.
            lv_totlinterest = ( ls_pcritm_1-adjamt * lv_rate * ( lv_days / lv_daysyear ) ) / 100.

            lv_totalamountonthatmonth = lv_totalamountonthatmonth + ls_pcritm_1-adjamt."New

            TRY.
                lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
              CATCH cx_uuid_error.
            ENDTRY.

            MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
                   ENTITY head
                   CREATE BY \_item
                   FROM VALUE #(
                       ( id      = ls_header-id
                         %target = VALUE #( ( %cid                         = lv_item

                                              item                         = lv_item
                                              loanacno                     = ls_pcrhdr-loanacno
                                              bookingdt                    = ls_pcrhdr-bookingdt
                                              bankname                     = ls_pcrhdr-bankname
                                              currency                     = ls_header-currency
                                              loantype                     = ls_pcrhdr-loantype
                                              duedt                        = ls_pcritm_1-instructdt
                                              newduedt                     = ls_pcritm_1-instructdt
                                              zdays                        = lv_days
                                              bookamt                      = ls_pcrhdr-bookamt
                                              balanceamt                   = ls_pcritm_1-adjamt
                                              amount                       = ls_pcritm_1-adjamt
                                              intratesp                    = ls_pcrhdr-intratesp
                                              benchintrate                 = ls_pcrhdr-benchintrate
                                              benchmarktype                = ls_pcrhdr-benchmarktype
                                              sofr                         = COND #( WHEN ls_pcrhdr-benchmarktype = 'EURO'
                                                                                       OR ls_pcrhdr-benchmarktype = 'SOFR'
                                                                                     THEN ls_pcritm1-sofr
                                                                                     ELSE ls_pcrhdr-benchintrate  )
                                              effectiveintrate             = lv_rate
                                              calcinterest                 = lv_totlinterest
                                              postableinterest             = lv_totlinterest
                                              postableinterestinr          = lv_totlinterestinr
                                              fullcalc                     = ls_header-fullcalc
                                              invno                        = ls_pcritm_1-invno
                                              invdt                        = ls_pcritm_1-invdt

                                              %control-item                = if_abap_behv=>mk-on
                                              %control-loanacno            = if_abap_behv=>mk-on
                                              %control-bookingdt           = if_abap_behv=>mk-on
                                              %control-bankname            = if_abap_behv=>mk-on
                                              %control-currency            = if_abap_behv=>mk-on
                                              %control-loantype            = if_abap_behv=>mk-on
                                              %control-duedt               = if_abap_behv=>mk-on
                                              %control-newduedt            = if_abap_behv=>mk-on
                                              %control-zdays               = if_abap_behv=>mk-on
                                              %control-bookamt             = if_abap_behv=>mk-on
                                              %control-balanceamt          = if_abap_behv=>mk-on
                                              %control-amount              = if_abap_behv=>mk-on
                                              %control-intratesp           = if_abap_behv=>mk-on
                                              %control-benchintrate        = if_abap_behv=>mk-on
                                              %control-benchmarktype       = if_abap_behv=>mk-on
                                              %control-sofr                = if_abap_behv=>mk-on
                                              %control-effectiveintrate    = if_abap_behv=>mk-on
                                              %control-calcinterest        = if_abap_behv=>mk-on
                                              %control-fullcalc            = if_abap_behv=>mk-on
                                              %control-invno               = if_abap_behv=>mk-on
                                              %control-invdt               = if_abap_behv=>mk-on
                                              %control-postableinterest    = if_abap_behv=>mk-on
                                              %control-postableinterestinr = if_abap_behv=>mk-on ) ) ) )
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   MAPPED FINAL(ls_mapped1)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED FINAL(ls_failed1)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   REPORTED FINAL(ls_reported1).

          ENDIF.

        ENDLOOP.

        "Postable Interest
        LOOP AT lt_intcat_it INTO DATA(ls_intcal_it_1) WHERE newduedt GE ls_header-startdate AND newduedt LE ls_header-enddate.
          lv_totalinterestonthatmonth = lv_totalinterestonthatmonth + ls_intcal_it_1-postableinterestinr.
          lv_totalinterestonthatmnoninr = lv_totalinterestonthatmnoninr + ls_intcal_it_1-calcinterest.
          lv_totalamountonthatmonth = lv_totalamountonthatmonth + ls_intcal_it_1-amount.
        ENDLOOP.

        CLEAR: lv_lastmonthbalanceamount.
        DATA(ls_intcat_hd) = VALUE #( lt_intcat_it[ fullcalc = 'X' ] OPTIONAL ).
        IF ls_intcat_hd IS NOT INITIAL.
          "Closure done on previous month.
          SORT lt_intcat_it BY duedt DESCENDING.
          LOOP AT lt_intcat_it INTO ls_intcal_it_1 WHERE fullcalc = 'X'.
            lv_lastmonthbalanceamount = lv_lastmonthbalanceamount + ls_intcal_it_1-balanceamt.
            EXIT.
          ENDLOOP.
        ELSE.
          lv_lastmonthbalanceamount = ls_pcrhdr-bookamt.
        ENDIF.

        lv_postablebalance = lv_lastmonthbalanceamount - lv_totalamountonthatmonth.

        lv_dateinst = ls_header-enddate+0(6) && |01|.
        IF ls_pcrhdr-bookingdt > lv_dateinst.
          lv_dateinst = ls_pcrhdr-bookingdt.
        ENDIF.
        IF ls_pcrhdr-extduedt IS NOT INITIAL AND ls_pcrhdr-extduedt <= ls_header-enddate.
          lv_days = ls_pcrhdr-extduedt - lv_dateinst.
        ELSE.
          IF ls_pcrhdr-duedt IS NOT INITIAL AND ls_pcrhdr-extduedt <= ls_header-enddate.
            lv_days = ls_pcrhdr-duedt - lv_dateinst.
          ELSE.
            lv_days = ls_header-enddate - lv_dateinst.
          ENDIF.
        ENDIF.

        IF lv_days > 0.
          lv_days = lv_days + 1.

          lv_calcinterest = lv_totlinterestinr = ( lv_postablebalance * ls_header-exchangerate * lv_rate * ( lv_days / lv_daysyear ) ) / 100.
          lv_totlinterest = ( lv_postablebalance * lv_rate * ( lv_days / lv_daysyear ) ) / 100.


          lv_totlinterest = lv_totlinterest." + lv_totalinterestonthatmnoninr.
          lv_totlinterestinr = lv_totlinterestinr." + lv_totalinterestonthatmonth.

          TRY.
              lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.

          MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
                 ENTITY head
                 CREATE BY \_item
                 FROM VALUE #(
                     ( id      = ls_header-id
                       %target = VALUE #( ( %cid                         = lv_item

                                            item                         = lv_item
                                            loanacno                     = ls_pcrhdr-loanacno
                                            bookingdt                    = ls_pcrhdr-bookingdt
                                            bankname                     = ls_pcrhdr-bankname
                                            currency                     = ls_header-currency
                                            loantype                     = ls_pcrhdr-loantype
                                            duedt                        = ls_header-enddate
                                            newduedt                     = ls_header-enddate
                                            zdays                        = lv_days
                                            bookamt                      = ls_pcrhdr-bookamt
                                            balanceamt                   = lv_postablebalance
                                            amount                       = lv_postablebalance
                                            intratesp                    = ls_pcrhdr-intratesp
                                            benchintrate                 = ls_pcrhdr-benchintrate
                                            benchmarktype                = ls_pcrhdr-benchmarktype
                                            sofr                         = COND #( WHEN ls_pcrhdr-benchmarktype = 'EURO'
                                                                                     OR ls_pcrhdr-benchmarktype = 'SOFR'
                                                                                   THEN ls_pcritm1-sofr
                                                                                   ELSE ls_pcrhdr-benchintrate  )
                                            effectiveintrate             = lv_rate
                                            calcinterest                 = lv_totlinterest
                                            postableinterest             = lv_totlinterest
                                            postableinterestinr          = lv_totlinterestinr
                                            fullcalc                     = ls_header-fullcalc

                                            %control-item                = if_abap_behv=>mk-on
                                            %control-loanacno            = if_abap_behv=>mk-on
                                            %control-bookingdt           = if_abap_behv=>mk-on
                                            %control-bankname            = if_abap_behv=>mk-on
                                            %control-currency            = if_abap_behv=>mk-on
                                            %control-loantype            = if_abap_behv=>mk-on
                                            %control-duedt               = if_abap_behv=>mk-on
                                            %control-newduedt            = if_abap_behv=>mk-on
                                            %control-zdays               = if_abap_behv=>mk-on
                                            %control-bookamt             = if_abap_behv=>mk-on
                                            %control-balanceamt          = if_abap_behv=>mk-on
                                            %control-amount              = if_abap_behv=>mk-on
                                            %control-intratesp           = if_abap_behv=>mk-on
                                            %control-benchintrate        = if_abap_behv=>mk-on
                                            %control-benchmarktype       = if_abap_behv=>mk-on
                                            %control-sofr                = if_abap_behv=>mk-on
                                            %control-effectiveintrate    = if_abap_behv=>mk-on
                                            %control-calcinterest        = if_abap_behv=>mk-on
                                            %control-postableinterest    = if_abap_behv=>mk-on
                                            %control-fullcalc            = if_abap_behv=>mk-on
                                            %control-postableinterestinr = if_abap_behv=>mk-on ) ) ) )
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 MAPPED FINAL(ls_mapped)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(ls_failed)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 REPORTED FINAL(ls_reported).
        ENDIF.

      ELSE.

        LOOP AT lt_pcritm INTO DATA(ls_pcritm) WHERE id = ls_pcrhdr-id.

          lv_dateinst = ls_pcritm-instructdt+0(6) && |01|.
          IF ls_pcrhdr-bookingdt > lv_dateinst.
            lv_dateinst = ls_pcrhdr-bookingdt.
          ENDIF.
          lv_days = ls_pcritm-instructdt -  lv_dateinst.
          lv_days = lv_days + 1.

          DATA(ls_intcat_it_1) = VALUE #( lt_intcat_it[   loanacno = ls_pcrhdr-loanacno
                                                        invno = ls_pcritm-invno
                                                        invdt = ls_pcritm-invdt
                                                   ] OPTIONAL ).
          IF ls_intcat_it_1 IS  INITIAL.

            lv_calcinterest = lv_totlinterestinr = ( ls_pcritm-adjamt * ls_header-exchangerate * lv_rate * ( lv_days / lv_daysyear ) ) / 100.
            lv_totlinterest = ( ls_pcritm-adjamt * lv_rate * ( lv_days / lv_daysyear ) ) / 100.

            TRY.
                lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
              CATCH cx_uuid_error.
            ENDTRY.

            MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
                   ENTITY head
                   CREATE BY \_item
                   FROM VALUE #(
                       ( id      = ls_header-id
                         %target = VALUE #( ( %cid                         = lv_item

                                              item                         = lv_item
                                              loanacno                     = ls_pcrhdr-loanacno
                                              bookingdt                    = ls_pcrhdr-bookingdt
                                              bankname                     = ls_pcrhdr-bankname
                                              currency                     = ls_header-currency
                                              loantype                     = ls_pcrhdr-loantype
                                              duedt                        = ls_pcritm-instructdt
                                              newduedt                     = ls_pcritm-instructdt
                                              zdays                        = lv_days
                                              bookamt                      = ls_pcrhdr-bookamt
                                              balanceamt                   = ls_pcritm-adjamt
                                              amount                       = ls_pcritm-adjamt
                                              intratesp                    = ls_pcrhdr-intratesp
                                              benchintrate                 = ls_pcrhdr-benchintrate
                                              benchmarktype                = ls_pcrhdr-benchmarktype
                                              sofr                         = COND #( WHEN ls_pcrhdr-benchmarktype = 'EURO'
                                                                                       OR ls_pcrhdr-benchmarktype = 'SOFR'
                                                                                     THEN ls_pcritm1-sofr
                                                                                     ELSE ls_pcrhdr-benchintrate  )
                                              effectiveintrate             = lv_rate
                                              calcinterest                 = lv_totlinterest
                                              postableinterest             = lv_totlinterest
                                              postableinterestinr          = lv_totlinterestinr
                                              fullcalc                     = ls_header-fullcalc
                                              invno                        = ls_pcritm-invno
                                              invdt                        = ls_pcritm-invdt

                                              %control-item                = if_abap_behv=>mk-on
                                              %control-loanacno            = if_abap_behv=>mk-on
                                              %control-bookingdt           = if_abap_behv=>mk-on
                                              %control-bankname            = if_abap_behv=>mk-on
                                              %control-currency            = if_abap_behv=>mk-on
                                              %control-loantype            = if_abap_behv=>mk-on
                                              %control-duedt               = if_abap_behv=>mk-on
                                              %control-newduedt            = if_abap_behv=>mk-on
                                              %control-zdays               = if_abap_behv=>mk-on
                                              %control-bookamt             = if_abap_behv=>mk-on
                                              %control-balanceamt          = if_abap_behv=>mk-on
                                              %control-amount              = if_abap_behv=>mk-on
                                              %control-intratesp           = if_abap_behv=>mk-on
                                              %control-benchintrate        = if_abap_behv=>mk-on
                                              %control-benchmarktype       = if_abap_behv=>mk-on
                                              %control-sofr                = if_abap_behv=>mk-on
                                              %control-effectiveintrate    = if_abap_behv=>mk-on
                                              %control-calcinterest        = if_abap_behv=>mk-on
                                              %control-fullcalc            = if_abap_behv=>mk-on
                                              %control-invno               = if_abap_behv=>mk-on
                                              %control-invdt               = if_abap_behv=>mk-on
                                              %control-postableinterest    = if_abap_behv=>mk-on
                                              %control-postableinterestinr = if_abap_behv=>mk-on ) ) ) )
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   MAPPED FINAL(ls_mapped2)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED FINAL(ls_failed2)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   REPORTED FINAL(ls_reported2).

          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDLOOP.

    ls_header-status     = '1'.
    ls_header-statusdesc = 'Created'.

    MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
           ENTITY head
           UPDATE
           FIELDS ( status statusdesc local_created_at local_created_by nameid )
           WITH VALUE #( ( %tky             = ls_header-%tky
                           status           = ls_header-status
                           statusdesc       = ls_header-statusdesc
                           nameid           = ls_header-headertext && |-| &&
                                              cl_abap_context_info=>get_system_date(  ) && |-| &&
                                              cl_abap_context_info=>get_system_time(  )
                           local_created_at = cl_abap_context_info=>get_system_date( )
                           local_created_by = cl_abap_context_info=>get_user_technical_name( ) ) ).
  ENDMETHOD.

  METHOD post.
    DATA lv_cid     TYPE abp_behv_cid.
    DATA lv_amount  TYPE dmbtr.
    DATA lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
    DATA lt_je_val  TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.
    DATA lv_text    TYPE char128.

    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zr_intcal_hd
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    CLEAR lv_cid.
    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
    ENDTRY.

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    lv_amount = REDUCE dmbtr( INIT lv_value TYPE dmbtr
                              FOR ls_item IN lt_item
                              NEXT lv_value = lv_value + ls_item-postableinterestinr ).

    lv_amount = lv_amount + ls_header-penalty.


    IF lv_amount <= 0.
      APPEND VALUE #( %tky            = ls_header-%tky
                      %state_area     = 'Validate_Head'
                      %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = 'Posting not Possible' )
                      %element-nameid = if_abap_behv=>mk-on )
             TO reported-head.

      ls_header-status     = '2'.
      ls_header-statusdesc = 'Booked without Accounting'.

      MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
             ENTITY head
             UPDATE
             FIELDS ( status statusdesc )
             WITH VALUE #( ( %tky       = ls_header-%tky
                             status     = ls_header-status
                             statusdesc = ls_header-statusdesc ) ).

    ELSE.
      APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
      <je_deep>-%cid   = lv_cid.
      <je_deep>-%param = VALUE #( companycode                  = '1000'
                                  documentreferenceid          = ls_header-headertext
                                  createdbyuser                = sy-uname
                                  businesstransactiontype      = 'RFBU'
                                  accountingdocumenttype       = 'SA'
                                  documentdate                 = ls_header-documentdate
                                  postingdate                  = ls_header-postingdate
                                  accountingdocumentheadertext = ls_header-headertext
                                  _glitems                     = VALUE #(
                                      costcenter          = ls_header-costcenter
                                      documentitemtext    = |Interest Calc - { ls_header-headertext }|
                                      yy1_fdnumber_jei    = ls_header-nameid
                                      assignmentreference = ls_header-headertext
                                      ( glaccountlineitem = |001|
                                        glaccount         = ls_header-interestgl
                                        _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                       journalentryitemamount = lv_amount
                                                                       currency               = 'INR' ) ) )
                                      ( glaccountlineitem = |002|
                                        glaccount         = ls_header-bankgl
                                        housebank         = ls_header-housebankid
                                        housebankaccount  = ls_header-accountid
                                        _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                       journalentryitemamount = lv_amount * -1
                                                                       currency               = 'INR' ) ) ) ) ).

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

        APPEND VALUE #( %tky                = ls_header-%tky
                        %state_area         = 'Validate_Head'
                        %msg                = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     = lv_text )
                        %element-headertext = if_abap_behv=>mk-on )
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

        ls_header-status     = '2'.
        ls_header-statusdesc = 'Booked with Accounting'.

        MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
               ENTITY head
               UPDATE
               FIELDS ( status statusdesc )
               WITH VALUE #( ( %tky       = ls_header-%tky
                               status     = ls_header-status
                               statusdesc = ls_header-statusdesc ) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD uniqueid.
    DATA lv_amount        TYPE dmbtr.
    DATA lv_enddate       TYPE budat.
    DATA lv_startdate     TYPE budat.
    DATA lv_prevyear      TYPE gjahr.
    DATA lv_prevmont      TYPE monat.
    DATA lv_enddateprev   TYPE budat.
    DATA lv_startdateprev TYPE budat.

    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).
    IF header IS INITIAL.
      RETURN.
    ENDIF.

    READ ENTITY zr_intcal_hd
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zr_intcal_hd WHERE id = @ls_header-id INTO @FINAL(ls_zr_intcal_hd).
    IF lt_item IS NOT INITIAL AND ls_zr_intcal_hd IS NOT INITIAL.
      lv_amount = REDUCE dmbtr( INIT lv_value TYPE dmbtr
                                FOR ls_item IN lt_item
                                NEXT lv_value = lv_value + ls_item-postableinterest ).
      IF lv_amount <= 0.
        APPEND VALUE #( %tky            = ls_header-%tky
                        %state_area     = 'Validate_Head'
                        %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = 'Posting not Possible with 0 value' )
                        %element-nameid = if_abap_behv=>mk-on )
               TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky )
               TO failed-head.
      ENDIF.
    ENDIF.

    IF ls_header-nameid IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_intcal_hd
        WHERE id     <> @ls_header-id
          AND nameid  = @ls_header-nameid
        INTO @FINAL(ls_intcal).
      IF ls_intcal IS NOT INITIAL.
        APPEND VALUE #( %tky            = ls_header-%tky
                        %state_area     = 'Validate_Head'
                        %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = 'Please provide a unique ID' )
                        %element-nameid = if_abap_behv=>mk-on )
               TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky )
               TO failed-head.
      ENDIF.
    ELSE.
      APPEND VALUE #( %tky            = ls_header-%tky
                      %state_area     = 'Validate_Head'
                      %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = 'Please provide a unique ID' )
                      %element-nameid = if_abap_behv=>mk-on )
             TO reported-head.

      APPEND VALUE #( %tky = ls_header-%tky )
             TO failed-head.
    ENDIF.

    SELECT SINGLE * FROM i_calendardate
      WHERE calendaryear  = @ls_header-tyear
        AND calendarmonth = @ls_header-tmonth
      INTO @DATA(ls_calendardate).
    lv_enddate = ls_calendardate-lastdayofmonthdate.
    lv_startdate = ls_calendardate-firstdayofmonthdate.
    CLEAR ls_calendardate.

    SELECT * FROM zi_pcrhdr
      WHERE duedt     >= @lv_startdate
        AND bookingdt <= @lv_enddate
        AND bankname   = @ls_header-bankname
      INTO TABLE @FINAL(lt_pcrhdr).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    IF ls_header-tmonth = '01'.
      lv_prevyear = ls_header-tyear - 1.
      lv_prevmont = '12'.
    ELSE.
      lv_prevyear = ls_header-tyear - 1.
      lv_prevmont = ls_header-tmonth - 1.
    ENDIF.

    SELECT SINGLE * FROM i_calendardate
      WHERE calendaryear  = @lv_prevyear
        AND calendarmonth = @lv_prevmont
      INTO @ls_calendardate.
    lv_enddateprev = ls_calendardate-lastdayofmonthdate.
    lv_startdateprev = ls_calendardate-firstdayofmonthdate.
    CLEAR ls_calendardate.

    LOOP AT lt_pcrhdr INTO FINAL(ls_pcrhdr).

      IF ls_pcrhdr-currency <> 'INR' AND ls_pcrhdr-exchangerate IS INITIAL.
        APPEND VALUE #( %tky            = ls_header-%tky
                        %state_area     = 'Validate_Head'
                        %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = 'Please provide exchange rate' )
                        %element-nameid = if_abap_behv=>mk-on )
               TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky )
               TO failed-head.
      ENDIF.

      SELECT * FROM zi_pcrhdr
        FOR ALL ENTRIES IN @lt_pcrhdr
        WHERE id         = @lt_pcrhdr-id
          AND duedt     >= @lv_startdateprev
          AND bookingdt <= @lv_enddateprev
          AND bankname   = @ls_header-bankname
        INTO TABLE @FINAL(lt_pcrhdr_prev).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      SELECT * FROM zdt_intcal_hd
        FOR ALL ENTRIES IN @lt_pcrhdr_prev
        WHERE tyear    = @lv_prevyear
          AND tmonth   = @lv_prevmont
          AND bankname = @lt_pcrhdr_prev-bankname
        INTO TABLE @FINAL(lt_intcal_prev).
      IF sy-subrc <> 0.
        APPEND VALUE #(
            %tky            = ls_header-%tky
            %state_area     = 'Validate_Head'
            %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                     text     = 'Please book Interest of the Previous Period' )
            %element-nameid = if_abap_behv=>mk-on )
               TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky )
               TO failed-head.
      ELSE.
        LOOP AT lt_pcrhdr_prev INTO FINAL(ls_pcrhdr_prev).
          FINAL(ls_intcal_prev) = VALUE #( lt_intcal_prev[ bankname = ls_pcrhdr_prev-bankname ] OPTIONAL ).
          IF ls_intcal_prev IS NOT INITIAL.
            CONTINUE.
          ENDIF.

          APPEND VALUE #(
              %tky            = ls_header-%tky
              %state_area     = 'Validate_Head'
              %msg            = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'Please book Interest of the Previous Period' )
              %element-nameid = if_abap_behv=>mk-on )
                 TO reported-head.

          APPEND VALUE #( %tky = ls_header-%tky )
                 TO failed-head.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.

    METHODS determine_item FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~determine_item.

ENDCLASS.


CLASS lhc_item IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).

    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).
    IF header IS NOT INITIAL.
      FINAL(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).

      DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

      result = VALUE #( FOR ls_item_t IN item
                        ( %tky    = ls_item_t-%tky

                          %update = COND #( WHEN ls_header-post IS NOT INITIAL
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled )

                          %delete = COND #( WHEN lv_user = 'CB9980000020'
                                            THEN if_abap_behv=>fc-o-enabled
                                            WHEN ls_header-post IS NOT INITIAL
                                            THEN if_abap_behv=>fc-o-disabled
                                            ELSE if_abap_behv=>fc-o-enabled )
                                            ) ).

    ENDIF.
  ENDMETHOD.

  METHOD determine_item.
    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    READ ENTITIES OF zr_intcal_hd IN LOCAL MODE
         ENTITY item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).

    IF header IS NOT INITIAL.
      FINAL(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).

      LOOP AT item INTO FINAL(ls_item).

        MODIFY ENTITIES OF zr_intcal_hd IN LOCAL MODE
               ENTITY item
               UPDATE
               FIELDS ( postableinterest )
               WITH VALUE #( ( %tky             = ls_item-%tky
                               postableinterest = ls_item-postableinterestinr / ls_header-exchangerate ) ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
