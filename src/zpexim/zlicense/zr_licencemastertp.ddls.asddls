@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View for Licence Master'
define root view entity ZR_LicenceMasterTP

  as select from    zex_licence_hdr     as a

    left outer join ZI_BOEAccumulation  as b on b.licencenumber = a.licencenumber

    left outer join ZI_ShipAccumulation as c on c.licencenumber = a.licencenumber

{
  key  a.internal_licencenumber                as InternalLicencenumber,
  
       a.licencenumber                         as Licencenumber,
       a.licencetype                           as Licencetype,
       a.licencedate                           as Licencedate,
       a.importvalidfrom                       as Importvalidfrom,
       a.importvalidto                         as Importvalidto,
       a.importexchangerate                    as Importexchangerate,
       @Semantics.amount.currencyCode: 'ImportvalueusdC'
       a.importvalueusd_v                      as ImportvalueusdV,
       a.importvalueusd_c                      as ImportvalueusdC,
       @Semantics.amount.currencyCode: 'ImportvalueinrC'
       a.importvalueinr_v                      as ImportvalueinrV,
       a.importvalueinr_c                      as ImportvalueinrC,
       a.exportvalidfrom                       as Exportvalidfrom,
       a.exportvalidto                         as Exportvalidto,
       a.exportexchangerate                    as Exportexchangerate,
       @Semantics.amount.currencyCode: 'ExportvalueusdC'
       a.exportvalueusd_v                      as ExportvalueusdV,
       a.exportvalueusd_c                      as ExportvalueusdC,
       @Semantics.amount.currencyCode: 'ExportvalueinrC'
       a.exportvalueinr_v                      as ExportvalueinrV,
       a.exportvalueinr_c                      as ExportvalueinrC,
       @Semantics.systemDateTime.createdAt: true
       a.created_at                            as CreatedAt,
       @Semantics.user.createdBy: true
       a.created_by                            as CreatedBy,
       @Semantics.user.lastChangedBy: true
       a.last_changed_by                       as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       a.last_changed_at                       as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       a.local_last_changed_at                 as LocalLastChangedAt,
       cast( b.BOEUsage as abap.dec( 15, 2 ) ) as BOEUsage,
       cast(c.ShipUsage as abap.dec( 15, 2 ) ) as ShipUsage

}
