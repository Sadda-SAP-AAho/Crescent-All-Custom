CLASS zcl_lcdetails DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data FOR TABLE FUNCTION ztbl_fctn_lcdetails.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LCDETAILS IMPLEMENTATION.


  METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING zcds_lcdetails.


   lt_item = select ( 'SESSION_CONTEXT' ) AS mandt,a.billingdocument,a.lc_refnr,a.version, a.lc_appl,a.lc_open_dt,a.banka  from zcds_lcdetails as a ;



     RETURN  select *
       from :lt_item
     ORDER BY version DESC;


  ENDMETHOD.
ENDCLASS.
