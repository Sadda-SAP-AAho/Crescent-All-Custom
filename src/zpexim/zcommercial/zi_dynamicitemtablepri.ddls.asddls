@EndUserText.label: 'Dynamic Item Table Print Fields'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_DynamicItemTablePri
  as select from ZDT_PRINTFIELD
  association to parent ZI_DynamicItemTablePri_S as _DynamicItemTableAll on $projection.SingletonID = _DynamicItemTableAll.SingletonID
{
  key FIELD as Field,
  FIELDNAME as Fieldname,
  PRINTALLOW as Printallow,
  PRINTSEQ as Printseq,
  @Consumption.hidden: true
  1 as SingletonID,
  _DynamicItemTableAll
  
}
