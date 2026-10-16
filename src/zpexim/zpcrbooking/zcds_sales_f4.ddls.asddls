@AbapCatalog.sqlViewName: 'ZCDS_SALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@UI:{presentationVariant: [{ sortOrder: [{ by: 'SalesOrderDate' , direction: #DESC }] }] }
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for sales order'
define view ZCDS_SALES_F4
  as select distinct from I_SalesOrder
{
  key SalesOrderDate,
  key SalesOrder,
  key SoldToParty,
  key TransactionCurrency,
  key PurchaseOrderByCustomer,
  key cast('SALES ORDER' as abap.char(20) ) as basedoctyp
}
group by
  SalesOrderDate,
  SalesOrder,
  SoldToParty,
  TransactionCurrency,
  PurchaseOrderByCustomer
union

select distinct from I_SalesContract
{
  key SalesContractDate                        as SalesOrderDate,
  key SalesContract                            as SalesOrder,
  key SoldToParty,
  key TransactionCurrency,
  key PurchaseOrderByCustomer,
  key cast('SALES CONTRACT' as abap.char(20) ) as basedoctyp
}
group by
  SalesContractDate,
  SalesContract,
  SoldToParty,
  TransactionCurrency,
  PurchaseOrderByCustomer
