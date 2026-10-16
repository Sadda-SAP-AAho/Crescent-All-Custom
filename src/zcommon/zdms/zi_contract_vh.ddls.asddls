@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_CONTRACT_VH'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZI_CONTRACT_VH 
as select from I_SalesContract as salescontract
left outer join ZI_GROUPED_DOC as b on salescontract.SalesContract = lpad(b.RefObjectKey,10,'0') and b.RefObjectType = 'SC'

{

//@UI.lineItem: [{  position: 10}]
//  @UI.identification: [{ position: 10 }]
//  @UI.selectionField: [{ position: 10 }]
  key salescontract.SalesContract,
  
//  @UI.lineItem: [{  position: 20}]
//  @UI.identification: [{ position: 20 }]
//  @UI.selectionField: [{ position: 20 }]
@Search.defaultSearchElement: true
  salescontract.SalesContractType,
  salescontract.SoldToParty,
  salescontract.SalesOrganization,
  salescontract.CustomerGroup,
  b.DocCount
  
}
