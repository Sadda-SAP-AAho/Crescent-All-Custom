@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_2

  as select distinct from ZV_COSTINGPL_7 as a

    left outer join       zdt_cost_glpl  as b on b.gl = a.GLAccount

{

  key    a.CompanyCode,
  key    a.AccountingDocument,
  key    a.FiscalYear,
  key    a.AccountingDocumentItem,
  key    a.AssignmentReference,
         a.GLAccount,
         b.gltype,
         a.CompanyCodeCurrency,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         case when b.gltype = 1 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as FumigationCharges,
         case when b.gltype = 2 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as ContainerFreight,
         case when b.gltype = 3 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as ExcelloDocumentPortCharges,
         case when b.gltype = 4 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as THCCharges,
         case when b.gltype = 5 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as RadiationChecking,
         case when b.gltype = 6 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as InspectionCharges,
         case when b.gltype = 7 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as FreightUSD,
         case when b.gltype = 8 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as ECGCPREMIUMRATE,
         case when b.gltype = 9 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end  as ShortRelisationCharges,
         case when b.gltype = 10 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as CreditPeriodCharges,
         case when b.gltype = 11 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as BankAdvCharges,
         case when b.gltype = 12 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as CommissionCharges,
         case when b.gltype = 13 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as ClaimagainstDamagedMaterials,
         case when b.gltype = 14 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as VariancePerKg,
         case when b.gltype = 15 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as FreightreceivedAmount,
         case when b.gltype = 16 then cast( a.AmountInCompanyCodeCurrency as abap.dec(23,2) ) else 0 end as PatternSale

}

where
  a.AssignmentReference is not initial
