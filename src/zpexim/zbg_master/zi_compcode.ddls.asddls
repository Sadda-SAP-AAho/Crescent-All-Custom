@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Code F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMPCODE
  as select from    I_CompanyCode as a
    left outer join zdb_bgaddress as b on b.bukrs = a.CompanyCode
{
  key a.CompanyCode,
      a.CompanyCodeName,
      a.CityName,
      a.Country,
      b.bukrs    as Bukrs,
      b.street   as Street,
      b.state    as State,
      b.postcode as Postcode

}
