@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Labour Attendance Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_LABATTNDREGRPT
  as select distinct from ZI_LABATTNHEAD      as a
    inner join            ZI_LABATTNITEM      as b on a.Id = b.Id
    left outer join       I_BusinessUserBasic as c on a.Creby = c.UserID
{
  key  a.Id,
  key  b.Item,
       a.Docnum,
       c.PersonFullName,
       a.Creon,
       a.Reportdate,
       a.Plantcode,
       a.Plantname,
       b.Contcode,
       b.Contname,
       b.Deptcode,
       b.Deptname,
       b.Category,
       b.Oprcode,
       b.Oprname,
       b.Noofhead

}
