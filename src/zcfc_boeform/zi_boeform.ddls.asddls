@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For BOE Form'
define root view entity ZI_BOEFORM
  as select from    I_BillingDocument      as a
    inner join      I_BillingDocumentBasic as b on a.BillingDocument = b.BillingDocument
    left outer join ZI_COMM_HED            as c on a.BillingDocument = c.Commid
    left outer join I_Customer             as d on c.Customercode = d.Customer
    left outer join I_CountryText          as e on  d.Country  = e.Country
                                                and e.Language = 'E'
    left outer join I_PaymentTermsText     as f on  a.CustomerPaymentTerms = f.PaymentTerms
                                                and f.Language             = 'E'
{
  key a.BillingDocument                                         as BillNo,
      a.BillingDocumentDate                                     as BillDate,
      c.Boeddt,
      a.TransactionCurrency                                     as Currency,
      a.TotalNetAmount                                          as NetAmt,
      f.PaymentTermsName                                        as TOP,
      concat( concat( c.Payrecvbank, ',' ), c.Payrecvbankadrc ) as BankAddr,
      d.BPCustomerName                                          as CustName,
      d.StreetName,
      d.PostalCode,
      d.CityName,
      e.CountryName                                             as Country,
      cast('' as abap.char(1))                                  as printflag1,
      cast('' as abap.char(1))                                  as printflag2,
      cast('' as abap.char(1))                                  as flag
}
