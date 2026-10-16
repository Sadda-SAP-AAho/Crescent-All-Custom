@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Org F4 Help'
define view entity ZR_SALESORG_F4 
       as select distinct from I_SalesOrganization as a
       left outer join I_SalesOrder as b on a.CompanyCode = b.BillingCompanyCode
{
    key a.SalesOrganization,
    key a.CompanyCode,
    key b.YY1_SD_SORD_Company_Na_SDH
}
where b.YY1_SD_SORD_Company_Na_SDH <> ''
