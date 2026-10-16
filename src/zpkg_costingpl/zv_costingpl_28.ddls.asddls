@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_28

  as select from I_BillingDocument              as a

    inner join   I_BillingDocumentItem          as b on a.BillingDocument = b.BillingDocument

    inner join   I_BillingDocumentItemPrcgElmnt as c on  c.BillingDocument     = a.BillingDocument
                                                     and c.BillingDocumentItem = b.BillingDocumentItem
{

  key a.BillingDocument,
  key b.BillingDocumentItem,
      sum( case when c.ConditionType = 'ZXIV' then cast( c.ConditionAmount as abap.dec( 21,2 ) ) else 0 end ) as FreightRAmount

}

group by
  a.BillingDocument,
  b.BillingDocumentItem
