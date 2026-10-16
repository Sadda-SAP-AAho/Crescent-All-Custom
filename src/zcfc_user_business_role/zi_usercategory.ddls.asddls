@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Wise Business Role Category'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_USERCATEGORY
  as select from I_IAMBusinessUserBusinessRole  as ur

    inner join   I_IAMBusinessRolePriceCategory as rpc on ur.BusinessRole = rpc.BusinessRole

{
  key ur.UserID as User_Id,

      max(
        case
          when rpc.BusinessRolePriceCategory = 'ADVANCED'
            then 3
          when rpc.BusinessRolePriceCategory = 'CORE'
            then 2
          when rpc.BusinessRolePriceCategory = 'SELFSERVICE'
            then 1
          else 0
        end
      )         as Category_Priority
}
group by
  ur.UserID
