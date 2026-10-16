@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Shipping Exp Rpt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SHPEXPRPT
  as select distinct from ZI_SHPEXPRPT_1  as a
    inner join            ZI_POSTINGADATE as b on  a.Commid                 = b.Commid
                                               and a.ReferenceDocument      = b.ReferenceDocument
                                               and a.SupplierMaterialNumber = b.SupplierMaterialNumber
                                               and a.Servicepo              = b.Servicepo
                                               and a.Servicepoline          = b.Servicepoline


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
      a.InvAmt,
      a.DocumentCurrency,
      a.MaterialGroup,
      a.PurchaseOrderItemText,
      b.PostingDate,
      a.CreatedByUser,
      a.LastChangedByUser,
      //      SupplierPostingLineItemText,
      a.CostCenterCode,
      a.CostCenter,
      a.GLCode,
      a.GLName
}
