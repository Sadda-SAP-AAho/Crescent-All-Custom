CLASS zcl_debtor_rpt_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
   CLASS-METHODS get_data FOR TABLE FUNCTION ZTBL_DEBTOR_RPT_1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEBTOR_RPT_1 IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING ZI_FI_DEBTOR_RPT_6.

    lt_item3 = select * from ZI_FI_DEBTOR_RPT_6;

    lt_item1 = SELECT DISTINCT arinv, COUNT ( billingdocument ) as num_a from :lt_item3
               GROUP BY arinv;

    lt_item = select b.mandt , a.arinv,
                        case
                        when num_a > 1
                        then
                        string_agg( b.billingdocument , ', ' )
                        else
                        string_agg( b.billingdocument  , '' )
                        end as billingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( b.billingdocumentref , ', ' )
                        else
                        string_agg( b.billingdocumentref  , '' )
                        end as billingdocumentref
                from :lt_item1 as a
                inner join :lt_item3 as b on b.arinv = a.arinv

                group by b.mandt, a.arinv, num_a;

    return  select *
            from :lt_item
            order by arinv asc;

  endmethod.
ENDCLASS.
