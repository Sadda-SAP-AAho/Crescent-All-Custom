@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FD Outgoing GL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_FDOUTGL

  as select from zdt_fd_outgl

  association to parent ZR_FDHEAD as _head on $projection.id = _head.id

{
  key id,
  key item,
      glaccount,
      housebankid,
      accountid,
      bankreference,
      
      _head
}
