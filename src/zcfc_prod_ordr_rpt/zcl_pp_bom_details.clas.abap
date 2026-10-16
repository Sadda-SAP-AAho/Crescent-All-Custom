CLASS zcl_pp_bom_details DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_bom_details.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_BOM_DETAILS IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_BOM_DETAILS.

lt_item_3 = select * from Z_I_BOM_DETAILS;

    lt_item = SELECT a.mandt as mandt, a.BillOfMaterial, a.Material, a.BillOfMaterialItemNumber, a.Plant,
                     a.BillOfMaterialComponent, a.ComponentDescription, a.BillOfMaterialItemCategory,
                     a.BillOfMaterialItemQuantity, a.BillOfMaterialItemUnit
              from :lt_item_3 as a
              group by a.mandt, a.BillOfMaterial, a.Material, a.BillOfMaterialItemNumber, a.Plant,
                     a.BillOfMaterialComponent, a.ComponentDescription, a.BillOfMaterialItemCategory,
                     a.BillOfMaterialItemQuantity, a.BillOfMaterialItemUnit;

    return  select *
            from :lt_item
            order by BillOfMaterial asc, Material asc,BillOfMaterialItemNumber asc,Plant asc,BillOfMaterialComponent;

  endmethod.
ENDCLASS.
