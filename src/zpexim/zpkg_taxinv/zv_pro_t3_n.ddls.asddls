@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for custom inv netwt'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_PRO_T3_N 
as select  from ZV_DELDASHPRNT_ITM
{
    key DeliveryDocument,
    key DeliveryDocumentItem,
    ConsumptionTaxCtrlCodeText1,
    ConsumptionTaxCtrlCode,
    sum(cast(netwt as abap.dec(16,2)) )  as netwt
} 
group by 
DeliveryDocument,
DeliveryDocumentItem,
    ConsumptionTaxCtrlCodeText1,
    ConsumptionTaxCtrlCode
