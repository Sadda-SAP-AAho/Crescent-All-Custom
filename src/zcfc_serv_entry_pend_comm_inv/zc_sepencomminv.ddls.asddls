@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Entry Pending against Comm Invoice'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SEPENCOMMINV
  provider contract transactional_query
  as projection on ZI_SEPENCOMMINV
{
      @EndUserText.label: 'Commercial Invoice No'
  key Commercial_Invoice,
      @EndUserText.label: 'Commercial Invoice Date'
      Commercial_Invoice_Date,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Incoterms'
      Incoterms,
      @EndUserText.label: 'Container Size'
      Container_Size,
      @EndUserText.label: 'IsCancelled'
      CommercialInvoiceCancelled
}
