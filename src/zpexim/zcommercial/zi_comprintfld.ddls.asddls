@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Commercial Print Field'
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_COMPRINTFLD
  as select from zdt_comprintfld
  association to parent ZI_COMM_HED as _head on  $projection.Id     = _head.Id
                                             and $projection.Commid = _head.Commid
{
  key zdt_comprintfld.id         as Id,
  key zdt_comprintfld.commid     as Commid,
  key zdt_comprintfld.item       as Item,
      zdt_comprintfld.field      as Field,
      zdt_comprintfld.fieldname  as Fieldname,
      zdt_comprintfld.printallow as Printallow,
      zdt_comprintfld.printseq   as Printseq,
      _head
}
