CLASS zcl_mat_spec DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_mat_spec.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MAT_SPEC IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING z_i_insp_plan z_i_insp_char.

    lt_item_2 = select a.mandt, a.material, a.plant, d.inspectionspecification,
                cast( d.inspspecupperlimit as dec( 13, 3 ) ) as inspspecupperlimit,
                cast( d.inspspeclowerlimit as dec( 13, 3 ) ) as inspspeclowerlimit
                from z_i_insp_plan as a
                inner join z_i_insp_char as d on d.inspectionplangroup = a.inspectionplangroup
                                             and a.inspectionplan = d.inspectionplan
                                             and d.boooperationinternalid = a.inspplanmatlassgmtintversion
                                             and d.isdeleted <> 'X';


    return  select *
         from :lt_item_2
       order by material asc, plant asc, inspectionspecification asc;

  endmethod.
ENDCLASS.
