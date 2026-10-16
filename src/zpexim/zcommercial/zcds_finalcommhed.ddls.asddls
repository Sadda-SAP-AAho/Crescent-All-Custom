@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final Commercial Invoice Header Details'
define view entity ZCDS_FINALCOMMHED 
as select distinct from ZV_FINALCOMMHDR as a
{
  key a.BillingDocument,
      a.Descgoods1,
      a.Descgoods2,
      a.Remarks1,
      a.Remarks2,
      a.gstin,
      a.cinno,
      a.caddress1,
      a.caddress2,
      a.iec,
      a.name,
      a.var3,
      a.CreationDate,
      a.PurchaseOrderByCustomer,
      a.Precarby,
      a.Por,
      a.Pod,
      a.Pol,
      a.Coo,
      a.Vesselcode,
      a.Cod,
      a.Findes,
      a.Cusmar,
      a.Contno,
      a.Descgoods,
      a.Salesnoteref,
      a.Carsealno,
      a.TransactionCurrency,
      a.Meins,
      a.BankName,
      a.StreetName,
      a.CityName,
      a.custconsignee,
      a.counconsignee,
      a.custbuyer,
      a.counbuyer,
      a.CustomerPaymentTermsName,
     @Semantics.quantity.unitOfMeasure : 'meins'
      a.sumgrosswt,
     @Semantics.quantity.unitOfMeasure : 'meins'
      a.sumnetwt,
      a.ShippingBill,
      a.netduedate,
      a.IncotermsClassificationName,
      a.Ladingno,
      a.Ladingdt,
      a.proinv
}
group by a.BillingDocument,
      a.Descgoods1,
      a.Descgoods2,
      a.Remarks1,
      a.Remarks2,
      a.gstin,
      a.cinno,
      a.caddress1,
      a.caddress2,
      a.iec,
      a.name,
      a.var3,
      a.CreationDate,
      a.PurchaseOrderByCustomer,
      a.Precarby,
      a.Por,
      a.Pod,
      a.Pol,
      a.Coo,
      a.Vesselcode,
      a.Cod,
      a.Findes,
      a.Cusmar,
      a.Contno,
      a.Descgoods,
      a.Salesnoteref,
      a.Carsealno,
      a.TransactionCurrency,
      a.Meins,
      a.BankName,
      a.StreetName,
      a.CityName,
      a.custconsignee,
      a.counconsignee,
      a.custbuyer,
      a.counbuyer,
      a.CustomerPaymentTermsName,
      a.ShippingBill,
      a.sumgrosswt,
      a.sumnetwt,
      a.netduedate,
      a.IncotermsClassificationName,
      a.Ladingno,
      a.Ladingdt,
      a.proinv











 