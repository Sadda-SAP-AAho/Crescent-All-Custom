CLASS zcl_fx_date DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_fx_date.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FX_DATE IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING z_i_fxdate.

    RETURN

      select
            a.mandt                                                      as mandt,
            cast( to_dats( a.instructdate ) as nvarchar(8) )             as instructdate,
            cast( a.bankname as nvarchar(100) )                          as bankname,
            min(a.bookdate) as bookdate

      from z_i_fxdate as a

      group by
              a.mandt,
              a.instructdate,
              a.bankname;

  endmethod.
ENDCLASS.
