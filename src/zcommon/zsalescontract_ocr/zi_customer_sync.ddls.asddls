@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Sync'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CUSTOMER_SYNC
  as select from    I_CustomerSalesArea as A
    left outer join I_BusinessPartner   as B on B.BusinessPartner = A.Customer
{
  key A.Customer,
  key A.SalesOrganization,
  key A.DistributionChannel,
  key A.Division,

      concat( A.Customer, concat( '-',
      concat( A.SalesOrganization, concat( '-',
      concat( A.DistributionChannel, concat( '-', A.Division ) ) ) ) ) ) as SyncKey,

      B.BusinessPartnerName      as CustomerName,
      A.CustomerPricingProcedure,

      tstmpl_to_utcl(
        cast( dats_tims_to_tstmp( B.LastChangeDate, B.LastChangeTime,
                                  abap_system_timezone( $session.client, 'NULL' ),
                                  $session.client, 'NULL' ) as abap.dec(21,7) ),
        'NULL', 'NULL' )         as UpdatedAt,

      tstmpl_to_utcl(
        cast( dats_tims_to_tstmp( B.CreationDate, B.CreationTime,
                                  abap_system_timezone( $session.client, 'NULL' ),
                                  $session.client, 'NULL' ) as abap.dec(21,7) ),
        'NULL', 'NULL' )         as CreatedAt
}
