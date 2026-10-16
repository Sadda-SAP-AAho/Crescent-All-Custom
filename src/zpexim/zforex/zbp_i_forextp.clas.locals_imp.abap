CLASS lhc_zi_forextp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_forextp RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_forextp RESULT result.
    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_forextp~headerdetails.
    METHODS checkhed FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_forextp~checkhed.
    METHODS checkdoc FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_forextp~checkdoc.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_forextp~upd RESULT result.

ENDCLASS.

CLASS lhc_zi_forextp IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD headerdetails.
    READ ENTITIES OF zi_forextp IN LOCAL MODE
        ENTITY zi_forextp
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header)
        FAILED DATA(lt_header_failed).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

      MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
            ENTITY zi_forextp
            UPDATE
                FIELDS ( exchagecurr )
                WITH VALUE #(
                               ( %tky   = <lfs_header>-%tky
                                 exchagecurr    = 'INR'
                                  %control-exchagecurr = if_abap_behv=>mk-on
                               ) ).

    ENDLOOP.
*//----------------------------------------------------------------------------//

    DATA: ls_sum TYPE dmbtr,
          lv_amt TYPE dmbtr.
    CLEAR : ls_sum,lv_amt.

    READ ENTITY zi_forextp
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(it1).

    LOOP AT it1 INTO DATA(ls_it1).
      lv_amt = lv_amt + ls_it1-adjustval + ls_it1-otheramt.
    ENDLOOP.


    ls_sum = lv_amt.
    <lfs_header>-balanceval = <lfs_header>-contamt - ls_sum. "ls_item-appl_amt_lc.

    MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
            ENTITY zi_forextp
            UPDATE
                FIELDS ( balanceval  )
                WITH VALUE #( ( %tky   = <lfs_header>-%tky
                                 balanceval = <lfs_header>-balanceval
                                 %control-balanceval  = if_abap_behv=>mk-on
                               ) ).
  ENDMETHOD.

  METHOD checkhed.
    READ ENTITIES OF zi_forextp IN LOCAL MODE
                 ENTITY zi_forextp
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header1).

    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).



    IF gfs_header1-balanceval < 0.
      DATA(lv_msg3) = |Balance Amount Can't Be Negative|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg3 ) )
      TO reported-zi_forextp.
    ENDIF.
    IF gfs_header1-bankname IS INITIAL.
      DATA(lv_msg4) = |Bank Name Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg4 ) )
      TO reported-zi_forextp.
    ENDIF.
    IF gfs_header1-waers IS INITIAL.
      DATA(lv_msg5) = |Currency Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg5 ) )
      TO reported-zi_forextp.
    ENDIF.

    IF gfs_header1-bookdate IS INITIAL.
      DATA(lv_msg7) = |Booking Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg7 ) )
      TO reported-zi_forextp.
    ENDIF.

    IF gfs_header1-contamt IS INITIAL.
      DATA(lv_msg8) = |Contract Booking Amount Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg8 ) )
      TO reported-zi_forextp.
    ENDIF.

    IF gfs_header1-exchangerate IS INITIAL.
      DATA(lv_msg10) = |Exchange Rate Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg10 ) )
      TO reported-zi_forextp.
    ENDIF.


    IF gfs_header1-contractdate IS INITIAL.
      DATA(lv_msg12) = |Contract Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg12 ) )
      TO reported-zi_forextp.
    ENDIF.

    IF gfs_header1-maturitydate IS INITIAL.
      DATA(lv_msg13) = |Maturity Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg13 ) )
      TO reported-zi_forextp.
    ENDIF.



  ENDMETHOD.

  METHOD checkdoc.

    READ ENTITIES OF zi_forextp IN LOCAL MODE
                 ENTITY zi_forextp
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header1).

    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).


    IF gfs_header1-contnoext IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_forex_hdr
      WHERE contnoext = @gfs_header1-contnoext
      INTO @DATA(ls_del1).
      IF ls_del1 IS NOT INITIAL.

        DATA(lv_msg) = |Document Already Exists|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_forextp.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_forextp.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD upd.
    DATA: ls_sum TYPE dmbtr,
          lv_amt TYPE dmbtr.
    CLEAR : ls_sum,lv_amt.

    READ ENTITIES OF zi_forextp IN LOCAL MODE
          ENTITY zi_forextp
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_header)
          FAILED DATA(lt_header_failed).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_forextp
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(it1).

    LOOP AT it1 INTO DATA(ls_it1).
      lv_amt = lv_amt + ls_it1-adjustval + ls_it1-otheramt.
    ENDLOOP.


    ls_sum = lv_amt.
    gfs_header-balanceval = gfs_header-contamt - ls_sum. "ls_item-appl_amt_lc.

    MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
            ENTITY zi_forextp
            UPDATE FIELDS ( balanceval  )
            WITH VALUE #( ( %tky                  = gfs_header-%tky
                             balanceval           = gfs_header-balanceval
                             %control-balanceval  = if_abap_behv=>mk-on
                        ) ).

   READ ENTITIES OF zi_forextp IN LOCAL MODE
            ENTITY zi_forextp
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header_upd).

    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_forextpitm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_forextpitm RESULT result.
    METHODS item_detail FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_forextpitm~item_detail.
    METHODS adjustamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_forextpitm~adjustamt.
    METHODS adjusthedamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_forextpitm~adjusthedamt.
    METHODS checkdetails FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_forextpitm~checkdetails.

