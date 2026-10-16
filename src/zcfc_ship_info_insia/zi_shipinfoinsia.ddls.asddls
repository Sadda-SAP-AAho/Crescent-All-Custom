@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipment Information-Insia'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SHIPINFOINSIA
  as select distinct from zi_exportregister as a
    inner join            I_BillingDocument as b on a.GSTInvoiceNumber = b.BillingDocument
{
  key a.GSTInvoiceNumber  as Tax_Inv_No,
  key a.GSTInvoiceDate    as Tax_Inv_Date,
  key a.CommercialInvNo   as Comm_Inv_No,
      a.CommercialInvDate as Comm_Inv_Date,
      b.CreationDate      as CreateDate,
      b.LastChangeDate    as UpdateDate,
      a.BPCode            as Customer,
      a.BLNo              as BL_No,
      a.BLDt              as BL_Date,
      a.Contno            as Container_No,
      a.netwt             as Net_Weight,
      a.growt             as Gross_Weight,
      a.Etadt             as Tentative_ETA,
      a.Etddt             as Actual_ETA,
      a.Currency,
      a.ExchangeRate,
      a.ValueInDC,
      a.ValueInLC
}


