@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Complaint Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_CUSTCOMPRPT
  provider contract transactional_query
  as projection on ZI_CUSTCOMPRPT
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Notification No'
  key Notification_No,
  
      @EndUserText.label: 'Notification Date'
      Notification_Date,
      
      @EndUserText.label: 'Status'
      Status,
      
      @EndUserText.label: 'Created By'
      CreatedBy,
      
      @EndUserText.label: 'Reported By'
      Reportedby,
      
      @EndUserText.label: 'Customer Code'
      SoldtoParty,
      
      @EndUserText.label: 'Material No.'
      Material,
      
      @EndUserText.label: 'Description'
      Description,
      
      @EndUserText.label: 'Plant'
      Plant,
      
      @EndUserText.label: 'Complaint Qty'
      ComplaintQty,
      
      @UI.hidden: true
      NotificationQuantityUnit,
      
      @EndUserText.label: 'Type'
      Priority,
      
      @EndUserText.label: 'Subject'
      SubjectlongText,
      
      @EndUserText.label: 'Co-ordinator'
      Coordinator,
      
      @EndUserText.label: 'Task Text'
      TaskText,
      
      @EndUserText.label: 'Financial Impact'
      Defect_Loc,
      
      @EndUserText.label: 'Currency'
      DefectCode,
      
      @EndUserText.label: 'Amount'
      NotificationItemText,
      
      @EndUserText.label: 'Responsible'
      Responsible
}