ENDCLASS.

CLASS lhc_zi_forextpitm IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_forextp IN LOCAL MODE
           ENTITY zi_forextp
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).



    IF header IS INITIAL.
      RETURN.
    ENDIF.

    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).
    READ ENTITIES OF zi_forextp IN LOCAL MODE
         ENTITY zi_forextpitm
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(fg)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed).


    result = VALUE #(
        FOR gs_item IN fg
        ( %tky               = gs_item-%tky
         %field-loanaccno     = COND #( WHEN gs_item-adjustdoctype = 'LOAN'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
        %field-salesorder     = COND #( WHEN gs_item-adjustdoctype = 'SALESORDER'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )

         %field-docno     = COND #( WHEN gs_item-adjustdoctype = 'INVOICE'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )

        %field-loanamt   = COND #( WHEN ( gs_item-adjustdoctype = 'LOAN' OR gs_item-adjustdoctype = 'INVOICE'
                                                    OR gs_item-adjustdoctype = 'OTHERS'
                                                    OR gs_item-adjustdoctype = 'SALESORDER' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )
        %field-salesamt   = COND #( WHEN ( gs_item-adjustdoctype = 'LOAN' OR gs_item-adjustdoctype = 'INVOICE'
                                                    OR gs_item-adjustdoctype = 'OTHERS'
                                                    OR gs_item-adjustdoctype = 'SALESORDER' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )
        %field-amt   = COND #( WHEN ( gs_item-adjustdoctype = 'LOAN' OR gs_item-adjustdoctype = 'INVOICE'
                                                    OR gs_item-adjustdoctype = 'OTHERS'
                                                    OR gs_item-adjustdoctype = 'SALESORDER' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )
        %field-otheramt   = COND #( WHEN ( gs_item-adjustdoctype = 'LOAN' OR gs_item-adjustdoctype = 'INVOICE'
                                                    OR gs_item-adjustdoctype = 'SALESORDER' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )


        ) ).


  ENDMETHOD.


* KJ/09.12.2024

  METHOD item_detail.

    READ ENTITIES OF zi_forextp IN LOCAL MODE
              ENTITY zi_forextp
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(header)
              " TODO: variable is assigned but never used (ABAP cleaner)
              FAILED FINAL(header_failed).
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_forextp IN LOCAL MODE
                  ENTITY zi_forextpitm
                  ALL FIELDS
                  WITH CORRESPONDING #( keys )
                  RESULT FINAL(item)
                  " TODO: variable is assigned but never used (ABAP cleaner)
                  FAILED FINAL(item_failed).
