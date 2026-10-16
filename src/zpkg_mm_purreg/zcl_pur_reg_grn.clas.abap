CLASS zcl_pur_reg_grn DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztf_purchase_reg_5.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PUR_REG_GRN IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING Z_I_PURCHASE_REG_5.

    lt_item = select a.mandt, a.materialdocument, a.materialdocumentitem, a.materialdocumentyear,
                     a.yy1_gateentrynumber_mmi,
                     cast( a.yy1_challanquantity_mmi as dec( 13, 3 ) ) as yy1_challanquantity_mmi,
                     cast( a.yy1_tareweight_mmi as dec( 13, 3 ) )  as yy1_tareweight_mmi,
                     a.yy1_netweight_mmiu,
                     cast( a.yy1_grossweight_mmi as dec( 13, 3 ) ) as yy1_grossweight_mmi,
                     cast( a.yy1_netweight_mmi as dec( 13, 3 ) )  as yy1_netweight_mmi,
                     cast( a.YY1_VehicleNumber_MMI as char( 30 ) ) as YY1_VehicleNumber_MMI
                from Z_I_PURCHASE_REG_5 as a;

    return  select *
            from :lt_item
            order by materialdocumentyear asc, materialdocument asc, materialdocumentitem asc;

  endmethod.
ENDCLASS.
