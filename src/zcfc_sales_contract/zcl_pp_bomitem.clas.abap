CLASS zcl_pp_bomitem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_bom_item.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_BOMITEM IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING Z_I_BOMITEM.

lt_item_3 = select * from Z_I_BOMITEM;

    lt_item = SELECT a.mandt as mandt, a.plant, a.material
              from :lt_item_3 as a
              group by a.mandt, a.plant, a.material;

    return  select *
            from :lt_item
            order by material asc,plant asc;

  endmethod.
ENDCLASS.
