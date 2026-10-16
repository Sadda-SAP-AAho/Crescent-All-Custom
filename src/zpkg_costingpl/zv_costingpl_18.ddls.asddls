@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_18

  with parameters
    p_begin : begda,
    p_end   : endda

  //as select from I_OperationalAcctgDocItem as a
  as select from I_JournalEntryItem as a

    inner join   zdt_cost_glpl             as d on  d.gl     = a.GLAccount
                                                and d.gltype = 14

    inner join   zdt_costingpl_pc          as e on e.prctr = a.ProfitCenter

{

  key a.AccountingDocument,
  key a.AccountingDocumentItem,
  key a.FiscalYear,
      a.CompanyCode,
      a.GLAccount,
      a.AssignmentReference,
      d.gltype,
      e.prctr,
      e.prctrclub,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency

}

where
        a.Ledger = '0L'
        
  and(
        a.PostingDate        >= $parameters.p_begin
    and a.PostingDate        <= $parameters.p_end
  )
