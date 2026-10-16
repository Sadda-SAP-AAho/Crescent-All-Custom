@AbapCatalog.sqlViewName: 'ZMATACCASSGNGRP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Acc Assign Grp-Mat'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MATACCASSGNGRP
  as select from    I_Product                     as a
    left outer join I_ProductSalesDelivery        as b on a.Product = b.Product
    left outer join I_MatlAccountAssignmentGroupT as c on  b.AccountDetnProductGroup = c.MatlAccountAssignmentGroup
                                                       and c.Language                = 'E'
                                                       and b.AccountDetnProductGroup is not initial
{
  key a.Product,
      max( b.AccountDetnProductGroup )        as AccAssgnGrpCode,
      max( c.MatlAccountAssignmentGroupName ) as AccAssgnGrpName,
      max(b.ThirdSalesSpecProductGroup)       as MatGrp3
}
group by
  a.Product
