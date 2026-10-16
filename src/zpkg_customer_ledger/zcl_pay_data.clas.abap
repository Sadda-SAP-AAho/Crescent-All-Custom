CLASS zcl_pay_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztabl_payment_ref.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAY_DATA IMPLEMENTATION.


 METHOD get_data BY DATABASE FUNCTION
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING  zr_payment_ref01  .

    it_item = select DISTINCT
    clnt as client ,
    clearingjournalentry as accountingdocument,
    clearingjournalentryfiscalyear as fiscalyear,
    companycode,
    OriginalReferenceDocument as paymentref
    from zr_payment_ref01  ;


     it_item2 = SELECT client ,
    accountingdocument,
    fiscalyear,
    companycode,
    COUNT ( paymentref ) as num
    FROM :it_item
    GROUP BY client,  accountingdocument,
    fiscalyear,
    companycode;

      it_item3 = SELECT a.client ,
      a.accountingdocument,
      a.fiscalyear,
      a.companycode,
      case
      when a.num <= 1
      then
      string_agg( b.paymentref , '' )
      else
      string_agg( b.paymentref , ' , ' )
      end as payref
      from :it_item2 as a inner join :it_item as b on a.accountingdocument = b.accountingdocument
      and a.companycode = b.companycode
      and a.fiscalyear = b.fiscalyear
      group by a.accountingdocument , a.num,a.client , a.companycode , a.fiscalyear;

      return select *
      from :it_item3;

  ENDMETHOD.
ENDCLASS.
