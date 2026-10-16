CLASS zcl_pp_prod_ordr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_prod_ordr.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_PROD_ORDR IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING  Z_I_Prod_Order.

lt_item_3 = select * from Z_I_Prod_Order;

    lt_item = SELECT a.mandt as mandt, a.ProductionOrder, a.Product, a.ProductionPlant,
                     a.CreatedByUser, a.CreationDate, a.LastChangedByUser, a.LastChangeDate,
                     a.ProductionOrderType, a.PlannedOrder, a.ProfitCenter, a.OrderActualReleaseDate
              from :lt_item_3 as a
              group by a.mandt, a.ProductionOrder, a.Product, a.ProductionPlant,
                     a.CreatedByUser, a.CreationDate, a.LastChangedByUser, a.LastChangeDate,
                     a.ProductionOrderType, a.PlannedOrder, a.ProfitCenter, a.OrderActualReleaseDate;

    return  select *
            from :lt_item
            order by ProductionOrder asc,Product asc,ProductionPlant asc;

  endmethod.
ENDCLASS.
