@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Report Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PORPT_HDR
  provider contract transactional_query
  as projection on ZI_PORPT_HDR
{
      @EndUserText.label: 'UUID'
  key Uuid,
      @EndUserText.label: 'Vendor'
      Vendor,
      @EndUserText.label: 'Purchaser'
      Purchaser,
      @EndUserText.label: 'Created On'
      Createdon,
      
//      cast(concat(concat(concat(substring(Createdon,7,2),'/'), 
//      concat(substring(Createdon,5,2),'/' ) ),
//      substring(Createdon,1,4)) as abap.char(10) ) as Createdon1,
      @EndUserText.label: 'Created At'
      Createdat,
      @EndUserText.label: 'Purchase Order'
      purchaseorder,
      @EndUserText.label: 'Error Log'
      errorlog,
      _item : redirected to composition child ZC_PORPT_ITM
}

