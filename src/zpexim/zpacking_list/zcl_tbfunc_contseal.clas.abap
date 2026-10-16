CLASS zcl_tbfunc_contseal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_contcarseal.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TBFUNC_CONTSEAL IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
              FOR HDB
              LANGUAGE SQLSCRIPT
              OPTIONS READ-ONLY
              USING z_i_billingdocument z_i_billingdocumentitem  ZI_DELDASH_HDR .

    lt_item = select * from z_i_billingdocumentitem ;

    lt_item1 = SELECT DISTINCT a.billingdocument, c.contno , c.carsealno
           from Z_i_billingdocument as a
           left outer join :lt_item as b on a.billingdocument = b.billingdocument
                                         and b.referencesddocumentcategory = 'J'
           left outer join ZI_DELDASH_HDR as c on c.delivery = b.ReferenceSDDocument

           where a.billingdocumenttype = 'F2'
                  and a.accountingpostingstatus <> 'E'
                  and c.canind <> 'X'
           group by a.billingdocument,c.contno , c.carsealno;

    lt_item2 = select distinct billingdocument,contno,carsealno,  count ( contno ) as num_a,count ( carsealno ) as num_b
               from :lt_item1
               group by billingdocument,contno,carsealno;



   lt_item3 = select    SESSION_CONTEXT( 'CDS_CLIENT' ) AS mandt,billingdocument,
                        case
                        when num_a > 1
                        then
                        string_agg( contno , ', ' )
                        else
                        string_agg( contno, ' ,' )
                        end as contnos,

                        case
                        when num_b > 1
                        then
                        string_agg( carsealno , ', ' )
                        else
                        string_agg( carsealno , ' ,' )
                        end as carsealnos

                        from :lt_item2
                        group by billingdocument,num_a,num_b;


return select * from :lt_item3 ;


  endmethod.
ENDCLASS.
