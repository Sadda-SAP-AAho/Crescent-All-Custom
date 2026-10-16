CLASS zcl_draftpl_item_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data FOR TABLE FUNCTION ztbl_fctn_draftplitm.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DRAFTPL_ITEM_PRINT IMPLEMENTATION.


  METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING Z_I_DRAFT_PACKLIST ZI_MATFLD ZCDS_DELIVERY ZCDS_SALESORDER.


lt_item =
  select
    session_context('CDS_CLIENT') as mandt,
    a.DeliveryDocument,
    a.Revision,
    a.DeliveryDocumentItem,
    a.Packqty,
    a.Packmattyp,
    a.Priority,
    a.Wtunit,
    a.ConsumptionTaxCtrlCode,
    a.ConsumptionTaxCtrlCodeText1,
    a.Eachnetwt,
    a.Qty,
    a.Matnr,
    a.Meins,
    a.UOM,
    a.Netwt,
    a.Growt,
    a.Eachgrowt,
    a.PurchaseOrderByCustomer,
    d.underlyingpurchaseorderitem as PURCHASEORDERITEM,
    a.MaterialByCustomer,
    b.Matlngtxt
  from Z_I_DRAFT_PACKLIST as a
  left outer join ZI_MATFLD as b
    on a.matnr = b.product
    left outer join ZCDS_DELIVERY
    as c on a.deliverydocument = c.deliverydocument
    and a.deliverydocumentitem = c.deliverydocumentitem
    left outer join ZCDS_SALESORDER
    as d on c.referencesddocument = d.salesdocument
    and c.referencesddocumentitem = d.salesdocumentitem
    ;




     RETURN  select *
       from :lt_item
     ORDER BY priority ASC, packqty DESC;


  ENDMETHOD.
ENDCLASS.
