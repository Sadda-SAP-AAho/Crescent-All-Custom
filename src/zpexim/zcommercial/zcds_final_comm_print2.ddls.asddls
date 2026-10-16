@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Final Commercial Printout 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_final_comm_print2 as select from  ZI_COMM_ITEM_PRINT
{
  key Billingdocument     as Billingdocument,
  key Billingdocumentitem as Billingdocumentitem,
     Col1              as Col1, //Item Code
      Col2             as Col2, // Item Description
      Col3               as Col3, //
      Col4               as Col4,
     Col5                as Col5,   //HSN Code
      Col6              as Col6,    //Quantity
Col7          as Col7,             //Unit
Col8              as Col8,         // Rate
 Col9             as Col9,         // Amount
    Col10              as Col10,
  Col11               as Col11,
     Col12             as Col12,
    Col13               as Col13,
     Col14               as Col14
}where Billingdocumentitem <> '000000';
