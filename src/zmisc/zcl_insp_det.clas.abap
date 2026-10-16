CLASS zcl_insp_det DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_inspectionqm.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INSP_DET IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING z_i_inspplantmat_tp_2.


    lt_item = select mandt, material, plant, inspectionplangroup, inspectionplan, inspplanmatlassignment, inspplanmatlassgmtintversion
     from z_i_inspplantmat_tp_2;

      RETURN  select *
        from :lt_item;

  ENDMETHOD.
ENDCLASS.
