@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_17
  as select from I_BillingDocumentItem as a
    inner join   ztmg_salesgrp         as b on b.salesgroup = a.SalesGroup
{
  a.BillingDocument,
  b.salesperson
}
where
  b.configdeprecationcode <> 'E'
group by
  a.BillingDocument,
  b.salesperson
