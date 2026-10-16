CLASS zcl_supp_last_po DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_supplier_last_po.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SUPP_LAST_PO IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                             FOR HDB
                             LANGUAGE SQLSCRIPT
                             OPTIONS READ-ONLY
                             USING z_i_supplier_last_po.

    lt_item_3 = select * from z_i_supplier_last_po;

    lt_item = SELECT mandt,
                     supplier AS suppcode,
                     purchaseorder AS pono,
                     purchaseorderdate AS podate,
                     createdbyuser AS createby
              FROM
                  (
                    select a.*,
                    row_number() over ( partition by supplier order by purchaseorderdate desc, purchaseorder desc ) as rn
                    from :lt_item_3 as a
                  )
              where rn = 1;

        return  select *
                from :lt_item
                order by suppcode asc;

  endmethod.
ENDCLASS.
