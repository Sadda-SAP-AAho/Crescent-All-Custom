@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for custom inv amt'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_PRO_T3 
as select distinct from ZV_DELDASHPRNT_ITM
{
    key DeliveryDocument,
    key DeliveryDocumentItem,
    ConsumptionTaxCtrlCodeText1,
    ConsumptionTaxCtrlCode,
    cast(amt as abap.dec(23,2)) as amt
}
