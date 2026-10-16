@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Invoice Data file'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INVITEM_FILE
  as select from zdt_invitem_file
  association to parent ZI_INVINFO_FILE as _head on $projection.Id = _head.id
{
  key id                                                                  as Id,
  key commid                                                              as Commid,
      cast( case when status = '1' then 'Uploaded'
                 when status = '2' then 'Success'
                 when status = '3' then 'Failed' end as abap.char( 20 ) ) as Updstatus,
      cast( case when status = '1' then '2'
                 when status = '2' then '3'
                 when status = '3' then '1' end as abap.char( 1 ) )       as Crcriticalitystatus,
      msg                                                                 as Msg,
      status                                                              as Status,
      bankrefno                                                           as Bankrefno,
      billcloseflag                                                       as Billcloseflag,
      fundplanremark                                                      as Fundplanremark,
      planingmonth                                                        as Planingmonth,
      _head
}
