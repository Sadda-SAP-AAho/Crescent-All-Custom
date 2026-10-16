@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Export Charges F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zr_chargesexp 
       as select distinct from ZI_BNKCHARGE_HDR {

   key Bnkchargename
    
}
where Category = 'EXPORT' and Active  =  'X' and  Glcode <> ''
