@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'License Master'


define view entity ZI_LICENSE_F4

  as select from zex_licence_hdr
{
  key internal_licencenumber as Internal_licencenumber,
      @Search.defaultSearchElement: true
      licencenumber          as Licencenumber,
      licencetype            as Licencetype,
      licencedate            as Licencedate,
      importvalidfrom        as Importvalidfrom,
      importvalidto          as Importvalidto,
      @Semantics.amount.currencyCode: 'ImportvalueinrC'
      importvalueinr_v       as ImportvalueinrV,
      importvalueinr_c       as ImportvalueinrC,
      exportvalidfrom        as Exportvalidfrom,
      exportvalidto          as Exportvalidto,
      @Semantics.amount.currencyCode: 'ExportvalueinrC'
      exportvalueinr_v       as ExportvalueinrV,
      exportvalueinr_c       as ExportvalueinrC
}
