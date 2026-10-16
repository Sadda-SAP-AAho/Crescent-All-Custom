@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for PO Report Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PORPT_HDR
  as select from zdt_po_head
  composition [0..*] of ZI_PORPT_ITM as _item
{
  key zdt_po_head.uuid                              as Uuid,
      zdt_po_head.vendor                            as Vendor,
      zdt_po_head.purchaser                         as Purchaser,
      //    zdt_po_head.createdon as Createdon,
      cast(concat(concat(concat(substring(createdon,7,2),'/'),
       concat(substring(createdon,5,2),'/' ) ),
       substring(createdon,1,4)) as abap.char(10) ) as Createdon,
      //    zdt_po_head.createdat as Createdat,
      cast(concat(concat(concat(substring(createdat,1,2),':'),
       concat(substring(createdat,3,2),':' ) ),
       substring(createdat,5,2)) as abap.char(10) ) as Createdat,
      purchaseorder,
      errorlog,
      _item // Make association public
}
