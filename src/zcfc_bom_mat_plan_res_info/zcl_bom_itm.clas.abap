CLASS zcl_bom_itm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_bom_itm.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOM_ITM IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING z_i_bom_itm .

      RETURN
            select mandt, billofmaterial, BillOfMaterialComponent, ProdOrderIssueLocation
            from z_i_bom_itm
            order by billofmaterial asc, BillOfMaterialComponent asc ;
 ENDMETHOD.
ENDCLASS.
