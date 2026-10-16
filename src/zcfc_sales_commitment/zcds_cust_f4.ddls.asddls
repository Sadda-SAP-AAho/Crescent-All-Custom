@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Customer F4 Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_CUST_F4 as select from I_BusinessPartner
{
 key  BusinessPartner,
      BusinessPartnerName
    
}where ( BusinessPartnerGrouping = 'ZDMC' or BusinessPartnerGrouping = 'ZEXC' );
