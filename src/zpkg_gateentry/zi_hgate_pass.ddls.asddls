@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface For Header Gate Pass Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
define root view entity ZI_HGATE_PASS
  as select from ztm_hgate_pass
  composition [0..*] of ZI_ItemGATE_PASS as _Item
{
  key    id                                            as Id,
         gatepass                                      as Gatepass,
         ebeln                                         as Ebeln,
         gatetype                                      as Gatetype,
         lifnr                                         as Lifnr,
         bedat                                         as Bedat,
         createdate                                    as CreateDate,
         createdby                                     as Createdby,
         createdtime                                   as Createdtime,
         excise                                        as Excise,
         matcategory                                   as Matcategory,
         empcode                                       as Empcode,
         requester                                     as Requester,
         approver                                      as Approver,
         approvername                                  as Approvername,
         depmtcode                                     as Depmtcode,
         transname                                     as Transname,
         lrno                                          as Lrno,
         lrdate                                        as Lrdate,
         vehino                                        as Vehino,
         depmtname                                     as Depmtname,
         name1                                         as Name1,
         housenum1                                     as Housenum1,
         street                                        as Street,
         city1                                         as City1,
         postcode1                                     as Postcode1,
         telnumber                                     as Telnumber,
         mobnumber                                     as Mobnumber,
         status                                        as Status,
         canceldate                                    as Canceldate,
         canceltime                                    as Canceltime,
         canceluname                                   as Canceluname,
         cancelremarks                                 as Cancelremarks,
         appr0prepby                                   as Appr0prepby,
         appr0name                                     as Appr0name,
         appr0desig                                    as Appr0desig,
         appr0dept                                     as Appr0dept,
         appr1approver                                 as Appr1approver,
         appr1name                                     as Appr1name,
         appr1desig                                    as Appr1desig,
         appr1dept                                     as Appr1dept,
         appr1status                                   as Appr1status,
         appr1timestamp                                as Appr1timestamp,
         appr2approver                                 as Appr2approver,
         appr2name                                     as Appr2name,
         appr2desig                                    as Appr2desig,
         appr2dept                                     as Appr2dept,
         appr2status                                   as Appr2status,
         appr2timestamp                                as Appr2timestamp,
         appr3approver                                 as Appr3approver,
         appr3name                                     as Appr3name,
         appr3desig                                    as Appr3desig,
         appr3dept                                     as Appr3dept,
         appr3status                                   as Appr3status,
         appr3timestamp                                as Appr3timestamp,
         appr4approver                                 as Appr4approver,
         appr4name                                     as Appr4name,
         appr4desig                                    as Appr4desig,
         appr4dept                                     as Appr4dept,
         appr4status                                   as Appr4status,
         appr4timestamp                                as Appr4timestamp,
         shiptoaddress                                 as Shiptoaddress,
         stcd3                                         as Stcd3,
         appr5approver                                 as Appr5approver,
         appr5name                                     as Appr5name,
         appr5desig                                    as Appr5desig,
         appr5dept                                     as Appr5dept,
         appr5status                                   as Appr5status,
         appr5timestamp                                as Appr5timestamp,
         zfinaldate                                    as Zfinaldate,
         zfinaltime                                    as Zfinaltime,
         code,
         ztm_hgate_pass.status1                        as Status1,
         tplant as tplant,  //++AK(11/09/24)
         tplant_addr as Plant_addr, //++AK(11/09/24)
         plantaddr as plantaddr,
         
         
         case  when status1 = 'Created' then 1
               when status1 = '1st Approved' then 2
               when status1 = '2nd Approved' then 2
               when status1 = '3rd Approved' then 2
               when status1 = '4th Approved' then 2
               else 3 end                              as Criticality,
         cast( case status1 when 'Created' then 10
                             when '1st Approved' then 25
                             when '2nd Approved' then 50
                             when '3rd Approved' then 75
                             when '4th Approved' then 100
                             else 0 end as abap.int4 ) as Progress,
         cast( 100 as abap.int4 )                      as Total,
         tprint                                        as tprint,
         _Item
}
