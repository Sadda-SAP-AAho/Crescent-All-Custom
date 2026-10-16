CLASS zcl_tbfunc_salenoteref DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_func_salenoteref.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TBFUNC_SALENOTEREF IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
              FOR HDB
              LANGUAGE SQLSCRIPT
              OPTIONS READ-ONLY
              USING ZCDS_SALENOTEREF.

    lt_item = SELECT * from zcds_salenoteref;

    lt_item1 = SELECT DISTINCT billingdocument, COUNT ( salesnoteref ) as num_a from :lt_item
               GROUP BY billingdocument;

    lt_item2 = select b.mandt ,a.billingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( b.salesnoteref , ', ' )
                        else
                        string_agg( b.salesnoteref  , '' )
                        end as Salesnoteref
                from :lt_item1 as a
                inner join :lt_item as b on b.billingdocument = a.billingdocument


                group by b.mandt,a.billingdocument,num_a;



     RETURN  select *
       from :lt_item2;


  endmethod.
ENDCLASS.
