@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_5

  as select from    I_BillingDocument as a

    inner join      ZV_COSTINGPL_6    as b on a.BillingDocument = b.BillingDocument

    left outer join ZV_COSTINGPL_4    as m on m.BillingDocument = a.BillingDocument

{

  key a.BillingDocument,
  key b.BillingDocumentItem,
      b.ItemNetWeight,
      m.TotalNetWeight,
      case when m.TotalNetWeight > 0 then division( b.ItemNetWeight, m.TotalNetWeight, 5 ) else 0 end as WeightRatio

}
