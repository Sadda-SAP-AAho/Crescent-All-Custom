@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_22 
as select from ZI_FI_DEBTOR_RPT_6 as a
inner join I_BillingDocumentItem as b on b.BillingDocument = a.BillingDocument
inner join ZI_DELDASH_HDR as c on c.Delivery = b.ReferenceSDDocument and c.Canind <> 'X'
{
   a.arinv as BillingDocument,
   max( b.ReferenceSDDocument ) as ReferenceSDDocument
    
}
group by a.arinv
