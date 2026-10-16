@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-OTIF(Basic)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_OTIF_BASIC
  as select from ZI_SD_OTIF_REPORT_FIN as a

{

  key (case when a.ProfitCenterName = 'Salap - CI' then 'Salap - CI'
            when a.ProfitCenterName = 'Salap - DI' then 'Salap - DI'
            when a.ProfitCenterName = 'Salap - MS' then 'Salap - MS'
            when ( a.ProfitCenterName = 'Kulgachia - Big Line' or a.ProfitCenterName = 'Kulgachia - Small' )  then 'Kulgachia'
            when ( a.ProfitCenterName = 'Bagnan - Molding' or a.ProfitCenterName = 'Bagnan - Manipulator' or a.ProfitCenterName = 'Bagnan - Flexi' )  then 'Bagnan'
            when ( a.ProfitCenterName = 'Baroda - Lost Foam' or a.ProfitCenterName = 'Baroda - Sinto' )  then 'Baroda' end ) as ProfitCenterName,
      sum( a.finotifamt )                                                                                                    as finalotif
}

group by
  a.ProfitCenterName
