@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_3

  as select distinct from ZV_COSTINGPL_2

{
  key      AssignmentReference,
           CompanyCodeCurrency,
           sum( cast( FumigationCharges as abap.dec( 15, 2 ) ) )            as FumigationCharges,
           sum( cast( ContainerFreight as abap.dec( 15, 2 ) ) )             as ContainerFreight,
           sum( cast( ExcelloDocumentPortCharges as abap.dec( 15, 2 ) ) )   as ExcelloDocumentPortCharges,
           sum( cast( THCCharges as abap.dec( 15, 2 ) ) )                   as THCCharges,
           sum( cast( RadiationChecking as abap.dec( 15, 2 ) ) )            as RadiationChecking,
           sum( cast( InspectionCharges as abap.dec( 15, 2 ) ) )            as InspectionCharges,
           sum( cast( FreightUSD as abap.dec( 15, 2 ) ) )                   as FreightUSD,
           sum( cast( ECGCPREMIUMRATE as abap.dec( 15, 2 ) ) )              as ECGCPREMIUMRATE,
           sum( cast( ShortRelisationCharges as abap.dec( 15, 2 ) ) )       as ShortRelisationCharges,
           sum( cast( CreditPeriodCharges as abap.dec( 15, 2 ) ) )          as CreditPeriodCharges,
           sum( cast( BankAdvCharges as abap.dec( 15, 2 ) ) )               as BankAdvCharges,
           sum( cast( CommissionCharges as abap.dec( 15, 2 ) ) )            as CommissionCharges,
           sum( cast( ClaimagainstDamagedMaterials as abap.dec( 15, 2 ) ) ) as ClaimagainstDamagedMaterials,
           sum( cast( VariancePerKg as abap.dec( 15, 2 ) ) )                as VariancePerKg,
           sum( cast( FreightreceivedAmount as abap.dec( 15, 2 ) ) )        as FreightreceivedAmount,
           sum( cast( PatternSale as abap.dec( 15, 2 ) ) )                  as PatternSale
}

group by
  AssignmentReference,
  CompanyCodeCurrency
