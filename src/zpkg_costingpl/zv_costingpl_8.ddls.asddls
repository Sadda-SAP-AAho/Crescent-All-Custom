@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_8

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from I_OperationalAcctgDocItem as a

    inner join   zdt_cost_glpl             as b on  b.gl     = a.GLAccount
                                                and b.gltype = 10
{

  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
      a.FiscalPeriod,
      a.AssignmentReference,
      a.PostingDate,
      a.GLAccount,
      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.AmountInCompanyCodeCurrency

}

where
      a.PostingDate >= $parameters.p_begin
  and a.PostingDate <= $parameters.p_end
