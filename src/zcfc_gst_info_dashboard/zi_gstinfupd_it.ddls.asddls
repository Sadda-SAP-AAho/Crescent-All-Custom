@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Information Dashboard Uploader-Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GSTINFUPD_IT
  as select from ZDT_GSTINFUPD_IT
  association to parent ZI_GSTINFUPD_HD as _head on $projection.Id = _head.id
{
  key id                                                                  as Id,
  key fisyear                                                             as Fisyear,
  key jeno                                                                as Jeno,
      cast( case when status = '1' then 'Uploaded'
                 when status = '2' then 'Success'
                 when status = '3' then 'Failed' end as abap.char( 20 ) ) as Updstatus,
      cast( case when status = '1' then '2'
                 when status = '2' then '3'
                 when status = '3' then '1' end as abap.char( 1 ) )       as Crcriticalitystatus,
      msg                                                                 as Msg,
      status                                                              as Status,
      jedate                                                              as Jedate,
      documenttype                                                        as Documenttype,
      journalentrytype                                                    as Journalentrytype,
      documentno                                                          as Documentno,
      vendorcode                                                          as Vendorcode,
      vendorname                                                          as Vendorname,
      invoicedrno                                                         as Invoicedrno,
      invoicedrdate                                                       as Invoicedrdate,
      gstno                                                               as Gstno,
      state                                                               as State,
      sumtaxablevalue                                                     as Sumtaxablevalue,
      sumcgst                                                             as Sumcgst,
      sumsgst                                                             as Sumsgst,
      sumigst                                                             as Sumigst,
      sumrcmcgst                                                          as Sumrcmcgst,
      sumrcmsgst                                                          as Sumrcmsgst,
      sumrcmigst                                                          as Sumrcmigst,
      sumtotalinvvalue                                                    as Sumtotalinvvalue,
      twobrefno                                                           as Twobrefno,
      gstremarks                                                          as Gstremarks,
      newgstno                                                            as Newgstno,
      gstmonth                                                            as Gstmonth,
      extra1                                                              as Extra1,
      extra2                                                              as Extra2,
      _head
      //    _association_name // Make association public
}
