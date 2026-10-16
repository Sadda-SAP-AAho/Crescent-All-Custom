CLASS zcl_pp_bom_comp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_bom_comp.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_BOM_COMP IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_BOM_COMP.

lt_item_3 = select * from Z_I_BOM_COMP;

    lt_item = SELECT a.mandt as mandt, a.plant, a.BillOfMaterialComponent
              from :lt_item_3 as a
              group by a.mandt, a.plant, a.BillOfMaterialComponent;

    return  select *
            from :lt_item
            order by BillOfMaterialComponent asc,plant asc;

  endmethod.
ENDCLASS.
