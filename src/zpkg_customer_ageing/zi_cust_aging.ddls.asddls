@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUST_AGING
  with parameters
    p_date   : zde_date_va,
    p_agdate : zde_agdate_va
  as select from    ZCDS_CUST_AGING     as a

    left outer join ZI_FI_DEBTOR_RPT_18 as j on j.arinv = a.arinv
    left outer join ZI_FI_DEBTOR_RPT_28 as z1 on z1.BillingDocument = a.arinv
    
{
  key a.type,
  key a.CompanyCode,
  key a.Customer,
  key a.BusinessPartnerFullName,
  key a.CustomerAccountGroup,
  key a.PaymentTerms,
  key a.AccountingDocumentType,
  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.FiscalYear,
      a.arinv,
      a.InvoiceType,
       case when z1.Division = 'PT' or z1.ProductGroup = 'Z001' or z1.SDDocumentReason = 'Z01' then 'Pattern'
      else ' ' end                                              as ispattern,
     
      a.businessplace,
      a.SalesGroup,
      a.SpecialGLCode,
      a.DocumentReferenceID,
      a.PostingDate,
      a.DocumentDate,
      a.netduedate,
      a.CompanyCodeCurrency,
      a.FunctionalCurrency,
      a.AmountInCompanyCodeCurrency,
      a.AmountInFunctionalCurrency,
      a.GLAccount,
      a.profitcenter,
      a.AssignmentReference,
      a.inv,
      a.SALESDOCUMENT,
      j.billingdocument                             as TaxNumber3,
      j.billingdocumentref                          as TaxNumberRef, //New column
      a.Salesnoteref,
      a.RegionName,
      a.PaymentTerm,
      a.Reference3IDByBusinessPartner,
      abs(a.AbsoluteExchangeRate)                   as exchangerate,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(a.paidamt as abap.dec( 23, 2 ) ) as paidamt,
//      @Semantics.amount.currencyCode: 'FunctionalCurrency'
      cast(a.paidamt1 as abap.dec(23,2) ) as paidamt1,
      a.accountgroupname,
      a.DocumentItemText,
      a.Etadt,
      a.Etddt,
      a.Ladingdt,
      a.Docsentcustdt,
      a.Docpresentbnkdt,
      cast( cast( case when $parameters.p_agdate = 'PD'
                 then cast( dats_days_between( a.PostingDate, $parameters.p_date ) as abap.int4 )
                 else cast( dats_days_between( a.netduedate, $parameters.p_date )  as abap.int4 ) end
           as abap.char( 11 ) ) as abap.dec( 11 ) ) as days_c
}
where
  (
       a.ClearingDate is initial
    or a.ClearingDate >= $parameters.p_date
  )
  and  a.PostingDate  <= $parameters.p_date
