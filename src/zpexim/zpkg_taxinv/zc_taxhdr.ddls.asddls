@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Tax Invoice Dashboard'
define root view entity ZC_TAXHDR
  provider contract transactional_query
  as projection on zi_taxhdr
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Invoice No'
      @Search.defaultSearchElement: true
  key Billingdoc,
      @EndUserText.label: 'Delivery No'
      Delivery,
      @EndUserText.label: 'Invoice Type'
      Invtype,
      @EndUserText.label: 'Invoice Date'
      Invdate,
      @EndUserText.label: 'Invoice Created By'
      Invcreatedby,
      @EndUserText.label: 'Tax Invoice IGST'
      Taxigstprint,
      @EndUserText.label: 'Tax Invoice LUT'
      Taxlutprint,
      @EndUserText.label: 'Tax Invoice Domestic'
      Taxdomprint,
      @EndUserText.label: 'Proforma Invoice'
      Proinvprint,
      @EndUserText.label: 'Pattern Invoice'
      Patinvprint,
      @EndUserText.label: 'Sample Customs Invoice'
      Samcusprint,
      Flag,
      @EndUserText.label: 'Text Field 1'
      Textfield1,
      @EndUserText.label: 'Text Field 2'
      Textfield2,
      @EndUserText.label: 'Text Field 3'
      Textfield3,
      @EndUserText.label: 'Text Field 4'
      Textfield4
}
