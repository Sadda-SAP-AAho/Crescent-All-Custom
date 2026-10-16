CLASS zcl_prodrouting_det DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

 PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_func_routing.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRODROUTING_DET IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING Z_I_ROUTING.


   lt_item = select mandt , cast(ProductionRoutingGroup as CHAR( 8 )) as ProductionRoutingGroup,
                    cast(ProductionRouting as CHAR( 8 )) as ProductionRouting,
                    cast(WorkCenterInternalID as CHAR( 10 )) as WorkCenterInternalID,
                    WorkCenterTypeCode, cast(StandardWorkQuantity1 as DEC( 13, 3 )) as StandardWorkQuantity1
                     ,cast(StandardWorkQuantity2 as DEC( 13, 3 ) ) as StandardWorkQuantity2
   from Z_I_ROUTING;



     RETURN  select *
       from :lt_item;



ENDMETHOD.
ENDCLASS.
