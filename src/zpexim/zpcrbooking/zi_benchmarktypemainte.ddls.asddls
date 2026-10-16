@EndUserText.label: 'Benchmark Type Maintenance'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_BenchmarkTypeMainte
  as select from zdt_bench_tmg
  association to parent ZI_BenchmarkTypeMainte_S as _BenchmarkTypeMaiAll on $projection.SingletonID = _BenchmarkTypeMaiAll.SingletonID
{
  key ratetype as Ratetype,
  @Consumption.hidden: true
  1 as SingletonID,
  _BenchmarkTypeMaiAll
  
}
