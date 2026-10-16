@EndUserText.label: 'GATE ENTRY ITEMTMG'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_GateEntryItemtmg_01
  as select from ZDT_GATEITEM
  association to parent ZI_GateEntryItemtmg_S1 as _GateEntryItemtmgAll on $projection.SingletonID = _GateEntryItemtmgAll.SingletonID
{
  key ID as Id,
  key ITEM as Item,
  GATEPASS as Gatepass,
  EBELN as Ebeln,
  EBELP as Ebelp,
  VBELN as Vbeln,
  VBELP as Vbelp,
  MATNR as Matnr,
  MAKTX as Maktx,
  POSNR as Posnr,
  VBELNVF as Vbelnvf,
  POSNRVF as Posnrvf,
  MBLNR as Mblnr,
  MJAHR as Mjahr,
  ZEILE as Zeile,
  VENDOR as Vendor,
  INVOICE as Invoice,
  CUSTCODE as Custcode,
  CUSTDESC as Custdesc,
  MEINS as Meins,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  CHALLANQTY as Challanqty,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  ORDERQTY as Orderqty,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  TOTALQTY as Totalqty,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  BALANCEQTY as Balanceqty,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  DELIVERQTY as Deliverqty,
  GATEITEM as Gateitem,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  NETWT as Netwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  TARWT as Tarwt,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  GRSWT as Grswt,
  PLANT as Plant,
  POUNIQUE as Pounique,
  MPNO as Mpno,
  TPNO as Tpno,
  POUNIQUESTO as Pouniquesto,
  VEHNO as Vehno,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _GateEntryItemtmgAll
  
}
