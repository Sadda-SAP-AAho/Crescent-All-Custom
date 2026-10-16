CLASS zcl_bomcost_r DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
   CLASS-METHODS get_data FOR TABLE FUNCTION ZR_BOMCOST_RPT_R_2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOMCOST_R IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_BOMCOST_RPT_R_2.

    lt_item1 = select a.costcenter, a.activitytype, MAX( a.validitystartfiscalyear ) as validitystartfiscalyear
               from Z_I_BOMCOST_RPT_R_2 as a
               group by a.costcenter, a.activitytype;

    lt_item2 = select b.costcenter, b.activitytype, b.validitystartfiscalyear,
                      MAX( a.validitystartfiscalperiod ) as validitystartfiscalperiod
               from :lt_item1 as b
               inner join Z_I_BOMCOST_RPT_R_2 as a on a.costcenter = b.costcenter and a.activitytype = b.activitytype
                                               and a.validitystartfiscalyear = b.validitystartfiscalyear
               group by b.costcenter, b.activitytype, b.validitystartfiscalyear;

    lt_item = select a.mandt, a.costcenter, a.activitytype,
              cast( a.costratefixedamount as DEC( 23, 2 ) ) as costamt,
              cast( a.costratescalefactor as NUMERIC( 6 ) ) as factor
              from :lt_item2 as b
              inner join Z_I_BOMCOST_RPT_R_2 as a on a.costcenter = b.costcenter and a.activitytype = b.activitytype
                                              and a.validitystartfiscalyear = b.validitystartfiscalyear
                                              and a.validitystartfiscalperiod = b.validitystartfiscalperiod;

    return  select *
            from :lt_item
            order by costcenter asc, activitytype asc;

  endmethod.
ENDCLASS.
