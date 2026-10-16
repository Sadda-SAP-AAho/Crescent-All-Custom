@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commercial Invoice Split Value Final'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMM_INV_SPLT_VAL_Final
  as select from ZI_COMM_INV_SPLT_VAL2
{
  key Billingdocument                               as Billingdocument,
  key Billingdocumentitem                           as Billingdocumentitem,
      cast(Col1 as abap.char(100))                  as Col1,
      cast(Col2 as abap.char(100))                  as Col2,
      cast(Col3 as abap.char(100))                  as Col3,
      cast(Col4 as abap.char(100))                  as Col4,
      cast(Col5 as abap.char(100))                  as Col5,
      cast(Col6 as abap.char(100))                  as Col6,
      cast(Col7 as abap.char(100))                  as Col7,     
      Col8                 as Col8,
      cast(Col9 as abap.char(100))                  as Col9,
      cast(Col10 as abap.char(100))                 as Col10,
      cast(Col11 as abap.char(100))                 as Col11,
      cast(Col12 as abap.char(100))                 as Col12,
      cast(Col13 as abap.char(100))                 as Col13,
      cast(Col14 as abap.char(100))                 as Col14
//      cast(Unit_Wt as abap.char(100))               as Col15,
//      cast(Total_Wt as abap.char(100))              as Col16,
//      cast(Steel_Unit_Wt as abap.char(100))         as Col17,
//      cast(Steel_Unit_Price as abap.char(100))      as Col18,
//      cast(Steel_Total_Price as abap.char(100))     as Col19,
//      cast(Total_Price as abap.char(100))           as Col20,
//      cast(Non_Steel_Unit_Price as abap.char(100))  as Col21,
//      cast(Non_Steel_Total_Price as abap.char(100)) as Col22
}
