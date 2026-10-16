@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Table Property'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'ZVTPROP1'
@AbapCatalog.compiler.compareFilter: true
define view ZVTABPROP1
  as select from zdt_tab_propfpl
{
  key billingdocument     as Billingdocument,
  key billingdocumentitem as Billingdocumentitem,
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
