@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for tabl func'
@Metadata.ignorePropagatedAnnotations: true
@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.sqlViewName: 'ZI_TBLFUNCBOP'
define view ZCDS_TBLFUNC_VIEW
  as select from ZTBL_FUNC_BILLOFOP
                 
{
       key ActivityType,
       key CostCenter,
           Currency,
           CostRateFixedAmount,
           ValidityStartDate,
           ValidityEndDate
   
}
group by ActivityType,
         CostCenter,
         Currency,
         CostRateFixedAmount,
         ValidityStartDate,
         ValidityEndDate
         

