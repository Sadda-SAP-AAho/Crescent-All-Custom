@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for custom inv table 4 qty'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_PRO_T4 
as select distinct from ZV_DELDASHPRNT_ITM
{
    key DeliveryDocument,
    key DeliveryDocumentItem,
    ConsumptionTaxCtrlCodeText1,
    ConsumptionTaxCtrlCode,
    Qty
}
