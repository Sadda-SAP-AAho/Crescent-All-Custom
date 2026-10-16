@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Posting Date-1'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_POSTINGDATE_1
  as select distinct from I_MaterialDocumentItem_2   as a

    inner join            I_MaterialDocumentHeader_2 as b  on a.MaterialDocument = b.MaterialDocument

    left outer join       I_Productplantqtmanagement as b1 on  a.Material = b1.Product
                                                           and a.Plant    = b1.Plant

    left outer join       I_InspLotMatlDocItem       as c  on  b.MaterialDocument     = c.MaterialDocument
                                                           and b.MaterialDocumentYear = c.MaterialDocumentYear
                                                           and a.MaterialDocumentItem = c.MaterialDocumentItem

    left outer join       ZI_GR_INSP_MATL_DOC        as d  on  c.InspectionLot = d.GRInspLotNo
                                                           and d.QltyInspLotNo is not initial

    left outer join       I_MaterialDocumentHeader_2 as e  on  d.QltyMatlDocNo = e.MaterialDocument
                                                           and d.QltyMatlDocYr = e.MaterialDocumentYear
{
         //  key    a.MaterialDocument,
  key    b.MaterialDocumentHeaderText                                                 as shpflrno,
  key    (case when b1.ProductPlantHasInspectionSetup = 'X' and d.QltyInspLotNo is not initial then e.PostingDate
               when b1.ProductPlantHasInspectionSetup = 'X' and d.QltyInspLotNo is initial then cast( 'X' as abap.dats )
               when b1.ProductPlantHasInspectionSetup <> 'X' then b.PostingDate end ) as PostingDate

}
where
       a.GoodsMovementType          = '101'
  and(
       a.StorageLocation            = 'SASG'
    or a.StorageLocation            = 'KUSG'
    or a.StorageLocation            = 'BGSG'
    or a.StorageLocation            = 'BASG'
    or a.StorageLocation            = 'SAFG'
    or a.StorageLocation            = 'KUFG'
    or a.StorageLocation            = 'BGFG'
    or a.StorageLocation            = 'BAFG'
  )
  and  a.GoodsMovementIsCancelled   is initial
  and  b.MaterialDocumentHeaderText is not initial
