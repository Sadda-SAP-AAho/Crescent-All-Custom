@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtor Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_27

  as select distinct from I_CustomerSalesArea as a

    inner join            ztmg_salesgrp       as b on b.salesgroup = a.SalesGroup

{

  key a.Customer,
      max( b.salesperson ) as salesperson
}

where
  b.configdeprecationcode <> 'E'

group by
  a.Customer
