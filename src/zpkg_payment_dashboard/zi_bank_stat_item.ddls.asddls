@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_bank_stat_item 
 as select from ZV_PAYMENT_ITEM as a
 association to parent ZI_bank_stat_HEAD as _Head on  $projection.CompanyCode        = _Head.Companycode
                                                  and $projection.AccountingDocument = _Head.Accountingdoc
                                                  and $projection.FiscalYear         = _Head.Fiscalyear
{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.SupplierInvoice,
      a.AccountingDocumentType,
      a.SpecialGLCode,
      a.DocumentDate,
      a.PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.NetDueDate,
      a.PaymentTerms,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.WithholdingTaxAmount,
      a.PurchasingDocument,
      _Head
}
