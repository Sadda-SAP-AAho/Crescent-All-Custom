@EndUserText.label: 'Final PL Print field TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_FinalPlPrintFieldTm
  as select from ZDT_PACKPR_TMG
  association to parent ZI_FinalPlPrintFieldTm_S as _FinalPlPrintFielAll on $projection.SingletonID = _FinalPlPrintFielAll.SingletonID
{
  key FIELD as Field,
  FIELDNAME as Fieldname,
  PRINTALLOW as Printallow,
  PRINTSEQ as Printseq,
  @Consumption.hidden: true
  1 as SingletonID,
  _FinalPlPrintFielAll
  
}
