@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Debtors Report'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_FI_DEBTOR_RPT_1
  as select from    ZI_FI_DEBTOR_RPT           as a

    left outer join ZI_COMM_HED                as b  on b.Commid = a.arinv

    left outer join I_BillingDocument          as c  on c.BillingDocument = a.arinv

    left outer join I_Customer                 as d  on d.Customer = a.Customer

    left outer join I_BusinessPartnerBank      as u  on c.PayerParty = u.BusinessPartner

    left outer join I_Bank_2                   as v  on u.BankNumber = v.BankInternalID

    left outer join ZI_FI_DEBTOR_RPT_16        as e  on e.billingdocument = a.arinv

    left outer join I_CustomerPaymentTermsText as g  on  g.CustomerPaymentTerms = c.CustomerPaymentTerms
                                                     and g.Language             = 'E'

    left outer join I_CustomerAccountGroupText as h  on  h.CustomerAccountGroup = d.CustomerAccountGroup
                                                     and h.Language             = 'E'

    left outer join I_RegionText               as i  on  i.Country  = d.Country
                                                     and i.Region   = d.Region
                                                     and i.Language = 'E'

    left outer join ZI_FI_DEBTOR_RPT_18        as j  on j.arinv = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_7         as k  on  k.AccountingDocument = a.AccountingDocument
                                                     and k.FiscalYear         = a.FiscalYear

    left outer join ZI_FI_DEBTOR_RPT_8         as l  on  l.AccountingDocument = a.AccountingDocument
                                                     and l.FiscalYear         = a.FiscalYear

    left outer join ZI_FI_DEBTOR_RPT_29        as z3 on z3.BillingDocument = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_10        as n  on  n.AccountingDocument     = a.AccountingDocument
                                                     and n.AccountingDocumentItem = a.AccountingDocumentItem
                                                     and n.FiscalYear             = a.FiscalYear

    left outer join ZI_FI_DEBTOR_RPT_11        as o  on  o.AccountingDocument     = a.AccountingDocument
                                                     and o.AccountingDocumentItem = a.AccountingDocumentItem
                                                     and o.FiscalYear             = a.FiscalYear

    left outer join ZI_FI_DEBTOR_RPT_12        as p  on  p.AccountingDocument     = a.AccountingDocument
                                                     and p.AccountingDocumentItem = a.AccountingDocumentItem
                                                     and p.FiscalYear             = a.FiscalYear

    left outer join ZI_FI_DEBTOR_RPT_5         as q  on q.billingdocument = a.arinv // j.BillingDocument

    left outer join ZI_FI_DEBTOR_RPT_14        as r  on r.BillingDocument = a.arinv // j.BillingDocument

    left outer join ZI_FI_DEBTOR_RPT_15        as s  on s.BillingDocument = a.arinv // j.BillingDocument

    left outer join ZI_FI_DEBTOR_RPT_19        as t  on t.billingdocument = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_23        as x  on x.BillingDocument = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_24        as y  on y.BillingDocument = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_25        as z  on z.BillingDocument = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_28        as z1 on z1.BillingDocument = a.arinv

    left outer join ZI_FI_DEBTOR_RPT_27        as z2 on z2.Customer = a.Customer

{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
  key a.arinv,
  key a.DocumentDate,
  key j.billingdocument                                                              as taxinv,
      j.billingdocumentref                                                           as taxinvref,
      a.DocumentReferenceID,
      z1.BillingDocumentType,
      a.AssignmentReference,
      case when z1.Division = 'PT' or z1.ProductGroup = 'Z001' or z1.SDDocumentReason = 'Z01' then 'PT'
      else a.AccountingDocumentType end                                              as AccountingDocumentType,
      case when z1.Division = 'PT' or z1.ProductGroup = 'Z001' or z1.SDDocumentReason = 'Z01' then 'Pattern'
      else a.AccountingDocumentTypeName end                                          as AccountingDocumentTypeName,
      b.Planingweek,
      b.Planingmonth,
      a.Customer,
      d.CustomerName,
      a.TransactionCurrency,
      e.Salesnoteref,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when a.AccountingDocumentType <> 'UE' then cast(a.AmountInTransactionCurrency as abap.dec(23,2))
      else cast(a.AmountInTransactionCurrency as abap.dec(23,2))  end                as AbsoluteAmountInTransacCrcy,

      cast( case when a.TransactionCurrency = 'INR' then 1
      else case when a.AccountingDocumentType <> 'UE' then a.AbsoluteExchangeRate
                else abs( division( a.AmountInCompanyCodeCurrency, a.AmountInTransactionCurrency, 5 ) ) end
      end as abap.dec( 9,5 ) )                                                       as AbsoluteExchangeRate,

      case when a.AccountingDocumentType <> 'UE' then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
      else cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))  end                as AmountInCompanyCodeCurrency,

      case when a.AccountingDocumentType <> 'UE' then
      case when a.ClearingJournalEntry is not initial then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
           else cast(k.pamt * -1 as abap.dec(23,2)) end
      else
      case when a.ClearingJournalEntry is not initial then cast(a.AmountInCompanyCodeCurrency as abap.dec(23,2))
           else cast(k.pamt as abap.dec(23,2)) end
           end                                                                       as paidamt,

      case when a.AccountingDocumentType <> 'UE' then
      case when a.ClearingJournalEntry is not initial then cast(a.AmountInTransactionCurrency as abap.dec(23,2))
           else cast(k.pamtfc * -1 as abap.dec(23,2)) end
      else
      case when a.ClearingJournalEntry is not initial then cast(a.AmountInTransactionCurrency as abap.dec(23,2))
           else cast(k.pamtfc as abap.dec(23,2)) end
      end                                                                            as paidamtfc,

      b.Ladingno,
      b.Ladingdt,
      q.shippingbill,
      r.shippingbilldate,
      s.fobvalue,
      z3.Empretdt,
      v.BankName,
      b.Bankrefno,
      b.Docpresentbnkdt,
      n.Swiftdate,
      n.inwarddate,
      b.Paymentprocess,
      a.NetDueDate,
      c.IncotermsClassification,

      case when a.ClearingDate is not initial then a.ClearingDate
           else l.postingdate end                                                    as recondt,

      b.Billcloseflag,
      g.CustomerPaymentTermsName,
      p.Inwardrecordstatus,
      o.inwardamt,
      n.inwarddate                                                                   as inrecdt,
      b.Docsentcustdt,
      z3.Etadt,
      z3.Etddt,
      z.Conliftdt,
      z.Empretdt                                                                     as conretdt,
      x.Cod,
      y.hsncode,
      case
      when a.AccountingDocumentType = 'UE' then a.DocumentItemText
      else
      case when t.salesperson is null then z2.salesperson else t.salesperson end end as salesperson,
      h.AccountGroupName,
      a.BusinessPlace,
      i.RegionName,
      d.TaxNumber3,
      b.Ebrcno,
      b.Blrcvdt                                                                      as Drftblrcvdt,
      b.Irmno
}
