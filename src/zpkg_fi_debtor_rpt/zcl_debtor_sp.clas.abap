CLASS zcl_debtor_sp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_debtor_sp.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEBTOR_SP IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zi_fi_debtor_rpt_17.

    lt_item3 = select * from zi_fi_debtor_rpt_17;

    lt_item1 = SELECT DISTINCT billingdocument, COUNT ( salesperson ) as num_a FROM :lt_item3
               GROUP BY billingdocument;

    lt_item = SELECT b.mandt , a.billingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( b.salesperson , ', ' )
                        else
                        string_agg( b.salesperson  , '' )
                        end as salesperson
                from :lt_item1 as a
                inner join :lt_item3 as b on b.billingdocument = a.billingdocument
                group by b.mandt, a.billingdocument, num_a;

    return  select *
            from :lt_item
            order by billingdocument asc;

  endmethod.
ENDCLASS.
