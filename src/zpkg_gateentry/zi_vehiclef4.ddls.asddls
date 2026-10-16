@AbapCatalog.sqlViewName: 'ZDELIVERY1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vehicle f4'
define view zi_vehiclef4 as select from I_DeliveryDocument
{
   key DeliveryDocument,
    MeansOfTransport
}
where MeansOfTransport <> '' and OverallGoodsMovementStatus = 'A'
