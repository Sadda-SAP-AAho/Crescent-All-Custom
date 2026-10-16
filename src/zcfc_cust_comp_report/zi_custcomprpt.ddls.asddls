@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Complaint Report'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_CUSTCOMPRPT
  as select from    I_QltyNotification           as a
    left outer join I_QltyNotificationLongText   as b on b.QualityNotification = a.QualityNotification
    left outer join I_QualityNotificationPartner as c on c.PartnerFunction = 'KU'
    left outer join I_QltyNotificationTask       as d on d.QualityNotification = a.QualityNotification
    left outer join I_QualityNotificationItem    as e on e.QualityNotification = a.QualityNotification
    left outer join I_BusinessUserBasic          as f on f.UserID = a.CreatedByUser
    left outer join I_BusinessUserBasic          as g on g.UserID = c.Partner
    left outer join I_BusinessUserBasic          as h on h.UserID = d.ResponsiblePerson
    left outer join I_ProductText                as i on i.Product = a.Material

{

  key a.QualityNotification                                                                                                                   as Notification_No,
      a.NotificationReportingDate                                                                                                             as Notification_Date,
      (case when cast( a.NotifProcessingPhase as abap.char(1) ) = '5' then 'Close' else 'Open' end ) as Status,
      upper( f.PersonFullName )                                                                                                               as CreatedBy,
      upper( a.ReportedByUser )                                                                                                               as Reportedby,
      a.Customer                                                                                                                              as SoldtoParty,
      a.Material                                                                                                                              as Material,
      i.ProductName                                                                                                                           as Description,
      a.Plant                                                                                                                                 as Plant,
      @Semantics.quantity.unitOfMeasure: 'NotificationQuantityUnit'
      a.NotificationComplaintQuantity                                                                                                         as ComplaintQty,
      a.NotificationQuantityUnit,
      ( case when a.NotificationPriority = '1'
               or a.NotificationPriority = '2'
               or a.NotificationPriority = '3' then 'Customer Complaint'
             when a.NotificationPriority = '4' then 'Customer Feedback' end )                                                                 as Priority,
      b.QltyNotificationLongText                                                                                                              as SubjectlongText,
      upper( g.PersonFullName )                                                                                                               as Coordinator,
      d.NotificationTaskText                                                                                                                  as TaskText,
      ( case when e.NotifItmObjectPartCode = '01' then 'Billable'
             when e.NotifItmObjectPartCode = '02' then 'Non-Billable' end )                                                                   as Defect_Loc,
      e.DefectCode,
      e.NotificationItemText,

      upper( h.PersonFullName )                                                                                                               as Responsible

}

where
  substring( c.NotificationPartnerObject, 3, length(c.NotificationPartnerObject) - 2 ) = a.QualityNotification
