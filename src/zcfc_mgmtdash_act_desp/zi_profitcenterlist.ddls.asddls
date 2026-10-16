@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profit Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PROFITCENTERLIST
  as select distinct from I_ProfitCenterText as d
{
  key (case when ( d.ProfitCenter = '0000001101' or d.ProfitCenter = '0000001102' or d.ProfitCenter = '0000001103' )
            then cast( '1100' as abap.char( 4 ) )

            when ( d.ProfitCenter = '0000001201' or d.ProfitCenter = '0000001202' )
            then cast( '1200' as abap.char( 4 ) )

            when ( d.ProfitCenter = '0000001301' or d.ProfitCenter = '0000001302' or d.ProfitCenter = '0000001303' )
            then cast( '1300' as abap.char( 4 ) )

            when ( d.ProfitCenter = '0000001401' or d.ProfitCenter = '0000001402' )
            then cast( '1400' as abap.char( 4 ) )

            else '' end ) as Plant,
               
  key d.ProfitCenter,
  
      (case when d.ProfitCenter = '0000001101'
            then 'Salap - CI'

            when d.ProfitCenter = '0000001102'
            then 'Salap - DI'

            when d.ProfitCenter = '0000001103'
            then 'Salap - MS'

            when ( d.ProfitCenter = '0000001201' or d.ProfitCenter = '0000001202' )
            then 'Kulgachia'

            when ( d.ProfitCenter = '0000001301' or d.ProfitCenter = '0000001302' or d.ProfitCenter = '0000001303' )
            then 'Bagnan'

            when d.ProfitCenter = '0000001401'
            then 'Baroda - Sinto'

            when d.ProfitCenter = '0000001402'
            then 'Baroda - Lost Foam'

            else '' end ) as ProfitCenterName
}