*    READ ENTITY zi_forextp
*          BY \_item
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT FINAL(item).
    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    IF gfs_item-docno IS NOT INITIAL .

      SELECT SINGLE * FROM zcds_invamt
     WHERE companycode        = @gfs_item-companycode AND
           accountingdocument = @gfs_item-docno AND
           fiscalyear         = @gfs_item-fiscalyear
      INTO @DATA(ls_doc).

      gfs_item-waers    = ls_doc-transactioncurrency.
      gfs_item-amt      = ls_doc-amount.
*    gfs_item-Adjustval = ls_doc-amount.  "//sm
      gfs_item-docdate  = ls_doc-documentdate.

    ELSEIF gfs_item-loanaccno IS NOT INITIAL .

      SELECT SINGLE * FROM zi_pcrhdr
          WHERE loanacno = @gfs_item-loanaccno
          INTO @DATA(ls_doc1).
      IF sy-subrc = 0.
        gfs_item-loancurr = ls_doc1-waers.
        gfs_item-loanamt  = ls_doc1-bookamt.
      ENDIF.

    ELSEIF gfs_item-salesorder IS NOT INITIAL .

      SELECT SINGLE * FROM i_salesorder
       WHERE salesorder = @gfs_item-salesorder
       INTO @DATA(ls_so_det).
      IF sy-subrc = 0.
        gfs_item-salesdate = ls_so_det-salesorderdate.
        gfs_item-salesamt  = ls_so_det-totalnetamount.
        gfs_item-salecurr  = ls_so_det-transactioncurrency.
        gfs_item-waers     = ls_so_det-transactioncurrency.

      ENDIF.
    ENDIF.

    MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
     ENTITY zi_forextpitm
     UPDATE FIELDS (  waers amt docdate adjustval salecurr salesamt salesdate othercurr loancurr loanamt )
     WITH VALUE #( id = gfs_item-id
                   ( %tky       = gfs_item-%tky
                     waers      = gfs_item-waers
                     amt        = gfs_item-amt
                     docdate    = gfs_item-docdate
                     adjustval  = gfs_item-adjustval
                     loancurr   = gfs_item-loancurr
                     loanamt    = gfs_item-loanamt
                     salesamt   = gfs_item-salesamt
                     salesdate  = gfs_item-salesdate
                     salecurr   = gfs_item-salecurr
                     othercurr  = gfs_header-waers

                   ) ).
*//------------------------------------------------------------- ---//

    DATA: ls_sum TYPE dmbtr.
    DATA: lv_amt TYPE dmbtr.
    CLEAR : ls_sum,lv_amt.

    READ ENTITY zi_forextp
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(it1).

    LOOP AT it1 INTO DATA(ls_it1).
      lv_amt = lv_amt + ls_it1-adjustval + ls_it1-otheramt.
    ENDLOOP.

    ls_sum = lv_amt.
    gfs_header-balanceval = gfs_header-contamt - ls_sum. "ls_item-appl_amt_lc.

    MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
            ENTITY zi_forextp
            UPDATE
                FIELDS ( balanceval  )
                WITH VALUE #( ( %tky   = gfs_header-%tky
                                 balanceval           = gfs_header-balanceval
                                 %control-balanceval  = if_abap_behv=>mk-on
                               ) ).
  ENDMETHOD.

* KJ/09.12.2024

  METHOD adjustamt.
