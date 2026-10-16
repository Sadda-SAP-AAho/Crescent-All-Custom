@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RFQ Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_RFQ_STATUS
  as select distinct from ZI_FESVACREG as a
    left outer join       ZI_ESTVACREG as b on a.Rfqno = b.rfqno
{
  key a.Id                      as Id,
      a.Rfqno                   as Rfqno,
      a.Rfqdate                 as Rfqdate,
      a.Mktgusr                 as Marketing_Person,
      ( case when a.Custcd is not initial
           then a.Custcd
           else a.Custcd2 end ) as Customer_Code,
      a.Custname                as Customer_Name,
      cast(
         case
           when a.Pduser is initial
             then 'Feasibility Pending-PD Part'

           when b.rfqno is not initial
             then 'Estimate Done'

           else
             'Estimate Pending'
         end
         as abap.char(30)
       )                        as RFQ_Status


}
