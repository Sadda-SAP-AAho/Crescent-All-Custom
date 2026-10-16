CLASS zcl_fx_data_1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_fx_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FX_DATA_1 IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING z_i_fxdata.

    RETURN

      select
            a.mandt                                                      as mandt,
            cast( to_dats( a.instructdate ) as nvarchar(8) )             as instructdate,
            cast( a.bankname as nvarchar(100) )                          as bankname,
            cast(
        string_agg( '''' || cast( a.contnoext as nvarchar(30) ), ',' ) as nvarchar(500) ) as contnoext

      from z_i_fxdata as a

      group by
              a.mandt,
              a.instructdate,
              a.bankname;

  ENDMETHOD.
ENDCLASS.
