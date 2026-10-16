CLASS zcl_je_details DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_je_details.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JE_DETAILS IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING z_i_jedetails.

    lt_item_3 = select * from z_i_jedetails;

        lt_item = SELECT a.mandt as mandt, a.compcode, a.fy, a.jeno, a.glaccount,
                         row_number() over ( partition by a.compcode, a.fy, a.jeno order by a.glaccount asc ) as rowno
                  from :lt_item_3 as a
                  where ( a.glaccount = '0048200100'
                        or a.glaccount = '0036400160'
                        or a.glaccount = '0036400130'
                        or a.glaccount = '0048401010' );
*                  group by a.mandt, a.compcode, a.fy, a.jeno, a.glaccount;

        RETURN  select *
                from :lt_item
                order by compcode asc,fy asc, jeno asc, glaccount asc, rowno asc;

  ENDMETHOD.
ENDCLASS.
