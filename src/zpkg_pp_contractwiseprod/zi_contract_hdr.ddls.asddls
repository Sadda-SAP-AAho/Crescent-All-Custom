@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@EndUserText.label: 'Header view for contractwise report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZI_CONTRACT_HDR
  as select distinct from ZCDS_POSTINGDATE1 as a
    left outer join       zdt_contract_hdr  as b on  a.Opr      = b.opr 
//                                                 and a.Shpflrdt = b.shpflrdt
                                                 and a.Dept     = b.dept
                                                 and a.Cont     = b.cont
                                                 and a.Plant    = b.plant
  composition [0..*] of ZI_CONTRACT_ITM as _item
{
  key a.Opr                                as Opr,
  key a.Plant                              as Plant,
  key a.Dept                               as Dept,
  key a.Cont                               as Cont,
      b.shpflrdt                           as Shpflrdt,
      a.Deptname                           as Deptname,
      a.Oprname                            as Oprname,
      cast( a.Contname as abap.char(200) ) as Contname,
      b.laboritemno1                       as laboritemno1,
      b.laboritemno2                       as laboritemno2,
      b.laboritemno3                       as laboritemno3,
      b.laboritemno4                       as laboritemno4,
      'X'                                  as Printrep,
      'X'                                  as Updateprint,
      _item

}

