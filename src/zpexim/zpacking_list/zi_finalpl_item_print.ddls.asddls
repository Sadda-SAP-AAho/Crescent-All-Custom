@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final PL Columns'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'ZVFINALPL_I'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZI_FINALPL_ITEM_PRINT
  as select from zdt_fitem_data
{
  key billingdocument     as Billingdocument,
  key billingdocumentitem as Billingdocumentitem,
  key priority            as Priority,
      col1                as Col1,
      col2                as Col2,
      col3                as Col3,
      col4                as Col4,
      col5                as Col5,
      col6                as Col6,
      col7                as Col7,
      col8                as Col8,
      col9                as Col9,
      col10               as Col10,
      col11               as Col11,
      col12               as Col12,
      col13               as Col13,
      col14               as Col14,
      col15               as Col15,
      col16               as Col16,
      col17               as Col17,
      col18               as Col18,
      col19               as Col19
}
