@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help CDS View for comm ID'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMM_ID_VH
  as select from zdt_expensecal
{
      @UI.hidden: true
  key id       as Id,
      commid   as Commid,
      commdate as Commdate
      //        servicepobt as Servicepobt,
      //        poupd as Poupd,
      //        taxcode as Taxcode,
      //        profitcenter as Profitcenter,
      //        costcenter as Costcenter
}
