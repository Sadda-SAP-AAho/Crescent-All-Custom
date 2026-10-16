@EndUserText.label: 'VEHICLE NO F4'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_VEHICLENOF4_SALES as select distinct from I_DeliveryDocument as a
{
  key  a.DeliveryDocument
//       a.YY1_VehicleNumber_DLH
}
where a.OverallGoodsMovementStatus = 'A'
and ( a.ShippingPoint = '1100' or a.ShippingPoint = '1600' )
//and a.YY1_VehicleNumber_DLH <> ''
and a.DeliveryDocumentType = 'LF' or a.DeliveryDocumentType = 'NL' 
union all select distinct from I_DeliveryDocument as a
{
  key  a.DeliveryDocument
//       a.YY1_VehicleNumber_DLH
}
where a.OverallGoodsMovementStatus = 'A'
and ( a.ShippingPoint = '1100' or a.ShippingPoint = '1600' )
//and a.YY1_VehicleNumber_DLH <> ''
and a.DeliveryDocumentType = 'LR'
