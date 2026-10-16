@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gatepass Item'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true

define view entity ZI_GITEM
  as select from zdt_gitem
  association to parent zi_ghead as _Head on $projection.Id = _Head.Id
{
  key zdt_gitem.id           as Id,
  key zdt_gitem.item         as Item,
      zdt_gitem.gatepass     as Gatepass,
      zdt_gitem.ebeln        as Ebeln,
      zdt_gitem.ebelp        as Ebelp,
      zdt_gitem.vbeln        as Vbeln,
      zdt_gitem.vbelp        as Vbelp,
      zdt_gitem.creationdate as creationdate,
      zdt_gitem.matnr        as Matnr,
      zdt_gitem.maktx        as Maktx,
      zdt_gitem.potext       as Potext,
      zdt_gitem.posnr        as Posnr,
      zdt_gitem.vbelnvf      as VbelnVf,
      zdt_gitem.posnrvf      as PosnrVf,
      zdt_gitem.mblnr        as Mblnr,
      zdt_gitem.mjahr        as Mjahr,
      zdt_gitem.zeile        as Zeile,
      zdt_gitem.vendor       as Vendor,
      zdt_gitem.custcode     as Custcode,
      zdt_gitem.custdesc     as Custdesc,
      zdt_gitem.invoice      as Invoice,
      zdt_gitem.meins        as Meins,
//      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_gitem.challanqty   as Challanqty,
//      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_gitem.plantqty     as Plantqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_gitem.orderqty     as Orderqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_gitem.totalqty     as Totalqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_gitem.balanceqty   as Balanceqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      zdt_gitem.deliverqty   as Deliverqty,
      zdt_gitem.gateitem,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      zdt_gitem.netwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      zdt_gitem.tarwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      zdt_gitem.grswt,
      zdt_gitem.wtunit       as Wtunit,
      zdt_gitem.itemval      as Itemval,
      zdt_gitem.currency     as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_gitem.itemval1     as Itemval1,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_gitem.tamount,
      plant,
      pounique,
      zdt_gitem.mpno,
      zdt_gitem.tpno,
      pouniquesto,
      vehno,
      copy                   as Copy,
      _Head

}
