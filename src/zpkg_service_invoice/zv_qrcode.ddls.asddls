@AbapCatalog.sqlViewName: 'ZVQRCODE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for QR Code'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_QRCODE
  as select from I_IN_ElectronicDocInvoice
{
  key ElectronicDocUUID,
      ElectronicDocCompanyCode,
      ElectronicDocCountry,
      ElectronicDocSourceType,
      ElectronicDocSourceKey,
      ElectronicDocType,
      ElectronicDocProcessStatus,
      ElectronicDocProcess,
      IN_EDocEInvcExtNmbr,
      IN_EDocEInvcBusinessPlace,
      IN_ElectronicDocInvcRefNmbr,
      IN_ElectronicDocAcknNmbr,
      IN_ElectronicDocAcknDate,
      IN_ElectronicDocAcknTime,
      IN_ElectronicDocCancelDate,
      IN_ElectronicDocCancelTime,
      IN_ElectronicDocCancReasonCode,
      IN_EDocCancelRemarksTxt,
      IN_ElectronicDocQRCodeTxt,
      IN_EDocEInvcEWbillNmbr,
      IN_EDocEInvcEWbillCreateDate,
      IN_EDocEInvcEWbillCreateTime,
      IN_EDocEInvcEWbillValidityDate,
      IN_EDocEInvcEWbillValidityTime,
      IN_EDocEWbillStatus,
      IN_EDocEInvcEditActionFlag,
      IN_EDocEInvcTransptDocNmbr,
      IN_EDocEInvcTransptDocDate,
      IN_EDocEInvcTransptDstncVal,
      IN_EDocEInvcVehicleNumber,
      IN_EDocEInvcVehicleType,
      IN_EDocEInvcTransptMode,
      IN_EDocEInvcTransptrName,
      IN_EDocEInvcTransptrGSTIN
}
