CLASS zcl_debtor_rpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
   CLASS-METHODS get_data FOR TABLE FUNCTION ZTBL_DEBTOR_RPT.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEBTOR_RPT IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING ZI_FI_DEBTOR_RPT_13.

    lt_item3 = select * from ZI_FI_DEBTOR_RPT_13;

    lt_item1 = SELECT DISTINCT billingdocument, COUNT ( shippingbill  ) as num_a from :lt_item3
               GROUP BY billingdocument;

    lt_item = select b.mandt , a.billingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( b.shippingbill , ', ' )
                        else
                        string_agg( b.shippingbill  , '' )
                        end as shippingbill
                from :lt_item1 as a
                inner join :lt_item3 as b on b.billingdocument = a.billingdocument

                group by b.mandt, a.billingdocument, num_a;

    return  select *
            from :lt_item
            order by billingdocument asc;

  endmethod.
ENDCLASS.
