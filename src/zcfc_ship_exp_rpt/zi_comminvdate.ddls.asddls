@AbapCatalog.sqlViewName: 'ZCOMMINVDATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Comm Inv Date'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_COMMINVDATE
  as select distinct from ZI_EXPENSECAL            as a
    inner join            I_ServiceEntrySheetAPI01 as b on b.ServiceEntrySheetName = a.Commid
{
  key    b.ServiceEntrySheetName as Commid,
         a.Commdate
}
