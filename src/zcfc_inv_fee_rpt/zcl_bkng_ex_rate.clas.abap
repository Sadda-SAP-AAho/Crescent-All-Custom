CLASS zcl_bkng_ex_rate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_bkng_ex_rate.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BKNG_EX_RATE IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                               FOR HDB
                               LANGUAGE SQLSCRIPT
                               OPTIONS READ-ONLY
                               USING z_i_book_ex_rate zi_invoice_fee_rpt_basic.

    RETURN

      select
            a.mandt,
            b.compcode,
            b.fy,
            b.jeno,
            a.sourcecurrency,
            a.targetcurrency,
            max( a.validitystartdate ) as validitystartdate
      from z_i_book_ex_rate as a
      inner join zi_invoice_fee_rpt_basic as b on a.sourcecurrency = b.transactioncurrency
                                              and a.validitystartdate <= b.fxbookdate
                                              and a.exchangeratetype = 'M'
      group by
              a.mandt,
              b.compcode,
              b.fy,
              b.jeno,
              a.sourcecurrency,
              a.targetcurrency

      union all

      select
            a.mandt,
            b.compcode,
            b.fy,
            b.jeno,
            a.sourcecurrency,
            a.targetcurrency,
            max( a.validitystartdate ) as validitystartdate
      from z_i_book_ex_rate as a
      inner join zi_invoice_fee_rpt_basic as b on a.validitystartdate <= b.jedate
                                              and a.exchangeratetype = 'M'
                                              and ( b.supplier is not null or b.supplier <> '' )
                                              and ( b.pcfcloanno is null or b.pcfcloanno = '' )
                                              and a.sourcecurrency = 'INR'
      group by
              a.mandt,
              b.compcode,
              b.fy,
              b.jeno,
              a.sourcecurrency,
              a.targetcurrency;

  endmethod.
ENDCLASS.
