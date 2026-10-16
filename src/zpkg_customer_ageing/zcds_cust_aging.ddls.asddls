@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_CUST_AGING
  as select distinct from I_OperationalAcctgDocItem  as a
    inner join            I_BusinessPartner          as c    on c.BusinessPartner = a.Customer
    inner join            I_BusinessPartnerCustomer  as b    on b.BusinessPartner = a.Customer
    inner join            I_Customer                 as k    on k.Customer = a.Customer
    inner join            I_CustomerCompany          as d    on d.Customer = a.Customer
    inner join            I_JournalEntry             as e    on  e.AccountingDocument = a.AccountingDocument
                                                             and e.CompanyCode        = a.CompanyCode
                                                             and e.FiscalYear         = a.FiscalYear
  ////////    inner join            ZR_ZR_DZ_DOC_EXCLUDE                       as ee  on  ee.AccountingDocument = a.AccountingDocument
  ////////                                                                            and ee.CompanyCode        = a.CompanyCode
  ////////                                                                            and ee.FiscalYear         = a.FiscalYear
    left outer join       ZR_BUSINESS_PLACE01        as eef  on  eef.AccountingDocument = a.AccountingDocument
                                                             and eef.CompanyCode        = a.CompanyCode
                                                             and eef.FiscalYear         = a.FiscalYear
    left outer join       I_BusinessPlaceVH          as eeft on eef.businessplace = eeft.BusinessPlace
    left outer join       ZR_PROFITCENTER            as f    on  f.AccountingDocument = a.AccountingDocument
                                                             and f.CompanyCode        = a.CompanyCode
                                                             and f.FiscalYear         = a.FiscalYear
    left outer join       ZCDS_CUST_BILL_DOC         as g    on  g.AccountingDocument     = a.AccountingDocument
                                                             and g.CompanyCode            = a.CompanyCode
                                                             and g.FiscalYear             = a.FiscalYear
                                                             and g.AccountingDocumentItem = a.AccountingDocumentItem
    left outer join       I_CustomerAccountGroupText as h    on  h.CustomerAccountGroup = b.CustomerAccountGroup
                                                             and h.Language             = 'E'
    left outer join       ZR_SALESGROUP              as i    on i.BillingDocument = g.inv
    left outer join       ZTABL_SALENOTENO           as l    on l.billdoc = g.inv
  //    left outer join ZI_DELDASH_HDR                 as l on l.Delivery = i.ReferenceSDDocument
    left outer join       ZTABL_ORDER_NO             as j    on  j.companycode        = a.CompanyCode
                                                             and j.fiscalyear         = a.FiscalYear
                                                             and j.accountingdocument = a.AccountingDocument

    left outer join       I_RegionText               as m    on  m.Country  = k.Country
                                                             and m.Region   = k.Region
                                                             and m.Language = $session.system_language
    left outer join       I_BillingDocument          as o    on o.BillingDocument = i.BillingDocument
    left outer join       I_CustomerPaymentTermsText as n    on  n.CustomerPaymentTerms = o.CustomerPaymentTerms
                                                             and n.Language             = $session.system_language
    left outer join       I_JournalEntry             as p    on  a.AccountingDocument = p.AccountingDocument
                                                             and p.CompanyCode        = a.CompanyCode
                                                             and p.FiscalYear         = a.FiscalYear
    left outer join       ZI_FI_DEBTOR_RPT_7         as q    on  q.AccountingDocument = a.AccountingDocument
                                                             and q.FiscalYear         = a.FiscalYear
    left outer join       ZI_FI_DEBTOR_RPT_29        as r    on r.BillingDocument = i.BillingDocument
    left outer join       ZI_COMM_HED                as s    on s.Commid = i.BillingDocument
    left outer join       ZR_NETDUEDATE01            as t    on  t.AccountingDocument = a.AccountingDocument
                                                             and t.CompanyCode        = a.CompanyCode
                                                             and t.FiscalYear         = a.FiscalYear
    left outer join       ZR_COLLECTED_AMOUNT02      as u    on  u.InvoiceReference           = a.AccountingDocument
                                                             and u.CompanyCode                = a.CompanyCode
                                                             and u.InvoiceReferenceFiscalYear = a.FiscalYear
{
  h.AccountGroupName                                                           as type,
  a.CompanyCode,
  a.Customer,
  c.BusinessPartnerFullName,
  b.CustomerAccountGroup,
  i.SalesGroup,
  a.PaymentTerms,

  case
       when o.BillingDocumentType = 'G2'
       then cast('CN' as abap.char(10))
       when o.BillingDocumentType = 'L2'
       then cast('DN' as abap.char(10))
       when o.BillingDocumentType = 'CBRE'
       then cast('Service' as abap.char(10))
       when o.DistributionChannel = 'EX'
       then cast('Export' as abap.char(10))
       when o.DistributionChannel = 'ME'
       then cast('Merchant' as abap.char(10))
       when o.DistributionChannel = 'DO'
       then cast('Domestic' as abap.char(10))
       else 'Others'
       end                                                                     as InvoiceType,

  case when a.AccountingDocumentType = 'DR' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'RV' then a.OriginalReferenceDocument
           when a.AccountingDocumentType = 'UE' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'DG' then left(a.OriginalReferenceDocument, 10)
           else '' end                                                         as arinv,
  a.AccountingDocumentType,
  a.AccountingDocument,
  concat( concat( eef.businessplace, ' - ' ) , eeft.BusinessPlaceDescription ) as businessplace,
  a.AccountingDocumentItem,
  a.FiscalYear,
  a.SpecialGLCode,
  e.DocumentReferenceID,
  a.PostingDate,
  a.DocumentDate,
  t.netduedate,
  a.ClearingDate,
  a.CompanyCodeCurrency,
  a.TransactionCurrency                                                        as FunctionalCurrency,
  a.GLAccount,
  f.profitcenter,
  a.AssignmentReference,
  g.inv,
  j.orderno                                                                    as SALESDOCUMENT,
  k.TaxNumber3,
  l.salenoteno                                                                 as Salesnoteref,
  m.RegionName,
  n.CustomerPaymentTermsName                                                   as PaymentTerm,
  h.AccountGroupName                                                           as accountgroupname,
  a.DocumentItemText,
  r.Etadt,
  r.Etddt,
  s.Ladingdt,
  s.Docsentcustdt,
  s.Docpresentbnkdt,
  cast( case when a.TransactionCurrency = 'INR' then 1
    else case when a.AccountingDocumentType <> 'UE' then p.AbsoluteExchangeRate
              else abs( division( cast(a.AmountInCompanyCodeCurrency as abap.dec( 23, 5 )) , cast( a.AmountInTransactionCurrency as abap.dec( 23, 5 )) , 5 ) ) end
    end as abap.dec( 9,5 ) )                                                   as AbsoluteExchangeRate,
  //       case when a.AccountingDocumentType <> 'UE' then
  //      case when a.ClearingJournalEntry is not initial then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
  //           else cast(q.pamt * -1 as abap.dec(23,2)) end
  //      else
  //      case when a.ClearingJournalEntry is not initial then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
  //           else cast(q.pamt as abap.dec(23,2)) end
  //           end                                                                       as paidamt,
  //  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  u.AmountInCompanyCodeCurrency                                                as paidamt,
  //  @Semantics.amount.currencyCode: 'FunctionalCurrency'
  u.AmountInTransactionCurrency                                                as paidamt1,
  a.Reference3IDByBusinessPartner,
  cast( a.AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )                   as AmountInCompanyCodeCurrency,
  cast( a.AmountInTransactionCurrency  as abap.dec( 23, 2 ) )                  as AmountInFunctionalCurrency
}
where
      a.FinancialAccountType   =  'D'
  and a.SpecialGLCode          <> 'F'
  and a.AccountingDocumentType <> 'ZR'
  and a.AccountingDocumentType <> 'DZ'
  and a.AccountingDocumentType <> 'ZV'

