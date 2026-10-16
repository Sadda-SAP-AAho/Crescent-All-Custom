@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for benchmark rate type'
define root view entity ZCDS_BENCHTYPE_F4 as 
 select distinct from zdt_bench_tmg
{

  key ratetype
      
}
group by ratetype
