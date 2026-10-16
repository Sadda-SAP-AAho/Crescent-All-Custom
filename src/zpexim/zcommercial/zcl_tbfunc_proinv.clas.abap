CLASS zcl_tbfunc_proinv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_func_proforma.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TBFUNC_PROINV IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
              FOR HDB
              LANGUAGE SQLSCRIPT
              OPTIONS READ-ONLY
              USING zi_billingdocument1 zi_billingdocumentitem2.

    lt_item = select * from zi_billingdocumentitem2 ;

    lt_item1 = SELECT DISTINCT a.billingdocument as comminv , d.billingdocument as proinv
           from zi_billingdocument1 as a
           left outer join :lt_item as b on a.billingdocument = b.billingdocument
                                         and b.referencesddocumentcategory = 'J'
           left outer join zi_billingdocumentitem2 as c ON c.referencesddocument = b.referencesddocument
                                                      and c.referencesddocumentitem = b.referencesddocumentitem
           left outer join zi_billingdocument1 as d on d.billingdocument = c.billingdocument

           where d.billingdocumenttype = 'F8'
                 and a.billingdocumenttype = 'F2'
                  and d.accountingpostingstatus <> 'E'
           group by a.billingdocument,d.billingdocument;

    lt_item2 = select distinct comminv, count ( proinv ) as num_a from :lt_item1
               group by comminv;



   lt_item3 = select   session_context( 'CLIENT' ) as mandt, a.comminv,
                        case
                        when a.num_a > 1
                        then
                        string_agg( b.proinv , ', ' )
                        else
                        string_agg( b.proinv, '' )
                        end as proinv
                        from :lt_item2 as a
                        inner join :lt_item1 as b on b.comminv = a.comminv
                        group by  a.comminv, a.num_a;


return select * from :lt_item3 ;

  endmethod.
ENDCLASS.
