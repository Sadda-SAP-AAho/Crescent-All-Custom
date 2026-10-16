CLASS zcl_fx_date_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_fx_date_2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FX_DATE_2 IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING z_i_fxdate_2.

    RETURN

      select
            a.mandt                                                      as mandt,
            cast( a.remarks as nvarchar(255) )                          as remarks,
            min(a.bookdate) as bookdate

      from z_i_fxdate_2 as a

      group by
              a.mandt,
              a.remarks;

  endmethod.
ENDCLASS.