union all select distinct from I_OperationalAcctgDocItem  as a
  inner join                   I_BusinessPartner          as c    on c.BusinessPartner = a.Customer
  inner join                   I_BusinessPartnerCustomer  as b    on b.BusinessPartner = a.Customer
  inner join                   I_Customer                 as k    on k.Customer = a.Customer
  inner join                   I_CustomerCompany          as d    on d.Customer = a.Customer
  inner join                   I_JournalEntry             as e    on  e.AccountingDocument = a.AccountingDocument
                                                                  and e.CompanyCode        = a.CompanyCode
                                                                  and e.FiscalYear         = a.FiscalYear
////////    inner join            ZR_ZR_DZ_DOC_EXCLUDE                       as ee  on  ee.AccountingDocument = a.AccountingDocument
////////                                                                            and ee.CompanyCode        = a.CompanyCode
////////                                                                            and ee.FiscalYear         = a.FiscalYear
  left outer join              ZR_BUSINESS_PLACE01        as eef  on  eef.AccountingDocument = a.AccountingDocument
                                                                  and eef.CompanyCode        = a.CompanyCode
                                                                  and eef.FiscalYear         = a.FiscalYear
  left outer join              I_BusinessPlaceVH          as eeft on eef.businessplace = eeft.BusinessPlace
  left outer join              ZR_PROFITCENTER            as f    on  f.AccountingDocument = a.AccountingDocument
                                                                  and f.CompanyCode        = a.CompanyCode
                                                                  and f.FiscalYear         = a.FiscalYear
  left outer join              ZCDS_CUST_BILL_DOC         as g    on  g.AccountingDocument     = a.AccountingDocument
                                                                  and g.CompanyCode            = a.CompanyCode
                                                                  and g.FiscalYear             = a.FiscalYear
                                                                  and g.AccountingDocumentItem = a.AccountingDocumentItem
  left outer join              I_CustomerAccountGroupText as h    on  h.CustomerAccountGroup = b.CustomerAccountGroup
                                                                  and h.Language             = 'E'
  left outer join              ZR_SALESGROUP              as i    on i.BillingDocument = g.inv
  left outer join              ZTABL_SALENOTENO           as l    on l.billdoc = g.inv
