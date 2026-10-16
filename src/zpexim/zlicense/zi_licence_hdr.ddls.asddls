@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Licence Master'

define root view entity ZI_LICENCE_HDR
  as select from zdt_licence_hdr
{
  key id                 as Id,
      licenceint         as Licenceint,
      licenceext         as Licenceext,
      licencetype        as Licencetype,
      liccurrency        as Liccurrency,
      licencedate        as Licencedate,
      licencestatus      as Licencestatus,
      companycode        as Companycode,
      exportfc           as Exportfc,
      importfc           as Importfc,
      @Semantics.amount.currencyCode : 'liccurrency'
      licenceval         as Licenceval,
      @Semantics.amount.currencyCode : 'liccurrency'
      plandutysaveinr    as Plandutysaveinr,
      @Semantics.amount.currencyCode : 'liccurrency'
      actualdutysaveinr  as Actualdutysaveinr,
      @Semantics.amount.currencyCode : 'liccurrency'
      remaindutysave     as Remaindutysave,
      importvalidfrom    as Importvalidfrom,
      importvalidto      as Importvalidto,
      importexchangerate as Importexchangerate,
      exportvalidfrom    as Exportvalidfrom,
      exportvalidto      as Exportvalidto,
      exportvalid4yfrom  as Exportvalid4yfrom,
      exportvalid4yto    as Exportvalid4yto,
      exportvalid2yfrom  as Exportvalid2yfrom,
      exportvalid2yto    as Exportvalid2yto,
      @Semantics.amount.currencyCode : 'liccurrency'
      expobigationinr    as Expobigationinr,
      exportexchangerate as Exportexchangerate,
      @Semantics.amount.currencyCode : 'liccurrency'
      expobigationfc     as Expobigationfc,
      @Semantics.amount.currencyCode : 'liccurrency'
      explicutilisedinr  as Explicutilisedinr,
      @Semantics.amount.currencyCode : 'liccurrency'
      explicutilisedfc   as Explicutilisedfc,
      @Semantics.amount.currencyCode : 'liccurrency'
      explicremaininr    as Explicremaininr,
      @Semantics.amount.currencyCode : 'liccurrency'
      explicremainfc     as Explicremainfc,
      createdat          as Createdat,
      createdby          as Createdby,
      lastchangedby      as Lastchangedby,
      lastchangedat      as Lastchangedat,
      locallastchangedat as Locallastchangedat,
      cal                as cal

}
