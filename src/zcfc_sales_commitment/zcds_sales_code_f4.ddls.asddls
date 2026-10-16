@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Sales Employee Code F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SALES_CODE_F4 as select from  ztmg_salesgrp
{
    key salesgroup as SalesGroup,
        salesperson as SalesPerson
}where configdeprecationcode <> 'E';
