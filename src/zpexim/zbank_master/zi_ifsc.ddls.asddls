@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ifsc cds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_ifsc
  as select distinct from I_HouseBankAccountLinkage as a
    left outer join       I_Bank_2                  as b on b.BankInternalID = a.BankInternalID
{ key a.HouseBank,
  key cast( a.BankInternalID as abap.char( 15 ) )                    as BankNumber,
      a.BankName,
      concat_with_space(b.ShortStreetName , b.ShortCityName , 1) as address,
      b.Branch
}
