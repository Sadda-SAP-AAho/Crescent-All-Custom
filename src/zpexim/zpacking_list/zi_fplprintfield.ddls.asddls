@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final PL Print fields'
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_FPLPRINTFIELD
  as select from zdt_packprint
  association to parent zi_finalpack_hdr as _head on $projection.Id = _head.Id

{
  key zdt_packprint.id          as Id,
  key zdt_packprint.packinglist as Packinglist,
  key zdt_packprint.item        as Item,
      zdt_packprint.field       as Field,
      zdt_packprint.fieldname   as Fieldname,
      zdt_packprint.printallow  as Printallow,
      zdt_packprint.printseq    as Printseq,
      _head
}
