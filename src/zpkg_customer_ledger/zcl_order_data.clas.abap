CLASS zcl_order_data DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztabl_order_no.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ORDER_DATA IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING  zr_orderno  .

    it_item = select DISTINCT
    clnt as client ,
    accountingdocument,
    fiscalyear,
    companycode,
    billingdocument
    from zr_orderno  ;


     it_item2 = SELECT client ,
    accountingdocument,
    fiscalyear,
    companycode,
    COUNT ( billingdocument ) as num
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
      string_agg( b.billingdocument , '' )
      else
      string_agg( b.billingdocument , ' , ' )
      end as orderno
      from :it_item2 as a inner join :it_item as b on a.accountingdocument = b.accountingdocument
      and a.companycode = b.companycode
      and a.fiscalyear = b.fiscalyear
      group by a.accountingdocument , a.num,a.client , a.companycode , a.fiscalyear;

      return select *
      from :it_item3;

  ENDMETHOD.
ENDCLASS.
