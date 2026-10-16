CLASS zcl_debtor_rpt_sref DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_debtor_rpt_sref.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEBTOR_RPT_SREF IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zi_fi_debtor_rpt_2.

    lt_item3 = select * from zi_fi_debtor_rpt_2;

    lt_item1 = SELECT DISTINCT billingdocument, COUNT ( salesnoteref ) as num_a FROM :lt_item3
               GROUP BY billingdocument;

    lt_item = SELECT b.mandt , a.billingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( b.salesnoteref , ', ' )
                        else
                        string_agg( b.salesnoteref  , '' )
                        end as salesnoteref
                from :lt_item1 as a
                inner join :lt_item3 as b on b.billingdocument = a.billingdocument

                group by b.mandt, a.billingdocument, num_a;

    return  select *
            from :lt_item
            order by billingdocument asc;

  endmethod.
ENDCLASS.
