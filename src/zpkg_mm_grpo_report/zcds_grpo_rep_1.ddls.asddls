@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GRPO Standard Actual Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GRPO_REP_1
  as select from    I_MaterialDocumentHeader_2 as a
    inner join      I_MaterialDocumentItem_2   as b   on  b.MaterialDocument     = a.MaterialDocument
                                                      and b.MaterialDocumentYear = a.MaterialDocumentYear
    left outer join ZTBL_FCTN_GRPO_RPT         as c   on  c.MaterialDocument     = b.MaterialDocument
                                                      and c.MaterialDocumentItem = b.MaterialDocumentItem
                                                      and c.MaterialDocumentYear = b.MaterialDocumentYear
    left outer join I_Supplier                 as d   on d.Supplier = b.Supplier
    left outer join I_ProductText              as e   on  e.Product  = b.Material
                                                      and e.Language = 'E'
    left outer join I_Product                  as f   on f.Product = b.Material
    left outer join I_ProductGroupText_2       as g   on f.ProductGroup = g.ProductGroup
    left outer join ZTBL_FCTN_MAT_SPEC         as g1  on  g1.Material                = b.Material
                                                      and g1.Plant                   = b.Plant
                                                      and g1.inspectionspecification = 'CE%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g2  on  g2.Material                = b.Material
                                                      and g2.Plant                   = b.Plant
                                                      and g2.inspectionspecification = 'S%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g3  on  g3.Material                = b.Material
                                                      and g3.Plant                   = b.Plant
                                                      and g3.inspectionspecification = 'MN%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g4  on  g4.Material                = b.Material
                                                      and g4.Plant                   = b.Plant
                                                      and g4.inspectionspecification = 'SI%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g5  on  g5.Material                = b.Material
                                                      and g5.Plant                   = b.Plant
                                                      and g5.inspectionspecification = 'C%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g6  on  g6.Material                = b.Material
                                                      and g6.Plant                   = b.Plant
                                                      and g6.inspectionspecification = 'VM%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g7  on  g7.Material                = b.Material
                                                      and g7.Plant                   = b.Plant
                                                      and g7.inspectionspecification = 'SR%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g8  on  g8.Material                = b.Material
                                                      and g8.Plant                   = b.Plant
                                                      and g8.inspectionspecification = 'P %'
    left outer join ZTBL_FCTN_MAT_SPEC         as g9  on  g9.Material                = b.Material
                                                      and g9.Plant                   = b.Plant
                                                      and g9.inspectionspecification = 'CA%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g10 on  g10.Material                = b.Material
                                                      and g10.Plant                   = b.Plant
                                                      and g10.inspectionspecification = 'AI%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g11 on  g11.Material                = b.Material
                                                      and g11.Plant                   = b.Plant
                                                      and g11.inspectionspecification = 'ASH%'
    left outer join ZTBL_FCTN_MAT_SPEC         as g12 on  g12.Material                = b.Material
                                                      and g12.Plant                   = b.Plant
                                                      and g12.inspectionspecification = 'FIXC'
    left outer join ZTBL_FCTN_MAT_SPEC         as g13 on  g13.Material                = b.Material
                                                      and g13.Plant                   = b.Plant
                                                      and g13.inspectionspecification = 'MOISTURE'
    left outer join ZTBL_FCTN_MAT_SPEC         as g14 on  g14.Material                = b.Material
                                                      and g14.Plant                   = b.Plant
                                                      and g14.inspectionspecification = 'GEL'
    left outer join ZCDS_INSPEC_GRPO           as h1  on  h1.MaterialDocument        = b.MaterialDocument
                                                      and h1.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h1.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h1.InspectionSpecification = 'CE%'
    left outer join ZCDS_INSPEC_GRPO           as h2  on  h2.MaterialDocument        = b.MaterialDocument
                                                      and h2.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h2.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h2.InspectionSpecification = 'S%'
    left outer join ZCDS_INSPEC_GRPO           as h3  on  h3.MaterialDocument        = b.MaterialDocument
                                                      and h3.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h3.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h3.InspectionSpecification = 'MN%'
    left outer join ZCDS_INSPEC_GRPO           as h4  on  h4.MaterialDocument        = b.MaterialDocument
                                                      and h4.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h4.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h4.InspectionSpecification = 'SI%'
    left outer join ZCDS_INSPEC_GRPO           as h5  on  h5.MaterialDocument        = b.MaterialDocument
                                                      and h5.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h5.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h5.InspectionSpecification = 'C%'
    left outer join ZCDS_INSPEC_GRPO           as h6  on  h6.MaterialDocument        = b.MaterialDocument
                                                      and h6.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h6.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h6.InspectionSpecification = 'VM%'
    left outer join ZCDS_INSPEC_GRPO           as h7  on  h7.MaterialDocument        = b.MaterialDocument
                                                      and h7.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h7.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h7.InspectionSpecification = 'SR%'
    left outer join ZCDS_INSPEC_GRPO           as h8  on  h8.MaterialDocument        = b.MaterialDocument
                                                      and h8.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h8.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h8.InspectionSpecification = 'P %'
    left outer join ZCDS_INSPEC_GRPO           as h9  on  h9.MaterialDocument        = b.MaterialDocument
                                                      and h9.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h9.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h9.InspectionSpecification = 'CA%'
    left outer join ZCDS_INSPEC_GRPO           as h10 on  h10.MaterialDocument        = b.MaterialDocument
                                                      and h10.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h10.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h10.InspectionSpecification = 'AI%'
    left outer join ZCDS_INSPEC_GRPO           as h11 on  h11.MaterialDocument        = b.MaterialDocument
                                                      and h11.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h11.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h11.InspectionSpecification = 'ASH%'
    left outer join ZCDS_INSPEC_GRPO           as h12 on  h12.MaterialDocument        = b.MaterialDocument
                                                      and h12.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h12.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h12.InspectionSpecification = 'FIXC'
    left outer join ZCDS_INSPEC_GRPO           as h13 on  h13.MaterialDocument        = b.MaterialDocument
                                                      and h13.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h13.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h13.InspectionSpecification = 'MOISTURE'
    left outer join ZCDS_INSPEC_GRPO           as h14 on  h14.MaterialDocument        = b.MaterialDocument
                                                      and h14.MaterialDocumentItem    = b.MaterialDocumentItem
                                                      and h14.MaterialDocumentYear    = b.MaterialDocumentYear
                                                      and h14.InspectionSpecification = 'GEL'
    left outer join ZCDS_INSDEC_GRPO           as i   on  i.MaterialDocument     = b.MaterialDocument
                                                      and i.MaterialDocumentItem = b.MaterialDocumentItem
                                                      and i.MaterialDocumentYear = b.MaterialDocumentYear
{
  key a.MaterialDocument,
  key b.MaterialDocumentItem,
  key b.MaterialDocumentYear,
      a.DocumentDate,
      b.Supplier,
      d.SupplierFullName,
      c.YY1_ChallanNumber_MMI,
      c.YY1_ChallanDate_MMI,
      i.decision,
      cast( '' as abap.dats( 8 ) )      as apinvdt,
      cast( '' as abap.char( 100 ) )    as appname,
      b.Plant,
      b.StorageLocation,
      b.Material,
      e.ProductName,
      f.ProductGroup,
      g.ProductGroupName,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.QuantityInEntryUnit,
      b.MaterialBaseUnit,
      g1.INSPSPECUPPERLIMIT             as ceupp,
      g1.INSPSPECUPPERLIMIT             as celow,
      h1.InspectionResultOriginalValue  as ceact,
      g2.INSPSPECUPPERLIMIT             as supp,
      g2.INSPSPECUPPERLIMIT             as slow,
      h2.InspectionResultOriginalValue  as sact,
      g3.INSPSPECUPPERLIMIT             as mnupp,
      g3.INSPSPECUPPERLIMIT             as mnlow,
      h3.InspectionResultOriginalValue  as mnact,
      g4.INSPSPECUPPERLIMIT             as siupp,
      g4.INSPSPECUPPERLIMIT             as silow,
      h4.InspectionResultOriginalValue  as siact,
      g5.INSPSPECUPPERLIMIT             as cupp,
      g5.INSPSPECUPPERLIMIT             as clow,
      h5.InspectionResultOriginalValue  as cact,
      g6.INSPSPECUPPERLIMIT             as vmupp,
      g6.INSPSPECUPPERLIMIT             as vmlow,
      h6.InspectionResultOriginalValue  as vmact,
      g7.INSPSPECUPPERLIMIT             as srupp,
      g7.INSPSPECUPPERLIMIT             as srlow,
      h7.InspectionResultOriginalValue  as sract,
      g8.INSPSPECUPPERLIMIT             as pupp,
      h8.InspectionResultOriginalValue  as pact,
      g9.INSPSPECUPPERLIMIT             as caupp,
      h9.InspectionResultOriginalValue  as caact,
      cast( '' as abap.char( 10 ) )     as ubamin,
      g10.INSPSPECUPPERLIMIT            as aiupp,
      h10.InspectionResultOriginalValue as aiact,
      g11.INSPSPECUPPERLIMIT            as ashupp,
      h11.InspectionResultOriginalValue as ashact,
      g12.INSPSPECUPPERLIMIT            as fixcupp,
      h12.InspectionResultOriginalValue as fixcact,
      g13.INSPSPECUPPERLIMIT            as moisupp,
      h13.InspectionResultOriginalValue as moisact,
      g14.INSPSPECUPPERLIMIT            as gelupp,
      h14.InspectionResultOriginalValue as gelact
}
where
      b.InventoryUsabilityCode   =  'X'
  and b.GoodsMovementIsCancelled <> 'X'
