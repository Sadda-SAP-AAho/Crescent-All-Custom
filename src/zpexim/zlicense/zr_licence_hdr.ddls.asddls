@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View of Licence Utilization'
define root view entity ZR_LICENCE_HDR
  as select from    zdt_licence_hdr        as a

    left outer join ZI_BOELICACCUMULATION  as b on b.licenceint = a.licenceint

    left outer join ZI_SHIPLICACCUMULATION as c on c.licencint = a.licenceint
{
  key a.id                                    as Id,
      a.licenceint                            as Licenceint,
      a.licenceext                            as Licenceext,
      a.licencetype                           as Licencetype,
      a.liccurrency                           as Liccurrency,
      a.licencedate                           as Licencedate,
      a.licencestatus                         as Licencestatus,
      a.companycode                           as Companycode,
      a.exportfc                              as Exportfc,
      a.importfc                              as Importfc,
      a.licenceval                            as Licenceval,
      a.plandutysaveinr                       as Plandutysaveinr,
      a.actualdutysaveinr                     as Actualdutysaveinr,
      a.remaindutysave                        as Remaindutysave,
      a.importvalidfrom                       as Importvalidfrom,
      a.importvalidto                         as Importvalidto,
      a.importexchangerate                    as Importexchangerate,
      a.exportvalidfrom                       as Exportvalidfrom,
      a.exportvalidto                         as Exportvalidto,
      a.exportvalid4yfrom                     as Exportvalid4yfrom,
      a.exportvalid4yto                       as Exportvalid4yto,
      a.exportvalid2yfrom                     as Exportvalid2yfrom,
      a.exportvalid2yto                       as Exportvalid2yto,
      a.expobigationinr                       as Expobigationinr,
      a.exportexchangerate                    as Exportexchangerate,
      a.expobigationfc                        as Expobigationfc,
      a.explicutilisedinr                     as Explicutilisedinr,
      a.explicutilisedfc                      as Explicutilisedfc,
      a.explicremaininr                       as Explicremaininr,
      a.explicremainfc                        as Explicremainfc,
      a.createdat                             as Createdat,
      a.createdby                             as Createdby,
      a.lastchangedby                         as Lastchangedby,
      a.lastchangedat                         as Lastchangedat,
      a.locallastchangedat                    as Locallastchangedat,
      cast( b.BOEUsage as abap.dec( 15, 2 ) ) as BOEUsage,
      cast(c.ShipUsage as abap.dec( 15, 2 ) ) as ShipUsage      

}
