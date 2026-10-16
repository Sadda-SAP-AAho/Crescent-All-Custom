@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection View for Licence Master'
define root view entity ZI_LicenceMasterTP
  as projection on ZR_LicenceMasterTP
{
  key InternalLicencenumber,
      Licencenumber,
      Licencetype,
      Licencedate,
      Importvalidfrom,
      Importvalidto,
      Importexchangerate,
      ImportvalueusdV,
      ImportvalueusdC,
      ImportvalueinrV,
      ImportvalueinrC,
      Exportvalidfrom,
      Exportvalidto,
      Exportexchangerate,
      ExportvalueusdV,
      ExportvalueusdC,
      ExportvalueinrV,
      ExportvalueinrC,
      CreatedAt,
      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      BOEUsage,
      ShipUsage
}
