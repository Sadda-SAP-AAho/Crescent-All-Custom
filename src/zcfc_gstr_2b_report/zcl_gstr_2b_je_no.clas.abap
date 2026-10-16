CLASS zcl_gstr_2b_je_no DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_gstr_2b_basic.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GSTR_2B_JE_NO IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING zi_gst_2b_basic.

    lt_item_3 = select * from zi_gst_2b_basic;

        lt_item = SELECT a.mandt as mandt, a.gstmonth, a.rowno, min(a.accountingdocument) as accountingdocument
                  from :lt_item_3 as a
                  group by a.mandt, a.gstmonth, a.rowno
                  order by gstmonth asc,rowno asc;

        return  select *
                from :lt_item
                order by gstmonth asc,rowno asc;

  endmethod.
ENDCLASS.
