@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '2 of ZI_LicenseMasterTP'
define view entity ZI_LicenseMasterTP_2

  as select from    ZR_LicenceMasterTP as a

    left outer join zex_shipbill_lic   as b on b.licencenumber = a.Licencenumber
{
  key a.Licencenumber,
      a.Licencetype,
      a.Licencedate,
      @Semantics.amount.currencyCode: 'Currency'
      a.ExportvalueusdV,
      b.fob_fc             as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      sum( b.usageamount ) as Usageamountfc
}

where
  
  a.Exportvalidfrom <= $session.system_date and
  a.Exportvalidto >= $session.system_date  

group by
  a.Licencenumber,
  a.Licencetype,
  a.Licencedate,
  a.ExportvalueusdV,
  b.fob_fc
