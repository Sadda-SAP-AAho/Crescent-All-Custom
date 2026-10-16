@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for PO Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_POENTRY
  as select distinct from ZI_POENTRY_BASIC as a

{
  key Commid,
  key SlNo,
  key Type,
  key Item,
  key CC,
  key Commdate,
  key Profitcenter,
  key ProfitCenterName,
  key Expansetype,
  key Percontship,
  key Forwarder,
  key SupplierName,
  key SupplierInvoice,
  key ReferenceDocument,
  key SupplierMaterialNumber,
      countcontship,
      Amount,
      Currency,
      Exchangerate,
      Amountinr,
      Servicepo,
      Servicepoline,
      POAmt,
      POCurr,
      InvAmt,
      DocumentCurrency,
      MaterialGroup,
      PurchaseOrderItemText,
//      DocumentDate,
      PostingDate,
      CreatedByUser,
      LastChangedByUser,
//      SupplierPostingLineItemText,
      CostCenterCode,
      CostCenter,
      GLCode,
      GLName
}
