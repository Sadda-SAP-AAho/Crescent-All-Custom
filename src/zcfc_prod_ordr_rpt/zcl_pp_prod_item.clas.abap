CLASS zcl_pp_prod_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_prod_item.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_PROD_ITEM IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_PROD_ITEM.

lt_item_3 = select * from Z_I_PROD_ITEM;

    lt_item = SELECT a.mandt as mandt, a.ProductionOrder, a.ProductionOrderItem, a.Product, a.ProductionPlant,
                     a.ProductionOrderType, a.PlannedTotalQty, a.GoodsReceiptQty, ( coalesce(a.PlannedTotalQty,0) - coalesce(a.GoodsReceiptQty,0) ) as OpenYieldQuantity
              from :lt_item_3 as a
              group by a.mandt, a.ProductionOrder, a.ProductionOrderItem, a.Product, a.ProductionPlant,
                     a.ProductionOrderType, a.PlannedTotalQty, a.GoodsReceiptQty;

    return  select *
            from :lt_item
            order by ProductionOrder asc,ProductionOrderItem asc,Product;

  endmethod.
ENDCLASS.
