CLASS zcl_routing_seq DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
   CLASS-METHODS get_data FOR TABLE FUNCTION ZR_BOMCOST_RPT_R_5.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ROUTING_SEQ IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_BOMCOST_RPT_R_5.

    lt_item = select a.mandt, a.ProductionRoutingGroup , a.productionrouting
                from Z_I_BOMCOST_RPT_R_5 as a
               where a.isdeleted <> 'X';

    return  select *
            from :lt_item
            order by ProductionRoutingGroup asc, productionrouting asc;

  endmethod.
ENDCLASS.
