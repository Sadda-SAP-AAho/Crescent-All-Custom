@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor Aging'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_VEND_AGING 
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
as select from ZI_VEND_AGING_F( p_cur  : $parameters.p_cur,  p_date : $parameters.p_date, p_agdate : $parameters.p_agdate,
                                p_age1 : $parameters.p_age1, p_age2 : $parameters.p_age2, p_age3   : $parameters.p_age3,
                                p_age4 : $parameters.p_age4, p_age5 : $parameters.p_age5  ) 
{
    @EndUserText.label: 'Company Code'
    @Consumption.filter: { mandatory: true }
    key CompanyCode,
    @EndUserText.label: 'Supplier Code'
    key Supplier,
    @EndUserText.label: 'Supplier Name'
    key BusinessPartnerFullName,
    @EndUserText.label: 'Vendor Group'
    key SupplierAccountGroup,
    @EndUserText.label: 'Payment Terms'
    key PaymentTerms,
    @EndUserText.label: 'Invoice Type'
    key AccountingDocumentType,
    @EndUserText.label: 'Accounting document'
    key AccountingDocument,
    @EndUserText.label: 'Line Item'
    key AccountingDocumentItem,
    @EndUserText.label: 'Fiscal Year'
    key FiscalYear,
    @EndUserText.label: 'MSME Indicator'
    MinorityGroup,
    @EndUserText.label: 'Special GL Indicator'
    SpecialGLCode,
    @EndUserText.label: 'Document Reference'
    DocumentReferenceID,
    @EndUserText.label: 'Posting Date'
    PostingDate,
    @EndUserText.label: 'Invoice Date'
    DocumentDate,
    @EndUserText.label: 'Net Due Date'
    NetDueDate,
    @EndUserText.label: 'GL Account'
    GLAccount,
    @EndUserText.label: 'Profit Center'
    ProfitCenter,
    @EndUserText.label: 'Currency'
    currency,
    @EndUserText.label: 'Days'
    @Aggregation.default: #SUM
    days_c,
    @EndUserText.label: 'Total Balance amount Due'
    @Aggregation.default: #SUM
    balamt,
    @EndUserText.label: 'Not Due'
    @Aggregation.default : #SUM
    dueamt,
    @EndUserText.label: 'Bucket 1'
    @Aggregation.default: #SUM
    ageb1,
    @EndUserText.label: 'Bucket 2'
    @Aggregation.default: #SUM
    ageb2,
    @EndUserText.label: 'Bucket 3'
    @Aggregation.default: #SUM
    ageb3,
    @EndUserText.label: 'Bucket 4'
    @Aggregation.default: #SUM
    ageb4,
    @EndUserText.label: 'Bucket 5'
    @Aggregation.default: #SUM
    ageb5,
    @EndUserText.label: 'Bucket 6'
    @Aggregation.default: #SUM
    ageb6
}
