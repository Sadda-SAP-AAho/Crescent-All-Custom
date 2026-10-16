@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Ageing'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_CUST_AGE
  with parameters
    @EndUserText.label: 'Currency'
    @AnalyticsDetails.query.variableSequence: 1
    //    @Consumption: { defaultValue: 'CCC' }
    p_cur    : zde_cur_va,
    //    @Environment.systemField: #SYSTEM_DATE
    @EndUserText.label: 'As On Date'
    @AnalyticsDetails.query.variableSequence: 2
    p_date   : zde_date_va,
    @EndUserText.label: 'Aging Date'
    @AnalyticsDetails.query.variableSequence: 3
    //    @Consumption.defaultValue: 'PD'
    p_agdate : zde_agdate_va,
    @EndUserText.label: 'Age 1'
    @AnalyticsDetails.query.variableSequence: 4
    //    @Consumption.defaultValue: '30'
    p_age1   : zdm_age_buc_va,
    @EndUserText.label: 'Age 2'
    @AnalyticsDetails.query.variableSequence: 5
    //    @Consumption.defaultValue: '60'
    p_age2   : zdm_age_buc_va,
    @EndUserText.label: 'Age 3'
    @AnalyticsDetails.query.variableSequence: 6
    //    @Consumption.defaultValue: '90'
    p_age3   : zdm_age_buc_va,
    @EndUserText.label: 'Age 4'
    @AnalyticsDetails.query.variableSequence: 7
    //    @Consumption.defaultValue: '120'
    p_age4   : zdm_age_buc_va,
    @EndUserText.label: 'Age 5'
    @AnalyticsDetails.query.variableSequence: 8
    //    @Consumption.defaultValue: '180'
    p_age5   : zdm_age_buc_va
  as select from ZI_CUST_AGE_F( p_cur  : $parameters.p_cur,  p_date : $parameters.p_date, p_agdate : $parameters.p_agdate,
                              p_age1 : $parameters.p_age1, p_age2 : $parameters.p_age2, p_age3   : $parameters.p_age3,
                              p_age4 : $parameters.p_age4, p_age5 : $parameters.p_age5  )
{
      @EndUserText.label: 'Type'
  key type,
      @EndUserText.label: 'Company Code'
  key CompanyCode,
      @EndUserText.label: 'Customer'
  key Customer,
      @EndUserText.label: 'Customer Name'
  key BusinessPartnerFullName,
  key CustomerAccountGroup,
  key PaymentTerms,
      @EndUserText.label: 'Journal Entry Type'
  key AccountingDocumentType,
      @EndUserText.label: 'Invoice No.'
  key AccountingDocument,
      @EndUserText.label: 'Line Item'
  key AccountingDocumentItem,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      @EndUserText.label: 'AR invoice Number'
      arinv,
      @EndUserText.label: 'Invoice Type'
      InvoiceType,
      @EndUserText.label: 'Is Pattern'
      ispattern,
      @EndUserText.label: 'Sales Head'
      SalesGroup,
      @EndUserText.label: 'Special G/L'
      SpecialGLCode,
      DocumentReferenceID,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Document Date'
      DocumentDate,
      @EndUserText.label: 'Net Due Date'
      netduedate,
      CompanyCodeCurrency,
      FunctionalCurrency,
      AmountInCompanyCodeCurrency,
      AmountInFunctionalCurrency,
      GLAccount,
      profitcenter,
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label: 'Collected Amount '
      paidamt,
      @EndUserText.label: 'Assignment'
      AssignmentReference,
      @EndUserText.label: 'Tax Invoice Number-DNT'
      TaxNumber3                                                                                             as inv,
      @EndUserText.label: 'SO Number'
      SALESDOCUMENT,
      @EndUserText.label: 'Tax Invoice Number'
      TaxNumber3,
      @EndUserText.label: 'Tax Invoice Ref No'
      TaxNumberRef,
      @EndUserText.label: 'Sale Note No'
      Salesnoteref,
      @EndUserText.label: 'Location'
      businessplace,
      @EndUserText.label: 'Payment Term as per SO'
      PaymentTerm,
      @EndUserText.label: 'Ageing Days'
      days_c,
      @EndUserText.label: 'Reference Key 3'
      Reference3IDByBusinessPartner,
      @EndUserText.label: 'Exchange Rate'
      exchangerate,
      @EndUserText.label: 'Transaction Currency'
      currency,
      @EndUserText.label: 'Total Invoice Amount'
      balamt,
      @EndUserText.label: 'Account Group'
      accountgroupname,
      @EndUserText.label: 'Item Text'
      DocumentItemText,
      @EndUserText.label: 'Tentative ETA Dt'
      Etadt,
      @EndUserText.label: 'Actual ETA dt'
      Etddt,
      @EndUserText.label: 'Bill of Lading Date'
      Ladingdt,
      @EndUserText.label: 'Document Sending Dt'
      Docsentcustdt,

      @EndUserText.label: 'Doc Presented on Bank Dt'
      Docpresentbnkdt,
      @EndUserText.label: 'Due Amount '
      cast( ( coalesce(balamt,0)  + coalesce(cast(paidamt as abap.dec( 21, 2 )),0)  )  as abap.dec( 23, 2 )) as dueamt01,
      @EndUserText.label: 'Not Due Amount '
      dueamt,
      @EndUserText.label: 'Bucket 1'
      ageb1,
      @EndUserText.label: 'Bucket 2'
      ageb2,
      @EndUserText.label: 'Bucket 3'
      ageb3,
      @EndUserText.label: 'Bucket 4'
      ageb4,
      @EndUserText.label: 'Bucket 5'
      ageb5,
      @EndUserText.label: 'Bucket 6'
      ageb6
}
