CLASS zcl_bom_head DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_bom_head.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BOM_HEAD IMPLEMENTATION.


 METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING z_i_bom_head .

      RETURN
            select mandt, billofmaterial, plant, material
            from z_i_bom_head
            order by billofmaterial asc, plant asc, material asc;

 ENDMETHOD.
ENDCLASS.
