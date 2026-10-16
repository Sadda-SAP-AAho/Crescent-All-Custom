@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Invoice Split Value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMM_INV_SPLT_VAL
  as select from ZCDS_final_comm_print2
  association [1..1] to ZI_MATFLD as _matsteel  on $projection.Col1 = _matsteel.Product
  association [1..1] to I_Product as _matweight on $projection.Col1 = _matweight.Product
  association [1..1] to ZI_COMM_INV_SPLT_VAL_Total as _total on $projection.Billingdocument = _total.Billingdocument 
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
//      cast( _matweight.NetWeight as abap.dec(13,2)) as Unit_Wt,
//       cast(
//  _matweight.NetWeight * Col7
//  as abap.dec(13,2)
//) as Total_Wt,
//   _matsteel.Steel_unit_wt as Steel_Unit_Wt,
//cast(
//  ( Col9 / _matweight.NetWeight )
//  *  _matsteel.Steel_unit_wt
//  * cast( '1.02' as abap.dec(5,2) )
//  as abap.dec(13,2)
//) as Steel_Unit_Price,

//cast(
//  ( Col9 / _matweight.NetWeight )
//  * _matsteel.Steel_unit_wt
//  * cast( '1.02' as abap.dec(5,2) )
//  * Col7
//  as abap.dec(13,2)
//) as Steel_Total_Price,


//_total.Col10 as Total_Price


//cast(
//  Col9
//  - ( Col9 / _matweight.NetWeight
//      *  _matsteel.Steel_unit_wt
//      * cast( '1.02' as abap.dec(5,2)) )
//  as abap.dec(13,2)
//) as Non_Steel_Unit_Price



   
       
}
