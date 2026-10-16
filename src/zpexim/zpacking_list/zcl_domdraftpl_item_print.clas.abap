CLASS zcl_domdraftpl_item_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data FOR TABLE FUNCTION ztbl_fctn_domdraftplitm.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DOMDRAFTPL_ITEM_PRINT IMPLEMENTATION.


  METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING Z_I_DOMPACKLIST.


   lt_item = select * from Z_I_DOMPACKLIST ;



     RETURN  select *
       from :lt_item
     ORDER BY priority ASC, packqty DESC;


  ENDMETHOD.
ENDCLASS.
