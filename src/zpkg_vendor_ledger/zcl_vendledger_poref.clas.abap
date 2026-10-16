CLASS zcl_vendledger_poref DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION zv_vendorledger05.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VENDLEDGER_POREF IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                       FOR HDB
                       LANGUAGE SQLSCRIPT
                       OPTIONS READ-ONLY
                      USING zv_vendorledger07.

    lt_item_1 = select mandt, accountingdocument, companycode, fiscalyear, purchasingdocument
    from zv_vendorledger07 where purchasingdocument <> '';

    lt_item_2 = SELECT DISTINCT accountingdocument, companycode, fiscalyear, COUNT ( purchasingdocument ) as count FROM :lt_item_1
    GROUP BY accountingdocument, companycode, fiscalyear;

    lt_item_4 = SELECT  a.mandt,
                        a.accountingdocument,
                        a.companycode,
                        a.fiscalyear,
                        case
                        when count > 1
                        then
                        string_agg( a.purchasingdocument , ', ' )
                        else
                        string_agg( a.purchasingdocument  , '' )
                        end as poreference
                from :lt_item_1 as a
                inner join :lt_item_2 as b on b.accountingdocument = a.accountingdocument
                and b.companycode = a.companycode
                and b.fiscalyear = a.fiscalyear
                group by    a.mandt,
                            a.accountingdocument,
                            a.companycode,
                            a.fiscalyear,
                            b.count;

   return  select * from :lt_item_4 order by accountingdocument asc;

  endmethod.
ENDCLASS.
