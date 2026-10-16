@AbapCatalog.sqlViewName: 'ZI_BILLINGDOC2_1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice F4 Help'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BILLINGDOCUMENTITEM_2_1
  as select distinct from ZI_BillingDocumentItem_3 as a
//    inner join      I_BillingDocumentBasic      as b on b.BillingDocument = a.BillingDocument

    inner join      I_BillingDocumentBasicStdVH as c on c.BillingDocument = a.BillingDocument and c.BillingDocumentType = 'F8'
{
  key a.BillingDocument,
      a.BillingDocumentDate,
      a.NetAmount,
      a.TransactionCurrency,
      a.PriceDetnExchangeRate,
      a.DutyDrawbackV,
      a.DutyDrawbackVfc,
      a.RoDTEPV,
      a.RoDTEPVfc,
      a.LocalCurrency
}

