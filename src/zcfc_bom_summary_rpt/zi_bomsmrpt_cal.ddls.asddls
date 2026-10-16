@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Summary Report-Calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BOMSMRPT_CAL
  as select distinct from ZI_BOMSMRPT_CAL_1 as a
    inner join       I_Product        as c  on a.matcode = c.Product                                        
    
{
  key a.Plant,
  key a.custcode,
  key a.matcode,

      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight,
      a.mcloss,
      a.qtybox,
      a.typmold,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.bunchwt,
      a.sqmtr,

      // Yield_% //

      a.yield,

      a.lmmatl,

      a.metalprc,
      
      a.ttlselexp,

      // DI Treatment Cost/Kg //

      a.ditrtcost,

      // Electricity Cost/Kg //

      a.eleccost,

      // Total Cost/Kg //

      a.ttlcost,

      // Packing Material Cost/Kg //

      a.packmtlcost,

      // Accessory Cost/Kg //

      a.accscost,

      // General Store Cost/Kg //

      a.genstrcost,

      // Painting Mtl Cost/Kg //

      a.pntmtlcostkg,

      // Painting Mtl Cost/SqMtr //

      a.pntmtlcostsqm,

      // Conversion Cost/Kg //

      a.convcost,

      // Labour Cost/Kg //

      a.labrcost,

      // Labour Cost(Spl. Painting)/Kg //

      a.labrcostsp,

      // Rate Per Sq Mtr for Paint Only Labour //

      a.rateprsqm,

      // Labour Cost(Grinding)/Kg //

      a.labrcostgr,

      // Labour Cost(Others)/Kg //

      a.labrcostoth,

      // Labour Cost(Store)/Kg //

      a.labrcoststr,

      // Melting Loss Cost/Kg //

      a.meltlosscst,

      // Machine Cost/Kg //

      a.machncst,
      
      // Labour Cost(Total)/Kg //

      cast(
           ( a.convcost + a.labrcost + a.labrcostsp + a.labrcostgr
             + a.labrcostoth + a.labrcoststr + a.meltlosscst + a.machncst )
      as abap.dec(12,3) ) as ttllabcost,

      // Total Cost/Pcs //

      cast(
           ( ( cast( ( a.convcost + a.labrcost + a.labrcostsp + a.labrcostgr +
                       a.labrcostoth + a.labrcoststr + a.meltlosscst + a.machncst )
               as abap.dec(12,3) )

                   + cast( ( a.ttlcost + a.packmtlcost + a.accscost + a.genstrcost + a.pntmtlcostkg ) as abap.dec(12,3) )  )

            * cast( a.NetWeight as abap.dec(12,3) ) )

      as abap.dec(12,3) ) as ttlcstpcs,

      // Total Cost/Kg //

      cast(
            (
               cast( ( a.convcost + a.labrcost + a.labrcostsp +a.labrcostgr + 
                       a.labrcostoth + a.labrcoststr + a.meltlosscst + a.machncst )
               as abap.dec(12,3) )

               + cast( ( a.ttlcost + a.packmtlcost + a.accscost + a.genstrcost + a.pntmtlcostkg ) as abap.dec(12,3) )
               
               + cast( '3' as abap.dec(12,3) ) 
            )

      as abap.dec(12,3) ) as ttlcstkg

}

where
  c.ProductGroup = 'Z003'
