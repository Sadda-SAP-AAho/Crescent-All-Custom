@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for MetalCrateProduction'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_METALCRATE 
as select from ZCDS_METALCRTPRD as A
left outer join ZTBL_FCTN_METALCRATE1( mandt: $session.client ) as B on A.Material = B.material
                                                                        and A.Plant  = B.plant
inner join I_Product as C on B.itemcode = C.Product
left outer join ZI_MATFLD as D on B.material = D.Product
{
  key A.mandt_1,
      A.SalesOrdNo,
      A.LineNumber,
      A.ItemCode,
      A.SalesOrdDate,
      A.CustomerCode,
      A.ItemName,
      A.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      A.Openqty,
      B.itemcode   as  MetalCrateItem,
      B.BillOfMaterialItemQuantity  as  QtyToBeProduced,
      D.Pltpcdboxsize,
      D.Boltsize,
      D.Pcspack   as  NoOfPackReq,
      D.Qtyboltunitcons  as  NoOfBoltReq
       
} where C.ProductGroup = 'Z041'
