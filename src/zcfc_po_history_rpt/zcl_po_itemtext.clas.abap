CLASS zcl_po_itemtext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_po_item_text.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PO_ITEMTEXT IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                       FOR HDB
                       LANGUAGE SQLSCRIPT
                       OPTIONS READ-ONLY
                       USING z_i_poitmtxt.

    RETURN

      select
        a.mandt             as mandt,
        a.purchaseorder     as purchaseorder,
        a.purchaseorderitem as purchaseorderitem,
        a.textobjecttype    as textobjecttype,
        a.language          as language,

        cast(
      replace(
          a.plainlongtext,
          nchar(2),
          ' '
      ) as nvarchar(254)
  ) as plainlongtext

      from z_i_poitmtxt as a;

  endmethod.
ENDCLASS.
