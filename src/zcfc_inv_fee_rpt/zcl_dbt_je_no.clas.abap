CLASS zcl_dbt_je_no DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_debt_je_no.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DBT_JE_NO IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                             FOR HDB
                             LANGUAGE SQLSCRIPT
                             OPTIONS READ-ONLY
                             USING z_i_debt_je_no.

    RETURN

      select
            a.mandt as mandt,
            cast( a.jeno as nvarchar(100) ) as jeno,
            cast(
        string_agg( '''' || cast( a.debtjeno as nvarchar(30) ), ',' ) as nvarchar(500) ) as debtjeno

      from z_i_debt_je_no as a

      group by
              a.mandt,
              a.jeno;

  endmethod.
ENDCLASS.
