@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_9
  as select from ZV_EXPORTREG_1        as a

    inner join   I_BillingDocumentItem as b on b.BillingDocument = a.BillingDocument

    inner join   ZI_DELDASH_HDR        as c on  c.Delivery =  b.ReferenceSDDocument
                                            and c.Canind   <> 'X'
{
  a.BillingDocument,
  b.ReferenceSDDocument,
  max( c.Etadt )    as Etadt,
  max( c.Atadt )    as Etddt,
  max( c.Empretdt ) as Empretdt
}
group by
  a.BillingDocument,
  b.ReferenceSDDocument
// c.Etadt,
// c.Etddt,
// c.Empretdt
