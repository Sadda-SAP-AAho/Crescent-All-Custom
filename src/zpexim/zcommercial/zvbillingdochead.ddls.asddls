@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BILLING DOC'

define view entity ZVBILLINGDOCHEAD
  as select distinct from ZI_COMM_HED as a
  inner join       ZCDS_PLANT         as b on a.Commid = b.BillingDocument
  inner join       zdt_mm_pc_tmg      as c on b.CompanyCode = c.cocode and b.Plant = c.plant
  {
  key b.BillingDocument,
   b.CreationDate,
   b.CreationTime,
   c.caddress1,
   c.caddress2,
   c.name
  }
  group by 
  b.BillingDocument,
   b.CreationDate,
   b.CreationTime,
   c.caddress1,
   c.caddress2,
   c.name
 

    
