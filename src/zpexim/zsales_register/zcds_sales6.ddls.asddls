@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS for Sales Register'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZCDS_SALES6

  as select distinct from ZCDS_SALES_TMP1           as A

    left outer join       I_IN_ElectronicDocInvoice as B on A.GstInvoice = B.ElectronicDocSourceKey

{
  key A.GstInvoice                   as GSTInNo,

      B.ElectronicDocUUID,
      B.IN_ElectronicDocInvcRefNmbr,
      B.IN_EDocEInvcEWbillNmbr
}

where B.ElectronicDocProcessStatus = 'GEN_EINV'
   or     B.ElectronicDocProcessStatus = 'COMPLETED'
      and B.IN_EDocEWbillStatus        = 'EWBGEN'
