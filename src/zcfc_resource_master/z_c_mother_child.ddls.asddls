@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Mother Child Ctgory'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_MOTHER_CHILD provider contract transactional_query as projection on Z_I_Mother_Child
{
    key Requestuuid,
    Mother_child_catagory,
  @Semantics.systemDateTime.createdAt: true
  Created_at     as Created_at,
 @Semantics.user.createdBy: true
  Created_by    as Created_by,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  Last_changed_at    as Last_changed_at,
  @Semantics.user.localInstanceLastChangedBy: true
  Last_changed_by    as Last_changed_by,
  

   @UI.lineItem: [{ position: 60,criticality: 'StatusCriticality' , criticalityRepresentation: #WITH_ICON }]
   @UI.identification: [{ position: 60 }]
@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_STATUS'
@EndUserText.label: 'Status'
    virtual UpdateStatus : abap.char(10),
    
    
    @UI.hidden: true
   @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_STATUS'
   virtual StatusCriticality : abap.int4 // Fiori uses 1 (Red), 2 (Orange), 3 (Green)
}