*
*  READ ENTITIES OF zi_forextp IN LOCAL MODE
*                 ENTITY zi_forextp
*                 ALL FIELDS
*                 WITH CORRESPONDING #( keys )
*                 RESULT FINAL(header)
*                 " TODO: variable is assigned but never used (ABAP cleaner)
*                 FAILED FINAL(header_failed).
*
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*    READ ENTITY zi_forextp
*          BY \_item
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT FINAL(item).
*    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).
*
*    IF gfs_item-adjustdoctype = 'INVOICE'.
*      gfs_item-Adjustval = gfs_item-Amt.
*    ELSEIF gfs_item-adjustdoctype = 'OTHERS'.
*      gfs_item-Adjustval = gfs_item-Otheramt.
**    ELSEIF gfs_item-adjustdoctype = 'SALESORDER'.
**    gfs_item-Adjustval = gfs_item-Salesamt.
*    ELSEIF gfs_item-Adjustdoctype = 'LOAN'.
*    gfs_item-Adjustval = gfs_item-Loanamt.
*    ENDIF.
*
*    MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
*    ENTITY zi_forextpitm
*    UPDATE FIELDS ( Adjustval  )
*    WITH VALUE #( id = gfs_item-id
*                  ( %tky    = gfs_item-%tky
*                    Adjustval  = gfs_item-Adjustval
*
*                  ) ).
  ENDMETHOD.

  METHOD adjusthedamt.
    DATA: ls_sum TYPE dmbtr,
          lv_amt TYPE dmbtr.

    READ ENTITIES OF zi_forextp IN LOCAL MODE
                 ENTITY zi_forextp
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    READ ENTITY zi_forextp
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_itm).

    lv_amt = REDUCE dmbtr( INIT lv_itm TYPE dmbtr FOR ls_itm IN lt_itm
                              NEXT lv_itm = lv_itm + ls_itm-adjustval ) .

    gfs_header-balanceval = gfs_header-contamt - lv_amt .

    MODIFY ENTITIES OF zi_forextp IN LOCAL MODE
            ENTITY zi_forextp
            UPDATE
            FIELDS ( balanceval  )
            WITH VALUE #( ( %tky                 = gfs_header-%tky
                            balanceval           = gfs_header-balanceval
                            %control-balanceval  = if_abap_behv=>mk-on
                               ) ).
  ENDMETHOD.

  METHOD checkdetails.
    DATA: lv_msg TYPE string .
*----------------------------------------------------------------------------*
    READ ENTITIES OF zi_forextp IN LOCAL MODE
                 ENTITY zi_forextp
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_forextp " IN LOCAL MODE
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item).
*----------------------------------------------------------------------------*
    LOOP AT item INTO DATA(gfs_item).
      "-- Currency Field Mandatory ---"
      IF gfs_item-waers IS NOT INITIAL.
        IF ( gfs_header-waers <> gfs_item-waers ) .
          lv_msg = |Forward Currency & | && gfs_item-adjustdoctype && | Currency is mismatched| .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_forextp.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_forextp.
        ENDIF.
      ENDIF.
      "-- Loan Currency Check ---"
      IF gfs_item-loancurr IS NOT INITIAL.
        IF ( gfs_header-waers <> gfs_item-loancurr ) .
          lv_msg = |Forward Currency & | && gfs_item-adjustdoctype && | Currency is mismatched| .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_forextp.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_forextp.
        ENDIF.
      ENDIF.
      "-- Sales Currency Check ---"
      IF gfs_item-salecurr IS NOT INITIAL.
        IF ( gfs_header-waers <> gfs_item-salecurr ) .
          lv_msg = |Forward Currency & | && gfs_item-adjustdoctype && | Currency is mismatched| .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_forextp.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_forextp.
        ENDIF.
      ENDIF.
      "--Loan Amount Check ---"
      IF gfs_item-loanaccno IS NOT INITIAL.
        IF gfs_item-loanamt < gfs_item-adjustval .
          lv_msg = |Adjust Amount Greater then Loan Amount | .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_forextp.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_forextp.
        ENDIF.
      ENDIF.
      "-- Sales Order Amount Check ---"
      IF gfs_item-salesorder IS NOT INITIAL.
        IF gfs_item-salesamt < gfs_item-adjustval .
          lv_msg = |Adjust Amount Greater then Sales Order Amount | .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_forextp.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_forextp.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
