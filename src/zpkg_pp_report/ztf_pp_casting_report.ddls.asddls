@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Daily Prod Casting report'
define table function ZTF_PP_CASTING_REPORT

returns
{
  key mandt                     : abap.clnt;
  key ActivityType              : lstar;
      CostRateFixedAmount       : abap.curr( 23, 3 );
      ValidityStartFiscalPeriod : abap.numc( 3 );
      ValidityEndFiscalPeriod   : abap.numc( 3 );
      ValidityStartFiscalYear   : abap.numc( 4 );
      ValidityEndFiscalYear     : abap.numc( 4 );
      Validitystartdate         : abap.dats;
      Validityenddate           : abap.dats;
      costcenter                : abap.char( 10 );
}
implemented by method
  zcl_pp_casting_report=>get_rate;