@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Material Serial Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATSERIALNO
  as select from    I_SerialNumberStockSegment as a
    inner join      I_Equipment                as b on a.Equipment = b.Equipment
    left outer join I_BusinessUserBasic        as c on b.CreatedByUser = c.UserID
{
  key a.Material,
  key a.SerialNumber,
  key a.Plant,
  key a.StorageLocation,
      b.CreationDate,
      c.PersonFullName as CreatedBy
}
