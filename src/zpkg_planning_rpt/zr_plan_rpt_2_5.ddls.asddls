@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Club Custing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_5
  as select distinct from ZR_PLAN_RPT_2 as a
    inner join            I_Product     as b on  a.hedmaterial  = b.Product
                                             and b.ProductGroup = 'Z003'
{
  key a.plant,
      //  key hedmaterial,
  key a.component,
      a.ProductGroup,
      a.ProductDescription,
      a.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      a.NetWeight,
      a.ProfitCenter,
      a.ProfitCenterLongName,
      a.cuscode,
      a.qtyperbox,
      a.prodcapcday,
      a.boxsize,
      a.typemould,

            sum(a.OpenContQty)  as OpenContQty,
            sum(a.OpenSoQty)    as OpenSoQty,
            sum(a.castonhand)   as castonhand,
//      a.OpenContQty,
//      a.OpenSoQty,
//      a.castonhand,

      //      FgLiveQty,
      //      stockZ028,
      //      stockZ026,
      //      stockZ027,
      //      stockZ045,
      //      stockZ025,
      //      stockZ024,

            sum(a.OpenSoQty7)   as OpenSoQty7,
            sum(a.OpenSoQty8)   as OpenSoQty8,
            sum(a.OpenSoQty16)  as OpenSoQty16,
            sum(a.OpenSoQty23)  as OpenSoQty23,
            sum(a.OpenSoQty31)  as OpenSoQty31,
            sum(a.OpenSoQty39)  as OpenSoQty39,
            sum(a.OpenSoQty47)  as OpenSoQty47,
            sum(a.OpenSoQty55)  as OpenSoQty55,
            sum(a.OpenSoQty63)  as OpenSoQty63,
            sum(a.OpenSoQty71)  as OpenSoQty71,
            sum(a.OpenSoQty366) as OpenSoQty366
//      a.OpenSoQty7,
//      a.OpenSoQty8,
//      a.OpenSoQty16,
//      a.OpenSoQty23,
//      a.OpenSoQty31,
//      a.OpenSoQty39,
//      a.OpenSoQty47,
//      a.OpenSoQty55,
//      a.OpenSoQty63,
//      a.OpenSoQty71,
//      a.OpenSoQty366
}
group by
  a.plant,
  a.component,
  a.ProductGroup,
  a.ProductDescription,
  a.WeightUnit,
  a.NetWeight,
  a.ProfitCenter,
  a.ProfitCenterLongName,
  a.cuscode,
  a.qtyperbox,
  a.prodcapcday,
  a.boxsize,
  a.typemould
