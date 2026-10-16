CLASS zcl_fx_data_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_fx_data_2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FX_DATA_2 IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                             FOR HDB
                             LANGUAGE SQLSCRIPT
                             OPTIONS READ-ONLY
                             USING z_i_fxdata_2.

    RETURN

      select
            a.mandt                                                      as mandt,
            cast( a.remarks as nvarchar(255) )                          as remarks,
            cast(
        string_agg( '''' || cast( a.contnoext as nvarchar(30) ), ',' ) as nvarchar(500) ) as contnoext

      from z_i_fxdata_2 as a

      group by
              a.mandt,
              a.remarks;

  endmethod.
ENDCLASS.
