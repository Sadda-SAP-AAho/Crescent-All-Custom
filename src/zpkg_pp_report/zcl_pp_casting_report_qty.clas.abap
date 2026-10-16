CLASS zcl_pp_casting_report_qty DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztf_pp_casting_report_qty.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_CASTING_REPORT_QTY IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING Z_I_PP_CASTING_RPT_QTY.

    lt_item = select a.mandt, a.productionroutinggroup , a.workcenterinternalid,
                     cast( a.standardworkquantity1 as dec( 13, 3 ) ) as standardworkquantity1, a.standardworkquantityunit1,
                     cast( a.standardworkquantity2 as dec( 13, 3 ) ) as standardworkquantity2, a.standardworkquantityunit2,
                     cast( a.standardworkquantity3 as dec( 13, 3 ) ) as standardworkquantity3, a.standardworkquantityunit3,
                     cast( a.standardworkquantity4 as dec( 13, 3 ) ) as standardworkquantity4, a.standardworkquantityunit4,
                     cast( a.standardworkquantity5 as dec( 13, 3 ) ) as standardworkquantity5, a.standardworkquantityunit5,
                     cast( a.standardworkquantity6 as dec( 13, 3 ) ) as standardworkquantity6, a.standardworkquantityunit6
              from Z_I_PP_CASTING_RPT_QTY as a;



    return  select *
            from :lt_item
            order by productionroutinggroup asc, workcenterinternalid asc;

  endmethod.
ENDCLASS.
