CLASS zcl_routing_det DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
   CLASS-METHODS get_data FOR TABLE FUNCTION ZR_BOMCOST_RPT_R_4.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ROUTING_DET IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_BOMCOST_RPT_R_4.

    lt_item = select a.mandt, a.ProductionRoutingGroup , a.productionrouting, a.WorkCenterInternalID,
                     cast( a.StandardWorkQuantity1 as DEC( 13, 3 ) ) as StandardWorkQuantity1, a.StandardWorkQuantityUnit1,
                     cast( a.StandardWorkQuantity2 as DEC( 13, 3 ) ) as StandardWorkQuantity2, a.StandardWorkQuantityUnit2,
                     cast( a.StandardWorkQuantity3 as DEC( 13, 3 ) ) as StandardWorkQuantity3, a.StandardWorkQuantityUnit3,
                     cast( a.StandardWorkQuantity4 as DEC( 13, 3 ) ) as StandardWorkQuantity4, a.StandardWorkQuantityUnit4,
                     cast( a.StandardWorkQuantity5 as DEC( 13, 3 ) ) as StandardWorkQuantity5, a.StandardWorkQuantityUnit5,
                     cast( a.StandardWorkQuantity6 as DEC( 13, 3 ) ) as StandardWorkQuantity6, a.StandardWorkQuantityUnit6
              from Z_I_BOMCOST_RPT_R_4 as a;



    return  select *
            from :lt_item
            order by ProductionRoutingGroup asc, productionrouting asc, WorkCenterInternalID asc;

  endmethod.
ENDCLASS.