//    left outer join ZI_DELDASH_HDR                 as l on l.Delivery = i.ReferenceSDDocument
  left outer join              ZTABL_ORDER_NO             as j    on  j.companycode        = a.CompanyCode
                                                                  and j.fiscalyear         = a.FiscalYear
                                                                  and j.accountingdocument = a.AccountingDocument

  left outer join              I_RegionText               as m    on  m.Country  = k.Country
                                                                  and m.Region   = k.Region
                                                                  and m.Language = $session.system_language
  left outer join              I_BillingDocument          as o    on o.BillingDocument = i.BillingDocument
  left outer join              I_CustomerPaymentTermsText as n    on  n.CustomerPaymentTerms = o.CustomerPaymentTerms
                                                                  and n.Language             = $session.system_language
  left outer join              I_JournalEntry             as p    on  a.AccountingDocument = p.AccountingDocument
                                                                  and p.CompanyCode        = a.CompanyCode
                                                                  and p.FiscalYear         = a.FiscalYear
  left outer join              ZI_FI_DEBTOR_RPT_7         as q    on  q.AccountingDocument = a.AccountingDocument
                                                                  and q.FiscalYear         = a.FiscalYear
  left outer join              ZI_FI_DEBTOR_RPT_29        as r    on r.BillingDocument = i.BillingDocument
  left outer join              ZI_COMM_HED                as s    on s.Commid = i.BillingDocument
  left outer join              ZR_NETDUEDATE01            as t    on  t.AccountingDocument = a.AccountingDocument
                                                                  and t.CompanyCode        = a.CompanyCode
                                                                  and t.FiscalYear         = a.FiscalYear
  left outer join              ZR_COLLECTED_AMOUNT02      as u    on  u.InvoiceReference           = a.AccountingDocument
                                                                  and u.CompanyCode                = a.CompanyCode
                                                                  and u.InvoiceReferenceFiscalYear = a.FiscalYear
{
  h.AccountGroupName                                                           as type,
  a.CompanyCode,
  a.Customer,
  c.BusinessPartnerFullName,
  b.CustomerAccountGroup,
  i.SalesGroup,
  a.PaymentTerms,

  case
       when o.BillingDocumentType = 'G2'
       then cast('CN' as abap.char(10))
       when o.BillingDocumentType = 'L2'
       then cast('DN' as abap.char(10))
       when o.BillingDocumentType = 'CBRE'
       then cast('Service' as abap.char(10))
       when o.DistributionChannel = 'EX'
       then cast('Export' as abap.char(10))
       when o.DistributionChannel = 'ME'
       then cast('Merchant' as abap.char(10))
       when o.DistributionChannel = 'DO'
       then cast('Domestic' as abap.char(10))
       else 'Others'
       end                                                                     as InvoiceType,

  case when a.AccountingDocumentType = 'DR' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'RV' then a.OriginalReferenceDocument
           when a.AccountingDocumentType = 'UE' then left(a.OriginalReferenceDocument, 10)
           when a.AccountingDocumentType = 'DG' then left(a.OriginalReferenceDocument, 10)
           else '' end                                                         as arinv,
  a.AccountingDocumentType,
  a.AccountingDocument,
  concat( concat( eef.businessplace, ' - ' ) , eeft.BusinessPlaceDescription ) as businessplace,
  a.AccountingDocumentItem,
  a.FiscalYear,
  a.SpecialGLCode,
  e.DocumentReferenceID,
  a.PostingDate,
  a.DocumentDate,
  t.netduedate,
  a.ClearingDate,
  a.CompanyCodeCurrency,
  a.TransactionCurrency                                                        as FunctionalCurrency,
  a.GLAccount,
  f.profitcenter,
  a.AssignmentReference,
  g.inv,
  j.orderno                                                                    as SALESDOCUMENT,
  k.TaxNumber3,
  l.salenoteno                                                                 as Salesnoteref,
  m.RegionName,
  n.CustomerPaymentTermsName                                                   as PaymentTerm,
  h.AccountGroupName                                                           as accountgroupname,
  a.DocumentItemText,
  r.Etadt,
  r.Etddt,
  s.Ladingdt,
  s.Docsentcustdt,
  s.Docpresentbnkdt,
  cast( case when a.TransactionCurrency = 'INR' then 1
    else case when a.AccountingDocumentType <> 'UE' then p.AbsoluteExchangeRate
              else abs( division( cast(a.AmountInCompanyCodeCurrency as abap.dec( 23, 5 )) , cast( a.AmountInTransactionCurrency as abap.dec( 23, 5 )) , 5 ) ) end
    end as abap.dec( 9,5 ) )                                                   as AbsoluteExchangeRate,
  //       case when a.AccountingDocumentType <> 'UE' then
  //      case when a.ClearingJournalEntry is not initial then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
  //           else cast(q.pamt * -1 as abap.dec(23,2)) end
  //      else
  //      case when a.ClearingJournalEntry is not initial then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
  //           else cast(q.pamt as abap.dec(23,2)) end
  //           end                                                                       as paidamt,
  //  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  u.AmountInCompanyCodeCurrency                                                as paidamt,
  //  @Semantics.amount.currencyCode: 'FunctionalCurrency'
  u.AmountInTransactionCurrency                                                as paidamt1,
  a.Reference3IDByBusinessPartner,
  cast( a.AmountInCompanyCodeCurrency as abap.dec( 23, 2 ) )                   as AmountInCompanyCodeCurrency,
  cast( a.AmountInTransactionCurrency  as abap.dec( 23, 2 ) )                  as AmountInFunctionalCurrency
}
where
       a.FinancialAccountType   =  'D'
  and  a.SpecialGLCode          <> 'F'
  and(
       a.AccountingDocumentType =  'ZR'
    or a.AccountingDocumentType =  'DZ'
    or a.AccountingDocumentType =  'ZV'
  )
  and  a.ClearingJournalEntry   is initial
  and  a.InvoiceReference       is initial
//  and ee.AccountingDocument is initial
