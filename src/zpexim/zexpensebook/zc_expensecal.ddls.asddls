@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@Search.searchable: true
@EndUserText.label: 'Expense Calculation'
define root view entity ZC_EXPENSECAL
  provider contract transactional_query
  as projection on ZI_EXPENSECAL
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Commercial Invoice'
      Commid,
      @EndUserText.label: 'Commercial Invoice Date'
      Commdate,
      @EndUserText.label: 'Service PO'
      servicepobt,
      @EndUserText.label: 'POupdate'
      poupd,
      @EndUserText.label: 'TaxCode'
      Taxcode,
      @EndUserText.label: 'Profitcenter'
      Profitcenter,
      /* Associations */
      _item : redirected to composition child ZC_EXPENSECAL_I
}
