CLASS zcl_pp_nonbom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_nonbom_rpt.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_NONBOM IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING zcds_pp_nonbom_rpt_4 Z_I_NONBOM_RPT.

    lt_item_3 = select * from zcds_pp_nonbom_rpt_4;
* ZCDS_PP_STAN_VS_ACT_NONBOM_6;

    lt_item = SELECT a.mandt as mandt, a.postingdate, a.plant, a.costcenter, a.material,
                     a.productname as productdescription, a.glaccount, a.consbase as conbase,
                     ( case when b.inventoryvaluationprocedure = 'S' THEN b.standardprice
                            when b.inventoryvaluationprocedure = 'V' THEN b.movingaverageprice end ) as actissval, b.currency
              from :lt_item_3 as a
              inner join Z_I_NONBOM_RPT as b on b.product = a.material and b.valuationarea = a.plant;

    return  select *
            from :lt_item
            order by postingdate asc;

  endmethod.
ENDCLASS.
