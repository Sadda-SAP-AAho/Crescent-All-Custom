@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SALESCUSTOMER

  as select from I_Customer    as a

    inner join   I_CountryText as b on  b.Language = $session.system_language
                                    and b.Country  = a.Country

    inner join   I_RegionText  as c on  c.Language = $session.system_language
                                    and c.Country  = a.Country
                                    and c.Region   = a.Region

{

      @Search.defaultSearchElement: true
  key a.Customer,

      @Search.defaultSearchElement: true
      a.CustomerFullName,
      a.SortField,
      a.StreetName,
      a.CityName,
      a.Region,
      c.RegionName,
      a.PostalCode,
      a.Country,
      b.CountryName,
      a.TelephoneNumber1,
      a.TelephoneNumber2

}
