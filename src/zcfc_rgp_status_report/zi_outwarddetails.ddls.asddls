@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Outward Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_OUTWARDDETAILS
  as select distinct from zi_ghead            as a
    inner join            ZI_GITEM            as b on  a.Id       =  b.Id
                                                   and a.Gatepass =  b.Gatepass
                                                   and (
                                                      a.Deleted   <> 'X'
                                                      or a.Cancel <> 'X'
                                                    )
    left outer join       I_BusinessUserBasic as c on a.Ernam = c.UserID
{
  key a.Id,
  key b.Item,
  key b.gateitem                            as GateItm,
      a.Gatepass,
      a.Gatepassdate,
      a.Challannumber,
      a.Challandate,
      a.Plantgateno,
      a.Shipmenttype,
      a.Vehno,
      c.PersonFullName                      as Ernam,
      a.Vendorcode,
      a.Vendorname,
      a.Vehicleoutdate,
      a.Type,
      a.Fromplace,
      a.Toplace,
      a.sendername,
      a.Currency,
      cast ( a.Amountt as abap.dec(13,3) )  as Amount,
      b.gateitem,
      b.Matnr,
      b.Maktx,
      b.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Challanqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Plantqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Orderqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Balanceqty,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.Deliverqty,
      b.Wtunit,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      b.netwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      b.tarwt,
      @Semantics.quantity.unitOfMeasure : 'Wtunit'
      b.grswt,
      b.Currency                            as Curr,
      cast ( b.Itemval1 as abap.dec(13,3) ) as Itemval1
}

where
  a.Type = 'RGP'
