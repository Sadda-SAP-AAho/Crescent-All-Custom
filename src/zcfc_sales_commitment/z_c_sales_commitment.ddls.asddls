@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Commitment Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_Sales_Commitment
  provider contract transactional_query
  as projection on Z_I_Sales_Commitment
{
  key Requestuuid,
      docnum,
      keyid,
      sales_comm_name,
      Sales_employee_code,
      Sales_employee_name,
      Fiscal_year,
      Created_at      as Created_at,
      Created_by      as Created_by,
      Last_changed_at as Last_changed_at,
      Last_changed_by as Last_changed_by,
      commitment_type as Commitment_type,
      _Item : redirected to composition child Z_C_Sales_Cmmt_Item
}
