@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Invoice Split Value 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMM_INV_SPLT_VAL2 as select from ZI_COMM_INV_SPLT_VAL
{
    key Billingdocument,
  key Billingdocumentitem,
      Col1,
      Col2,
      Col3,
      Col4,
      Col5,
      Col6,
      Col7,
      Col8,
      Col9,
      Col10,
      Col11,
      Col12,
      Col13,
      Col14
//      Unit_Wt,
//      Total_Wt,
//      Steel_Unit_Wt,
//      Steel_Unit_Price,
//      Steel_Total_Price,
//      Total_Price
//    cast(
//        coalesce( Col9, 0 ) - coalesce( Steel_Unit_Price, 0 )
//        as abap.decfloat34
//    ) as Non_Steel_Unit_Price,
//    cast(
//        ( coalesce( Col9, 0 ) - coalesce( Steel_Unit_Price, 0 ) )
//        * coalesce( Col7, 0 )
//        as abap.decfloat34
//    ) as Non_Steel_Total_Price
      
      
}
