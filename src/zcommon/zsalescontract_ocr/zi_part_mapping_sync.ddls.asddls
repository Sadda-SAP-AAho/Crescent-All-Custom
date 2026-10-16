@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Customer Part Mapping Sync'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PART_MAPPING_SYNC
  as select from ZR_SCITM               as a
    inner join   ZR_SCHDR               as d on  a.Docuuid = d.Docuuid
    inner join   I_ProductDescription_2 as b on  a.ProductCode = b.Product
                                             and b.Language    = $session.system_language
    inner join   I_SalesContract        as c on  d.SalesContract = c.SalesContract
{
  key c.SalesContract,
  key a.PartNumber                        as MatByCustomerSC,

      concat( c.SalesContract, concat( '-', a.PartNumber ) ) as SyncKey,

      a._Header.PoNumber                  as CustPONo,
      a.Description                       as CustDescAsPerPO,
      a.Plant,
      a._Header.OrderDate                 as CustPODt,
      a._Header.CustomerCode              as CustCode,
      a.ProductCode                       as MatCode,
      b.ProductDescription                as MatName,
      b._Product.ProductExternalID        as MatByCustomerMI,
      c.SalesContractDate                 as SalesContDt,
      tstmpl_to_utcl( c.LastChangeDateTime, 'NULL', 'NULL' ) as UpdatedAt,
      tstmpl_to_utcl(
        cast( dats_tims_to_tstmp( c.CreationDate, c.CreationTime,
                                  abap_system_timezone( $session.client, 'NULL' ),
                                  $session.client, 'NULL' ) as abap.dec(21,7) ),
        'NULL', 'NULL' )                  as CreatedAt,

      tstmpl_to_utcl( a.LocalChangedAt, 'NULL', 'NULL' )     as ItemChangedAt
}
where d.SalesContract is not initial
