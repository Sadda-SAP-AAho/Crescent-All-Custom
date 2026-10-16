@AbapCatalog.sqlViewName: 'ZVRATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View to Get Rate from Table Function'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_get_rate
  as select distinct from ZTF_PP_CASTING_REPORT
                          
{
  key ActivityType,
      cast( ' ' as abap.cuky( 5 ) )                    as currency,
      //      @Semantics.amount.currencyCode: 'currency'
      cast( CostRateFixedAmount as abap.dec( 15, 3 ) ) as CostRateFixedAmount,
      ValidityStartFiscalPeriod,
      ValidityEndFiscalPeriod,
      ValidityStartFiscalYear,
      ValidityEndFiscalYear,
      Validitystartdate,
      Validityenddate,
      //      costcenter   "---Added by Surajit Ghosh - 05/06/2025
      ltrim( costcenter, '0' )                         as costcenter //"+++Added by Surajit Ghosh - 05/06/2025
}
