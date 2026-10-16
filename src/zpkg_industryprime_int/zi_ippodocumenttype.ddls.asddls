@EndUserText.label: 'IP PO Document Type'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_IpPoDocumentType
  as select from ZDT_IP_DOC_TMG
  association to parent ZI_IpPoDocumentType_S as _IpPoDocumentTypeAll on $projection.SingletonID = _IpPoDocumentTypeAll.SingletonID
{
  key MATERIALGROUP as Materialgroup,
  PODOCTYPE as Podoctype,
  @Consumption.hidden: true
  1 as SingletonID,
  _IpPoDocumentTypeAll
  
}
