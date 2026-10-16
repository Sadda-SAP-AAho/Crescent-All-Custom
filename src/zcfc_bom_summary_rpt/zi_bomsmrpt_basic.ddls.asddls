@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_BOMSMRPT_BASIC
  as select distinct from ZR_BOMCOST_RPT      as a

    inner join            I_Product           as g on  a.Hedmaterial  = g.Product
                                                   and g.ProductGroup = 'Z003'

    inner join            I_ProductText       as c on  a.Hedmaterial = c.Product
                                                   and c.Language    = 'E'

    inner join            ZI_BOMSMRPT_CAL     as h on  a.Hedmaterial = h.matcode
                                                   and a.Plant       = h.Plant

    left outer join       zdt_pp_matinffld    as b on a.Hedmaterial = b.product

    left outer join       I_Customer          as d on b.cuscode = d.Customer

    left outer join       I_CustomerSalesArea as e on  d.Customer          = e.Customer
                                                   and e.SalesOrganization = '1000'

    left outer join       ztmg_salesgrp       as f on  e.SalesGroup            =  f.salesgroup
                                                   and f.configdeprecationcode <> 'E'

{
  key a.Plant,
  key b.cuscode     as custcode,
  key a.Hedmaterial as matcode,
      c.ProductName as matname,
      b.moc,
      f.salesperson,
      h.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      h.NetWeight,
      h.mcloss,
      h.qtybox,
      h.typmold,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      h.bunchwt,
      h.sqmtr,
      
      h.ttlselexp,

      // Yield_% //

      h.yield,

      // Liquid Metal //

      h.lmmatl,

      // Metal Price-Pig Iron & Ferro Alloys //

      h.metalprc,

      // DI Treatment Cost/Kg //

      h.ditrtcost,

      // Electricity Cost/Kg //

      h.eleccost,

      // Total Cost/Kg //

      h.ttlcost,

      // Packing Material Cost/Kg //

      h.packmtlcost,

      // Accessory Cost/Kg //

      h.accscost,

      // General Store Cost/Kg //

      h.genstrcost,

      // Painting Mtl Cost/Kg //

      h.pntmtlcostkg,

      // Painting Mtl Cost/SqMtr //

      h.pntmtlcostsqm,

      // Conversion Cost/Kg //

      h.convcost,

      // Labour Cost/Kg //

      h.labrcost,

      // Labour Cost(Spl. Painting)/Kg //

      h.labrcostsp,

      // Rate Per Sq Mtr for Paint Only Labour //

      h.rateprsqm,

      // Labour Cost(Grinding)/Kg //

      h.labrcostgr,

      // Labour Cost(Others)/Kg //

      h.labrcostoth,

      // Labour Cost(Store)/Kg //

      h.labrcoststr,

      // Melting Loss Cost/Kg //

      h.meltlosscst,

      // Machine Cost/Kg //

      h.machncst,

      // Labour Cost(Total)/Kg //

      h.ttllabcost,

      // Total Cost/Pcs //

      h.ttlcstpcs,

      // Total Cost/Kg //

      h.ttlcstkg

}
