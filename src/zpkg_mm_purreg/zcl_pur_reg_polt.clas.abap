CLASS zcl_pur_reg_polt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztf_purchase_reg_13.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PUR_REG_POLT IMPLEMENTATION.


METHOD get_data BY DATABASE FUNCTION
                           FOR HDB
                           LANGUAGE SQLSCRIPT
                           OPTIONS READ-ONLY
                           USING Z_I_PURCHASE_REG_13.

    lt_item = select a.mandt, a.purchaseorder, a.purchaseorderitem, a.plainlongtext
                from Z_I_PURCHASE_REG_13 as a
                WHERE a.language = 'E' and a.textobjecttype = 'F01';

    return  select *
            from :lt_item
            order by purchaseorder asc, purchaseorderitem asc;

  endmethod.
ENDCLASS.
