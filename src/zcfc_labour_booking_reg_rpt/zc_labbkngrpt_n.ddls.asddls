@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Booking-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_LABBKNGRPT_N
  provider contract transactional_query
  as projection on ZI_LABBKNGRPT
{
      
  
      @EndUserText.label: 'Type'  
  key Type,    
      @EndUserText.label: 'Labour Exp Booking No'
      @Search.defaultSearchElement: true
  key Docnum,
      @UI.hidden: true
  key Id,
      @UI.hidden: true
  key Item,
      @EndUserText.label: 'Booking Date'
      @Consumption.filter.mandatory: true
      Rptdate,
      @EndUserText.label: 'Create Date'
      Creon,
      @EndUserText.label: 'Created By'
      Creby,
      @EndUserText.label: 'Plant Code'
      @Consumption.filter.mandatory: true
      Plantcode,
      @EndUserText.label: 'Plant Name'
      Plantname,
      @EndUserText.label: 'Contractor Code'
      Contcode,
      @EndUserText.label: 'Contractor Name'
      Contname,
      @EndUserText.label: 'Department'
      Costname,
      @EndUserText.label: 'Operation Code'
      Oprcode,
      @EndUserText.label: 'Operation Name'
      Oprname,
      @EndUserText.label: 'Work Code'
      Workcode,
      @EndUserText.label: 'Work Description'
      Workname,
      @EndUserText.label: 'Quantity'
      Quantity,
      @EndUserText.label: 'Rate'
      Rate,
      @EndUserText.label: 'Amount'
      Amount,
      @EndUserText.label: 'Approved By'
      Aprvname,
      @EndUserText.label: 'Remark'
      Remark

}
