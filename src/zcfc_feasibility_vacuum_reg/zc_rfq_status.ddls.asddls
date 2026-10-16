@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'RFQ Status'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_RFQ_STATUS
  provider contract transactional_query
  as projection on ZI_RFQ_STATUS
{
      @EndUserText.label: 'ID'
      @UI.hidden: true
  key Id,
      @EndUserText.label: 'RFQ No'
      Rfqno,
      @EndUserText.label: 'RFQ Date'
      Rfqdate,
      @EndUserText.label: 'Marketing Person'
      Marketing_Person,
      @EndUserText.label: 'Customer Code'
      Customer_Code,
      @EndUserText.label: 'Customer Name'
      Customer_Name,
      @EndUserText.label: 'RFQ Status'
      RFQ_Status
}
