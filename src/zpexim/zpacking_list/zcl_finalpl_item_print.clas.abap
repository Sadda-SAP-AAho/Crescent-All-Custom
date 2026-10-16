CLASS zcl_finalpl_item_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data FOR TABLE FUNCTION ztbl_func_finalplitem.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FINALPL_ITEM_PRINT IMPLEMENTATION.


METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING ZCDS_FINALPLITEMDET.


   lt_item = select * from ZCDS_FINALPLITEMDET;



     RETURN  select *
       from :lt_item
     ORDER BY priority ASC, packqty DESC;

ENDMETHOD.
ENDCLASS.
