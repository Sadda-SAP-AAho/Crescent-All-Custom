CLASS zcl_tbfunc_concatpo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_amdp_marker_hdb .
  CLASS-METHODS get_data FOR TABLE FUNCTION ZTBL_FUNC_CONCATPO.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TBFUNC_CONCATPO IMPLEMENTATION.


 METHOD get_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                     USING ZCDS_CONCATPO.

    lt_item = SELECT * from ZCDS_CONCATPO;

    lt_item1 = SELECT DISTINCT deliverydocument,revision, COUNT ( zcuspodate  ) as num_a from :lt_item
               GROUP BY deliverydocument , revision;

    lt_item2 = select b.mandt ,a.deliverydocument,a.revision,
                        case
                        when num_a > 1
                        then
                        string_agg( b.zcuspodate , ', ' )
                        else
                        string_agg( b.zcuspodate  , '' )
                        end as zcuspodate
                from :lt_item1 as a
                inner join :lt_item as b on b.deliverydocument = a.deliverydocument
                                         and b.revision = a.revision

                group by b.mandt,a.deliverydocument,a.revision,num_a;



     RETURN  select *
       from :lt_item2;


  ENDMETHOD.
ENDCLASS.
