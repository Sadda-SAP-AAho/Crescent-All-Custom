@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for PP Casting Details 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_pp_casting_dlts2
  as select distinct from ZI_CONF_ORD                as a
    inner join            ZI_CONF_ITM                as d on  d.Id       = a.Id
                                                          and d.Item     = a.Item
                                                          and d.Shpflrno = a.Shpflrno
    inner join            I_MaterialDocumentHeader_2 as b on b.MaterialDocumentHeaderText = a.Shpflrno
    inner join            I_MaterialDocumentItem_2   as c on  (
        c.GoodsMovementType                                                      = '101'
        or c.GoodsMovementType                                                   = '321'
      )
                                                          and c.Material         = d.Matnr
                                                          and c.MaterialDocument = b.MaterialDocument
{
  key a.Shpflrno,
  key b.MaterialDocument

}
