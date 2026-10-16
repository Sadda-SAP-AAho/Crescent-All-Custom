CLASS zcl_polt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztf_po_lt.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_POLT IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                             FOR HDB
                             LANGUAGE SQLSCRIPT
                             OPTIONS READ-ONLY
                             USING Z_I_PO_LT.

    lt_item = select a.mandt, a.purchaseorder, a.purchaseorderitem, a.plainlongtext
                from Z_I_PO_LT as a
                where a.language = 'E' and a.textobjecttype = 'F01';

    RETURN  select *
            from :lt_item
            order by purchaseorder asc, purchaseorderitem asc;

  ENDMETHOD.
ENDCLASS.
