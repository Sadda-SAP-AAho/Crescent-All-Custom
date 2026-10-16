@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Expense Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SHPEXPRPT_1 
  as select distinct from ZI_SERVICEENTRY

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

union

select distinct from ZI_POENTRY          as a
  left outer join    ZI_SHIPINVAMT_FINAL as b on  a.Commid            = b.Commid
                                              and a.ReferenceDocument = b.ServiceEntrySheet
                                              and a.Servicepo         = b.Servicepo
                                              and a.Servicepoline     = b.Servicepoline

{
  key a.Commid,
  key a.SlNo,
  key a.Type,
  key a.Item,
  key a.CC,
  key a.Commdate,
  key a.Profitcenter,
  key a.ProfitCenterName,
  key a.Expansetype,
  key a.Percontship,
  key a.Forwarder,
  key a.SupplierName,
  key a.SupplierInvoice,
  key a.ReferenceDocument,
  key a.SupplierMaterialNumber,
      a.countcontship,
      a.Amount,
      a.Currency,
      a.Exchangerate,
      a.Amountinr,
      a.Servicepo,
      a.Servicepoline,
      a.POAmt,
      a.POCurr,
      b.InvAmt,
      b.DocumentCurrency,
      a.MaterialGroup,
      a.PurchaseOrderItemText,
//      a.DocumentDate,
      a.PostingDate,
      a.CreatedByUser,
      a.LastChangedByUser,
//      a.SupplierPostingLineItemText,
      a.CostCenterCode,
      a.CostCenter,
      a.GLCode,
      a.GLName
}
