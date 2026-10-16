CLASS zcl_grpo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_grpo_rpt.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GRPO IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING zcds_migo_det z_i_grpo_rep.

    lt_item_3 = select a.mandt_1 as mandt, a.materialdocument, a.materialdocumentitem, a.materialdocumentyear,
                       b.yy1_challannumber_mmi, b.yy1_challandate_mmi
                from zcds_migo_det as a
                inner join z_i_grpo_rep as b on b.materialdocument = a.materialdocument
                and b.materialdocumentitem = a.materialdocumentitem and b.materialdocumentyear = a.materialdocumentyear;

     return  select *
       from :lt_item_3
     order by materialdocumentyear asc, materialdocument asc, materialdocumentitem asc;
  endmethod.
ENDCLASS.
