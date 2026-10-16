@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pack Weight Calculation Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PACKWTCALRPT_1
  as select distinct from ZI_PACKLIST_HDR as a
    inner join            ZI_PACKLIST_ITM as b on a.Id = b.Id
    left outer join       I_Product       as c on c.Product = b.Packmat
    left outer join       zi_ghead        as d on  a.Delivery =  d.deliverynumber
                                               and d.Cancel   <> 'X'
                                               and d.Status   <> 'Deleted'
{
  key a.Delivery,
  key b.Posnr        as DelItem,
      a.Plant,
      a.Customercode as CustCode,
      b.Matnr        as Material,
      b.Maktx        as Descrption,
      b.Meins        as Uom,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.Matnetwt,
      b.Wtunit,
      b.Packmat,
      c.ProductGroup,
      b.Packmattyp,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      b.Packqty      as NoOfPack,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.Packmatnwt   as PackWt,
      b.Priority,
      @Semantics.quantity.unitOfMeasure : 'Uom'
      b.Mateachpkg,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      b.Qty          as DelQty,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.Eachnetwt    as EachPackNetWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.Eachgrowt    as EachPackGroWt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.Netwt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      b.Growt,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      d.Netwt        as NetwtWb

}

where
  a.Canind <> 'X'
