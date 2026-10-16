@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View of Labour Attendance Register Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_LABATTNDREGRPT
  provider contract transactional_query
  as projection on ZI_LABATTNDREGRPT
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Docnum'
      Docnum,
      @EndUserText.label: 'Createdby'
      PersonFullName,
      @EndUserText.label: 'Createdon'
      Creon,
      @EndUserText.label: 'Reportdate'
      Reportdate,
      @EndUserText.label: 'Plantcode'
      Plantcode,
      @EndUserText.label: 'Plantname'
      Plantname,
      @EndUserText.label: 'Contractor Code'
      Contcode,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Department Code'
      Deptcode,
      @EndUserText.label: 'Department Name'
      Deptname,
      @EndUserText.label: 'Category'
      Category,
      @EndUserText.label: 'Operation Code'
      Oprcode,
      @EndUserText.label: 'Operation Name'
      Oprname,
      @EndUserText.label: 'No. of Heads'
      Noofhead
}
