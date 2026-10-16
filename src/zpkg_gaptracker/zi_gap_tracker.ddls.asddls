//@AbapCatalog.sqlViewName: 'ZIGAPTRACKER'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GAP Tracker Interface view'
define root view entity ZI_GAP_TRACKER
  as select from zdt_gap_tracker
  association to ZI_WRICEF_F4      as _wricef     on $projection.WricefCategory = _wricef.value_low
  association to ZI_DEVSTATUS_F4   as _devstatus  on $projection.DevelopmentStatus = _devstatus.value_low
  association to ZI_CLNT_STATUS_F4 as _clntstatus on $projection.ClientTestingStatus = _clntstatus.value_low
  association to ZI_DEPLOYED_F4    as _deployed   on $projection.Deployed = _deployed.value_low
  association to ZI_STAGE_F4       as _stage      on $projection.Stage = _stage.value_low
  association to ZI_Priority_F4    as _priority   on $projection.Priority = _priority.value_low
  association to ZC_FSD_F4         as _fsd        on $projection.FdsStatus = _fsd.value_low
  association to ZI_TSD_F4         as _tsd        on $projection.TsdStatus = _tsd.value_low
  association to ZI_TESTING_F4     as _testing    on $projection.TestingStatus = _testing.value_low
  association to ZI_OVERALL_STATUS_F4  as _ostat  on $projection.OverallStat = _ostat.value_low
{
  key id                         as Id,
      serialnumber               as SerialNumber,
      modulename                 as ModuleName,
      description                as Description,
      wricefcategory             as WricefCategory,
      priority                   as Priority,
      entity                     as Entity,
      developmentstatus          as DevelopmentStatus,
      testingstatus              as TestingStatus,
      clienttestingstatus        as ClientTestingStatus,
      developer                  as Developer,
      finctional                 as Finctional,
      transportno                as TransportNo,
      deployed                   as Deployed,
      remarks                    as Remarks,
      stage                      as Stage,
      fdsstatus                  as FdsStatus,
      tsdstatus                  as TsdStatus,
      lastchangedby              as LastChangedBy,
      lastchangedon              as LastChangedOn,
      lastchangedat              as LastChangedAt,
      fstardat                   as Fstardat,
      fscomdat                   as Fscomdat,
      devtardat                  as Devtardat,
      devcomdat                  as Devcomdat,
      rework                     as Rework,
      reworkrem                  as Reworkrem,
      overallstat                as OverallStat,
      _wricef.WricefDescription  as WricefDescription,
      _devstatus.text            as DevStatusDesc,
      _clntstatus.ClntStatusDesc as ClntStatusDesc,
      _deployed.text             as DeployedDesc,
      _stage.text                as StageDesc,
      _testing.TestingDesc       as TestingDesc,
      _fsd.text                  as FSDDesc,
      _tsd.text                  as TSDDesc,
      _priority.PriorityDesc     as PriorityDesc,
      _ostat.text                as Overalldesc,

      _wricef,
      _devstatus,
      _clntstatus,
      _deployed,
      _stage,
      _priority,
      _fsd,
      _tsd,
      _testing,
      _ostat

}
