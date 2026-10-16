@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PO_HEAD
  provider contract transactional_query
  as projection on ZI_PO_HEAD
{
      @EndUserText.label: 'UUID'
  key Uuid,
      @EndUserText.label: 'Vendor'
      Vendor,
      @EndUserText.label: 'Purchaser'
      Purchaser,
      @EndUserText.label: 'Created On'
      Createdon,
      @EndUserText.label: 'Created At'
      Createdat,
      @EndUserText.label: 'Purchase Order'
      purchaseorder,
      @EndUserText.label: 'Error Log'
      errorlog,
      _item : redirected to composition child ZC_PO_ITEM
}
