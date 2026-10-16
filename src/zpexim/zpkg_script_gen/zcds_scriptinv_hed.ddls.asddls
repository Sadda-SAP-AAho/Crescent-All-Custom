@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Script Invoice Header Details'
define root view entity ZCDS_SCRIPTINV_HED
  as select distinct from    zi_scriptsl_hdr          as i
    inner join      zdt_mm_pc_tmg             as f on  i.companycode = f.cocode
                                                   and f.plant = '1000'
    inner join      I_Customer                as a on a.Customer = i.customer
    left outer join I_CountryText             as c on c.Country = a.Country
                                                       and c.Language = 'E'                                            
    left outer join ZCDS_BANK_DETAIL          as b on b.BusinessPartner = i.customer
   
{
      key i.scriptsalesno,
      i.accdocno,
      i.scriptsalesdate,
      a.CustomerName,
      a.StreetName as cusstreet,
      a.CityName   as cuscityname,
      c.CountryName as cuscoun,
      a.PostalCode as cuspostcode,  
      b.StreetName as bnkstreet,
      b.CityName as bnkcityname,
      b.BankName,
      b.SWIFTCode,
      b.bankaccno,   
      f.caddress1,
      f.caddress2,
      f.caddress3,
      f.name,
      f.gstin,
      f.cmobile,
      f.cemail,
      f.var6,
      a.TaxNumber3,
      substring(a.TaxNumber3,3,10) as cuspanno
}
