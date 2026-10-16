CLASS zcl_xblnr_rpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION zv_firegtbl4.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_XBLNR_RPT IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zv_firegisterv5.

    lt_item3 = select mandt, companycode, fiscalyear, accountingdocument, accountingdocumentitem, assignmentreference from zv_firegisterv5;

    lt_item1 = SELECT DISTINCT mandt, companycode, fiscalyear, accountingdocument,
                       COUNT ( assignmentreference  ) as num_a FROM :lt_item3
               GROUP BY mandt, companycode, fiscalyear, accountingdocument;

    lt_item = SELECT b.mandt,
                     a.companycode,
                     a.fiscalyear,
                     a.accountingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( b.assignmentreference , ', ' )
                        else
                        string_agg( b.assignmentreference  , '' )
                        end as description
                from :lt_item1 as a
                inner join :lt_item3 as b on b.companycode = a.companycode
                                        and  b.fiscalyear = a.fiscalyear
                                        and  b.accountingdocument = a.accountingdocument
                group by b.mandt, a.companycode, a.fiscalyear, a.accountingdocument, num_a;

    return  select  mandt,
                    accountingdocument,
                    fiscalyear,
                    companycode,
                    description
            from :lt_item
            order by companycode asc, fiscalyear asc, accountingdocument asc;

  endmethod.
ENDCLASS.
