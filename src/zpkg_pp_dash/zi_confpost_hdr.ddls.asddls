@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Conf Post Header'
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_CONFPOST_HDR
  as select from zdt_confpost_hdr
  composition [0..*] of ZI_CONFPOST_ITM as _Item
  composition [0..*] of ZI_CONFPOST_ORD as _Ord
  composition [0..*] of ZI_CONFPOST_LOG as _Log
{
  key id                                    as Id,
      shpflrno                              as Shpflrno,
      refid                                 as Refid,
      keyid                                 as Keyid,
      dept                                  as Dept,
      deptname                              as Deptname,
      opr                                   as Opr,
      oprname                               as Oprname,
      cont                                  as Cont,
      contname                              as Contname,
      skilab                                as Skilab,
      sskilab                               as Sskilab,
      uskilab                               as Uskilab,
      plant                                 as Plant,
      creon                                 as Creon,
      creby                                 as Creby,
      plantid                               as Plantid,
      shpflrdt                              as Shpflrdt,
      getord                                as Getord,
      post                                  as Post,
      gi                                    as Gi,
      gr                                    as Gr,
      scrap                                 as Scrap,
      status                                as Status,
      stat                                  as Stat,
      arpacharg                             as Arpacharg,
      rhinocharg                            as Rhinocharg,
      handmochrg                            as Handmochrg,
      lostfmchrg                            as Lostfmchrg,
      excwtadj                              as Excwtadj,
      docudt                                as Docudt,
      uniqueid                              as Uniqueid,
      case when status = ' ' then cast( 0 as abap.int4 )
           when status = 'Created' then cast( 33 as abap.int4 )
           when status = 'Completed' then cast( 100 as abap.int4 )
           else cast( 66 as abap.int4 ) end as Progress,
      case when status = ' ' then cast( 1 as abap.int1 )
           when status = 'Completed' then cast( 3 as abap.int1 )
           else cast( 2 as abap.int1 ) end  as Criticality,
      cast( 100 as abap.int4 )              as Total,
      _Item, // Make association public
      _Ord,
      _Log
}
