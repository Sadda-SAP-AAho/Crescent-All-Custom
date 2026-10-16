@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP IN and OUT Report Test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_RGPRPTTST
  as select distinct from zi_ghead  as a
   inner join       ZI_GITEM as b on a.Id = b.Id
                                   and a.Gatepass = b.Gatepass
    left outer join zi_ghead as c on a.Gatepass = c.rgpgatepass
    
    left outer join ZI_GITEM as d on c.Id = d.Id
                                   and c.Gatepass = d.Gatepass
                                   and b.gateitem = d.gateitem
    left outer join       I_BusinessUserBasic as e on a.Ernam = e.UserID
    left outer join       I_BusinessUserBasic as f on c.Ernam = f.UserID                                              
{
  key a.Id,
      a.Challannumber,
      a.Challandate,
      a.Plantgateno,
      a.Shipmenttype,
      a.Vehno,
      a.Ernam,
      a.Vendorcode,
      a.Vendorname,
      a.Gatepass,
      a.Gatepassdate,
      a.Vehicleoutdate,
      a.Type,
      a.Fromplace,
      a.Toplace,
      a.sendername,
      @Semantics.amount.currencyCode: 'Currency'
      a.Amountt,
      b.Matnr,
      b.Maktx,
      b.Meins,
      b.Challanqty,
      b.Plantqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Orderqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Balanceqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Deliverqty,
      b.gateitem,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      b.netwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      b.tarwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      b.grswt,
      b.Wtunit,
      b.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      b.Itemval1,
      c.Challannumber  as ChlnNo,
      c.Challandate    as ChlnDt,
      c.Plantgateno    as PltGtNo,
      c.Shipmenttype   as ShpTyp,
      c.Vehno          as VNo,
      c.Ernam          as Erm,
      c.Vendorcode     as VenCode,
      c.Vendorname     as VName,
      c.Gatepass       as GPass,
      c.Gatepassdate   as GaPaDt,
      c.Vehicleoutdate as VOD,
      c.Type           as Typ,
      c.Fromplace      as FrmPlc,
      c.Toplace        as ToPlc,
      c.rgpgatepass,
      d.Gatepass       as GtPass,
      d.Matnr          as MtNr,
      d.Maktx          as MkTx,
      d.Vendor,
      d.Challanqty     as ChllnQty,
      d.Plantqty       as PltQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      d.Orderqty       as OrdQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      d.Balanceqty     as BalQty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      d.Deliverqty     as DelQty,
      d.gateitem       as GItem,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      d.netwt          as NtWt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      d.tarwt          as TWt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      d.grswt          as GrWt,
      d.Wtunit         as WUt

}
