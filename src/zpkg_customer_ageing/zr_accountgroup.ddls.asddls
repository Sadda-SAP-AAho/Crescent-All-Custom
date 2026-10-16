@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_ACCOUNTGROUP as select distinct from I_BusinessPartnerCustomer as a
 inner join I_CustomerAccountGroupText     as h on  h.CustomerAccountGroup = a.CustomerAccountGroup
                                                        and h.Language             = 'E'
{
    key a.CustomerAccountGroup,
    h.AccountGroupName as type
}
