@AbapCatalog.sqlViewName: 'ZVGATEITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Item Print'
@Metadata.ignorePropagatedAnnotations: true
define view ZVGATEITEMPRINT
  as select from zdt_gitem
{
  key id              as Id,
  key item            as Item,
      gatepass        as Gatepass,
      ebeln           as Ebeln,
      ebelp           as Ebelp,
      vbeln           as Vbeln,
      vbelp           as Vbelp,
      creationdate    as Creationdate,
      matnr           as Matnr,
      maktx           as Maktx,
      posnr           as Posnr,
      vbelnvf         as Vbelnvf,
      posnrvf         as Posnrvf,
      mblnr           as Mblnr,
      mjahr           as Mjahr,
      zeile           as Zeile,
      vendor          as Vendor,
      invoice         as Invoice,
      custcode        as Custcode,
      custdesc        as Custdesc,
      meins           as Meins,
      @Semantics.quantity.unitOfMeasure : 'meins'
      challanqty      as Challanqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      plantqty        as Plantqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      orderqty        as Orderqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      totalqty        as Totalqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      balanceqty      as Balanceqty,
      @Semantics.quantity.unitOfMeasure : 'meins'
      deliverqty      as Deliverqty,
      gateitem        as Gateitem,
      @Semantics.quantity.unitOfMeasure : 'meins'
      netwt           as Netwt,
      @Semantics.quantity.unitOfMeasure : 'meins'
      tarwt           as Tarwt,
      @Semantics.quantity.unitOfMeasure : 'meins'
      grswt           as Grswt,
      itemval         as Itemval,
      currency        as Currency,
      @Semantics.amount.currencyCode : 'currency'
      itemval1        as Itemval1,
      plant           as Plant,
      pounique        as Pounique,
      mpno            as Mpno,
      tpno            as Tpno,
      pouniquesto     as Pouniquesto,
      vehno           as Vehno,
      copy            as Copy,
      weighbentrydate as Weighbentrydate,
      weighbentrytime as Weighbentrytime,
      weighbexitdate  as Weighbexitdate,
      weighbexittime  as Weighbexittime
}
