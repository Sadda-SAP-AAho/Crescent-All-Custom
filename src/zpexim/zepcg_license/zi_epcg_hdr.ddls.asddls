@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For EPCG Header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_EPCG_HDR
  as select from zdt_epcg_hdr
  composition [0..*] of ZI_EPCG_ITM as _item
{
  key id             as Id,
      ecomno         as Ecomno,
      waers          as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      totalcifvalue  as Totalcifvalue,
      @Semantics.amount.currencyCode: 'Waers'
      remaindutysave as Remaindutysave,
      ponum          as Ponum,
      bukrs          as Bukrs,
      @Semantics.amount.currencyCode: 'Waers'
      totaldutysave  as Totaldutysave,
      fileno         as Fileno,
      filedate       as Filedate,
      licno          as Licno,
      licdate        as Licdate,
      @Semantics.amount.currencyCode: 'Waers'
      dutysaveval    as Dutysaveval,
      @Semantics.amount.currencyCode: 'Waers'
      plannedexpobg  as Plannedexpobg,
      @Semantics.amount.currencyCode: 'Waers'
      average        as Average,
      @Semantics.amount.currencyCode: 'Waers'
      expobg1        as Expobg1,  
      _item

}
