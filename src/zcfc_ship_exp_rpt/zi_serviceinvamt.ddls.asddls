@AbapCatalog.sqlViewName: 'ZSERVICEINVAMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Service Inv Amount'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SERVICEINVAMT 
  as select distinct from ZI_POENTRY_BASIC
{
  key Commid,
  key SlNo,
  key Type,
  key Item,
  key CC,
  key Commdate,
  key Profitcenter,
  key ProfitCenterName,
  key Expansetype,
  key Percontship,
  key Forwarder,
  key SupplierName,
  key SupplierInvoice,
  key ReferenceDocument,
  key SupplierMaterialNumber,
      CostCenterCode,
      CostCenter,
      GLCode,
      GLName,
      countcontship,
      Amount,
      Currency,
      Exchangerate,
      Amountinr,
      Servicepo,
      Servicepoline,
      POAmt,
      POCurr,
      DocumentCurrency,
      cast ( sum(InvAmt) as abap.dec( 13, 3 )) as InvAmt

}

group by
  Commid,
  SlNo,
  Type,
  Item,
  CC,
  Commdate,
  Profitcenter,
  ProfitCenterName,
  Expansetype,
  Percontship,
  Forwarder,
  SupplierName,
  SupplierInvoice,
  ReferenceDocument,
  SupplierMaterialNumber,
  CostCenterCode,
  CostCenter,
  GLCode,
  GLName,
  countcontship,
  Amount,
  Currency,
  Exchangerate,
  Amountinr,
  Servicepo,
  Servicepoline,
  POAmt,
  POCurr,
  DocumentCurrency
