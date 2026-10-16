@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_23 
as select from ZI_FI_DEBTOR_RPT_22 as a
inner join ZI_DELDASH_HDR as c on c.Delivery = a.ReferenceSDDocument and c.Canind <> 'X'
{
    a.BillingDocument,
    c.Cod
}
where c.Cod is not initial
