@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Wise Total Selling Expense'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSTTTLSELLEXP
  as select from ZI_CUSTSLEXPHDR as a
    inner join   ZI_CUSTSLEXPITM as b on a.Id = b.Id
{
  key a.Custcode,
      cast( sum( b.Rate ) as abap.dec(12,3) ) as ttlselexp
}

group by
  a.Custcode
