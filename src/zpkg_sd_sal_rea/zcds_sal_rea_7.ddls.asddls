@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Expense Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_7 
as select from ZI_CUSTSLEXPHDR as a
inner join ZI_CUSTSLEXPITM as b on b.Id = a.Id
{
    a.Custcode,
    a.Expcode,
    b.Datefrom,
    b.Dateto,
    b.Rate
}
