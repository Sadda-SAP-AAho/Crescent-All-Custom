@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'concat po & date in draft packlist'
define view entity ZCDS_CONCATPO as select from ZCDS_PODRAFTPL
{
   key DeliveryDocument,
   key revision,
cast( 
concat( PurchaseOrderByCustomer,
concat('-  ',
concat(substring(CustomerPurchaseOrderDate,7,2),
concat('/',
concat(substring(CustomerPurchaseOrderDate,5,2),
concat('/', substring(CustomerPurchaseOrderDate,1,4) ) ) ) ) ) ) as abap.char( 100 ) ) as zcuspodate
}
group by DeliveryDocument,
         revision,
         PurchaseOrderByCustomer,
         CustomerPurchaseOrderDate
