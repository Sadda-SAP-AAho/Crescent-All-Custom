@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Item'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define view entity ZC_PO_ITEM as projection on ZI_PO_ITEM
{
    key Uuid,
    key Itemuuid,
     @EndUserText.label: 'Vendor'
    Vendor,
     @EndUserText.label: 'Purchaser'
    Purchaser,
     @EndUserText.label: 'Document Number'
    Docnum,
     @EndUserText.label: 'Document Item'
    Docitem,
     @EndUserText.label: 'Item Code'
    Itemcode,
     @EndUserText.label: 'Description'
    Description,
     @EndUserText.label: 'Quantity'
    Qty,
     @EndUserText.label: 'Price'
    Price,
     @EndUserText.label: 'Discount'
    Discount,
     @EndUserText.label: 'Tax Code'
    Taxcode,
     @EndUserText.label: 'Quotation reference'
    Quotreference,
     @EndUserText.label: 'Quotation Date'
    Quotdate,
     @EndUserText.label: 'Delivery Date'
    Deldate,
     @EndUserText.label: 'Terms'
    Zterm,
     @EndUserText.label: 'Incoterms'
    Inco1,
     @EndUserText.label: 'Incoterms Location'
    Incoloc,
     @EndUserText.label: 'Validity'
    Validity,
     @EndUserText.label: 'Pnf Type'
    Pnftype,
     @EndUserText.label: 'Pnf'
    Pnf,
     @EndUserText.label: 'Quote Remark'
    Quoteremark,
     @EndUserText.label: 'General Remark'
    Genremark,
     @EndUserText.label: 'Currency'
    Currency,
     @EndUserText.label: 'Transport Cost Type'
    Transcosttype,
     @EndUserText.label: 'Transport'
    Transport,
     @EndUserText.label: 'Other Amt'
    Othersamt,
     @EndUserText.label: 'Created On'
    Createdon,
     @EndUserText.label: 'Creation Date'
    Createdat,
    _head: redirected to parent ZC_PO_HEAD
}
