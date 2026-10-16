@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Commitment Dashboard View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity Z_I_Sales_Commitment
  as select from zsales_commitmnt as _Sales
  composition [1..*] of Z_I_SALES_COMMT_ITEM as _Item
{
  key _Sales.requestuuid         as Requestuuid,
      _Sales.docnum              as docnum,
      _Sales.keyid               as keyid,
      _Sales.sales_comm_name     as sales_comm_name,
      _Sales.sales_employee_code as Sales_employee_code,
      _Sales.sales_employee_name as Sales_employee_name,
      _Sales.fiscal_year         as Fiscal_year,
      @Semantics.systemDateTime.createdAt: true
      _Sales.created_at          as Created_at,
      @Semantics.user.createdBy: true
      _Sales.created_by          as Created_by,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Sales.last_changed_at     as Last_changed_at,
      @Semantics.user.localInstanceLastChangedBy: true
      _Sales.last_changed_by     as Last_changed_by,
      commitment_type,
      _Item

};
