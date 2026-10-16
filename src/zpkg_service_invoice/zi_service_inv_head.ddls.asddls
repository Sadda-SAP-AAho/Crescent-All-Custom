@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface ~ Service Invoice header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SERVICE_INV_HEAD
  as select distinct from I_JournalEntry              as a
    inner join            I_IN_BusinessPlaceTaxDetail as b on a.Branch = b.BusinessPlace
    inner join            zdt_mm_pc_tmg               as c on  a.CompanyCode = c.cocode
                                                           and c.plant       = '1000'
    inner join            I_OperationalAcctgDocItem   as d on  a.AccountingDocument = d.AccountingDocument
                                                           and a.FiscalYear         = d.FiscalYear
                                                           and d.Customer           is not initial
    inner join            I_Customer                  as e on d.Customer = e.Customer
  //   left outer join       ZCDS_CUSTBANK               as f on f.PayerParty = d.Customer
    left outer join       I_BusinessPartnerBank       as f on d.Customer = f.BusinessPartner
    left outer join       I_Bank_2                    as g on f.BankNumber = g.BankInternalID

  //                                                           and f.BillingDocument = d.OriginalReferenceDocument
  composition [0..*] of ZI_SERVICE_INV_ITEM as _Item
{
  key   a.AccountingDocument                         as InvoiceNo,
  key   a.FiscalYear,
        a.DocumentReferenceID                        as InvoiceReference,
        a.DocumentDate                               as InvoiceDate,
        b.IN_GSTIdentificationNumber                 as InvoiceGSTIN,
        c.name                                       as CompanyName,
        c.caddress1                                  as Address1,
        c.caddress2                                  as Address2,
        a.TransactionCurrency                        as Currency,
        d.Customer                                   as Customer,
        e.CustomerName,
        e.StreetName                                 as CustomerStreetName,
        e.PostalCode                                 as CustomerPostalCode,
        e.CityName                                   as CustomerCity,
        e.Country                                    as CustomerCountry,
        e.TaxNumber3                                 as CustomerGSTIN,
        concat(g.StreetName,concat(' ,',g.CityName)) as Bankdetails,
        f.BankName                                   as BankName,
        'X'                                          as tprint,
        _Item


}

where
  a.AccountingDocumentType = 'DR'
