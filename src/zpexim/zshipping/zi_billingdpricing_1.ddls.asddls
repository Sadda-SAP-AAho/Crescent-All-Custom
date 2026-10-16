@AbapCatalog.sqlViewName: 'ZIBILLINGDPRIC1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Docment Pricing'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_BillingDPricing_1

  as select from I_BillingDocumentItemPrcgElmnt
{
  key BillingDocument,
  key BillingDocumentItem,
  key ConditionType,
      case when ConditionType = 'ZRDT' then ConditionAmount end    as ZROD_V,
      case when ConditionType = 'ZRDT' then ConditionRateValue end as ZROD_R,
      case when ConditionType = 'ZDDW' then ConditionAmount end    as ZDTB_V,
      case when ConditionType = 'ZDDW' then ConditionRateValue end as ZDTB_R
}

where
     ConditionType = 'ZDDW'
  or ConditionType = 'ZRDT'
