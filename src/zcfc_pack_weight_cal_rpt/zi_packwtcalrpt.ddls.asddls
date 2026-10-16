@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pack Weight Calculation Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PACKWTCALRPT
  as select distinct from ZI_PACKWTCALRPT_1 as a
    left outer join       ZI_BOMPACKQTY     as b on  a.Material = b.Hedmaterial
                                                 and a.Plant    = b.Plant
    left outer join       ZI_PACKWTMETAL    as c on  a.Material = c.Hedmaterial
                                                 and a.Plant    = c.Plant
    left outer join       ZI_PACKWTWOOD     as d on  a.Material = d.Hedmaterial
                                                 and a.Plant    = d.Plant


{
  key a.Delivery,
  key a.DelItem,
      a.Plant,
      a.CustCode,
      a.Material,
      a.Descrption,
      a.Uom,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Matnetwt,
      a.Wtunit,
      a.Packmat,
      a.ProductGroup                                 as PackMtlGrp,
      a.Packmattyp,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      a.NoOfPack,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.PackWt,
      a.Priority,
      cast( ( case when ( (a.Plant = '1100' or a.Plant = '1400') and a.ProductGroup = 'Z041' )
             then ( a.DelQty * b.BomPackQty )
             when ( (a.Plant = '1200' or a.Plant = '1300') and a.ProductGroup = 'Z041' )
             then ( a.Mateachpkg * b.BomPackQty )
             when ( (a.Plant = '1200' or a.Plant = '1300') and a.ProductGroup = 'Z042' )
             then c.PackWt
             when (a.ProductGroup = 'Z010' or a.ProductGroup = 'Z011' or a.ProductGroup = 'Z012' or a.ProductGroup = 'Z013' )
             then d.PackWt end ) as abap.dec(12,3) ) as PackWtCal,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      a.Mateachpkg,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      a.DelQty,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.EachPackNetWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.EachPackGroWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.Growt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      a.NetwtWb,
      b.BomPackQty
}
