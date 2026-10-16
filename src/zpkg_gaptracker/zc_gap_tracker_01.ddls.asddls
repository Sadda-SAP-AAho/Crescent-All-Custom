@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GAP Tracker consumption view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_GAP_TRACKER_01
  provider contract transactional_query
  as projection on ZI_GAP_TRACKER
{


  key Id,
      @EndUserText.label: 'Serial Number'
      SerialNumber,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Module Name'
      ModuleName,
      @EndUserText.label: 'Description'
      Description,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'WRICEF Category'
      WricefCategory,
      @EndUserText.label: 'WRICEF Category Desc'
      WricefDescription,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Priority'
      Priority,
      @EndUserText.label: 'Priority Desc'
      PriorityDesc,
      @EndUserText.label: 'Entity'
      Entity,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Developement Status'
      DevelopmentStatus,
      @EndUserText.label: 'Developement Status Desc'
      DevStatusDesc,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Testing Status'
      TestingStatus,
      @EndUserText.label: 'Testing Status Desc'
      TestingDesc,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Client Testing Status'
      ClientTestingStatus,
      @EndUserText.label: 'Client Testing Status Desc'
      ClntStatusDesc,
      @EndUserText.label: 'Developer'
      Developer,
      @EndUserText.label: 'Functional'
      Finctional,
      @EndUserText.label: 'Transport Number'
      TransportNo,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Deployed'
      Deployed,
      @EndUserText.label: 'Deployed Desc'
      DeployedDesc,
      @EndUserText.label: 'Remarks'
      Remarks,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Stage'
      Stage,
      @EndUserText.label: 'Stage Desc'
      StageDesc,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'FSD Status'
      FdsStatus,
      @EndUserText.label: 'FSD Status Desc'
      FSDDesc,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'TSD Status'
      TsdStatus,
      @EndUserText.label: 'TSD Status Desc'
      TSDDesc,
      @EndUserText.label: 'Last Changed By'
      LastChangedBy,
      @EndUserText.label: 'Last Changed On'
      LastChangedOn,
      @EndUserText.label: 'Last Changed At'
      LastChangedAt,
      @EndUserText.label: 'FS Target Date'
      Fstardat,
      @EndUserText.label: 'FS Completiom Date'
      Fscomdat,
      @EndUserText.label: 'Development Target Date'
      Devtardat,
      @EndUserText.label: 'Development Completion Date'
      Devcomdat,
      @EndUserText.label: 'Rework'
      Rework,
      @EndUserText.label: 'Rework Remarks'
      Reworkrem,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Overall Dtatus'
      OverallStat,
      @EndUserText.label: 'Overall Dtatus Desc'
      Overalldesc

}
