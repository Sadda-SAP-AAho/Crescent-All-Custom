@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Pattern Invoice Header Details'
define root view entity ZCDS_PATINVHED
  as select from    zi_taxhdr                 as i
    left outer join I_BillingDocument         as a on a.BillingDocument = i.Billingdoc
    left outer join I_BillingDocumentItem     as h on  h.BillingDocument         =  a.BillingDocument
                                                   and h.BillingDocumentType     =  'F2'
                                                   and a.AccountingPostingStatus <> 'E'
    inner join      ZCDS_PLANT                as e on i.Billingdoc = e.BillingDocument
    inner join      zdt_mm_pc_tmg             as f on  e.CompanyCode = f.cocode
                                                   and e.Plant       = f.plant
    left outer join ZCDS_BILL_CUSDET          as z on  z.BillingDocument = a.BillingDocument
                                                   and z.customer        = h.BillToParty
                                                   and z.pfunc = 'RE'
    left outer join ZCDS_CUSTBANK             as y on y.BillingDocument = a.BillingDocument
                                                   and y.PayerParty = h.PayerParty 
{

  key a.BillingDocument,
      a.DocumentReferenceID,
      a.BillingDocumentDate,
      f.caddress1,
      f.caddress2,
      f.caddress3,
      f.name,
      f.gstin,
      f.cmobile,
      f.var6,
      z.cusname                    as customername,
      z.address                    as address,
      y.BankName,
      y.CityName,
      y.StreetName
}
