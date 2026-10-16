@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'License Master'
define view entity ZI_LicenseMasterTP_4

//  as select from    ZR_LicenceMasterTP as a
  as select from    ZR_LICENCE_HDR as a

//    left outer join zim_boe_lic        as b on b.licencenumber = a.Licencenumber
    left outer join zdt_boe_lic        as b on b.licenceint = a.Licenceint
{
  key a.Licenceint as Licencenumber,
      a.Licenceext as Licencenumberext,
      a.Licencetype,
      a.Licencedate
//      @Semantics.amount.currencyCode: 'Currency'
//      a.ImportvalueusdV,
//      b.fob_fc             as Currency,
//      @Semantics.amount.currencyCode: 'Currency'
//      sum( b.usageamount ) as Usageamountfc
}

//where
//      a.Importvalidfrom <= $session.system_date
//  and a.Importvalidto   >= $session.system_date

group by
//  a.Licencenumber,
  a.Licenceint,
  a.Licenceext,
  a.Licencetype,
  a.Licencedate
//  a.ImportvalueusdV,
//  b.fob_fc
