@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZI_PO_HEAD as select from zdt_po_head
composition [0..*] of ZI_PO_ITEM as _item
{
    key zdt_po_head.uuid as Uuid,
    zdt_po_head.vendor as Vendor,
    zdt_po_head.purchaser as Purchaser,
    zdt_po_head.createdon as Createdon,
    zdt_po_head.createdat as Createdat,
    purchaseorder,
    errorlog,
    _item // Make association public
}
