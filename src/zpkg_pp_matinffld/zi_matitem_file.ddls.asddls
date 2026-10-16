@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Material Item File'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MATITEM_FILE
  as select from zdt_matitem_file
  association to parent ZI_MATINFO_FILE as _head on $projection.Id = _head.id
{
  key id                                                                  as Id,
  key product                                                             as Product,
      cast( case when status = '1' then 'Uploaded'
                 when status = '2' then 'Success'
                 when status = '3' then 'Failed' end as abap.char( 20 ) ) as Updstatus,
      cast( case when status = '1' then '2'
                 when status = '2' then '3'
                 when status = '3' then '1' end as abap.char( 1 ) )       as Crcriticalitystatus,
      msg                                                                 as Msg,
      status                                                              as Status,
      productdesc                                                         as Productdesc,
      qtyperbox                                                           as Qtyperbox,
      subcode                                                             as Subcode,
      pcspack                                                             as Pcspack,
      potpat                                                              as Potpat,
      matcrawt                                                            as Matcrawt,
      machloss                                                            as Machloss,
      qtypalpcdbox                                                        as Qtypalpcdbox,
      typeofmouldc                                                        as Typeofmouldc,
      typeofmould                                                         as Typeofmould,
      prodcapcday                                                         as Prodcapcday,
      qtyboltunitcons                                                     as Qtyboltunitcons,
      calibdate                                                           as Calibdate,
      rejpercntg                                                          as Rejpercntg,
      itempnt                                                             as Itempnt,
      cft                                                                 as Cft,
      pltpcdboxsize                                                       as Pltpcdboxsize,
      boltsize                                                            as Boltsize,
      consbase                                                            as Consbase,
      constdi                                                             as Constdi,
      constci                                                             as Constci,
      constbag1                                                           as Constbag1,
      constbag2                                                           as Constbag2,
      constbaroda                                                         as Constbaroda,
      constvackul                                                         as Constvackul,
      micr                                                                as Micr,
      loadclass                                                           as Loadclass,
      noofptn                                                             as Noofptn,
      ptnirs                                                              as Ptnirs,
      ptnapp                                                              as Ptnapp,
      pilotprdapp                                                         as Pilotprdapp,
      sqmtr1                                                              as Sqmtr1,
      sqmtr2                                                              as Sqmtr2,
      sqmtr3                                                              as Sqmtr3,
      chillwt                                                             as Chillwt,
      jigf1                                                               as Jigf1,
      jigf2                                                               as Jigf2,
      castcode1                                                           as Castcode1,
      castcode2                                                           as Castcode2,
      castcode3                                                           as Castcode3,
      sqmtr                                                               as Sqmtr,
      moc                                                                 as Moc,
      cuscode                                                             as Cuscode,
      partno                                                              as Partno,
      drawno                                                              as Drawno,
      artno                                                               as Artno,
      mldlinspd                                                           as mldlinspd,
      matlngtxt                                                           as matlngtxt,
      cusmat                                                              as cusmat,
      paintinfo                                                           as paintinfo,
      coreinfo                                                            as coreinfo,
      steel_unit_wt                                                       as steel_unit_wt,
      packinstr                                                           as packinstr,
      _head
      //    _association_name // Make association public
}
