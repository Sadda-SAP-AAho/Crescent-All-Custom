@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumtion View for NOSTRO Head'
define root view entity ZC_NOSTRO_hed
  provider contract transactional_query
  as projection on ZI_NOSTRO_hed

{
      @EndUserText.label: 'ID'
  key Id,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Company Code'
      Companycode,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Customer No'
      Customer,
      @EndUserText.label: 'Customer Name'
      Customername,
      @EndUserText.label: 'Fiscal Year'
      fiscalyear,
      @EndUserText.label: 'RefDocument Number'
      @Search.defaultSearchElement: true
      refaccdocno,
      @EndUserText.label: 'Account Document Number'
      @Search.defaultSearchElement: true
      Invoiceno,
      @EndUserText.label: 'Posting Date'
      Postingdate,
      /* Associations */
      _Item  : redirected to composition child ZC_NOSTRO_Itm,
      _Item2 : redirected to composition child ZC_NOSTRO_ITM2
}
