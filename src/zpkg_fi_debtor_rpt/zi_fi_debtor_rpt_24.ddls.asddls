@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_24 
as select from ZI_FI_DEBTOR_RPT_22 as a
inner join ZI_DELDASH_HDR as c on c.Delivery = a.ReferenceSDDocument and c.Canind <> 'X'
inner join I_DeliveryDocumentItem as d on d.DeliveryDocument = a.ReferenceSDDocument
inner join I_ProductPlantBasic as e on e.Product = d.Product and e.Plant = d.Plant
{
    a.BillingDocument,
    max( e.ConsumptionTaxCtrlCode ) as hsncode
}
group by
a.BillingDocument
