CLASS zfunc_mother_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES : if_amdp_marker_hdb.

  class-METHODS : get_mother for table FUNCTION ZMother_Item_func.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZFUNC_MOTHER_ITEM IMPLEMENTATION.


  METHOD get_mother by DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY.


  RETURN select SESSION_CONTEXT( 'CLIENT' ) AS client,cast( 'Yes' as NVARCHAR(3)) as Mother_Item,cast( 'Yes' as NVARCHAR(3)) as Child_Item  from dummy
      UNION ALL
  select SESSION_CONTEXT( 'CLIENT' ) AS client,cast( 'No' as NVARCHAR(3)) as Mother_Item,cast( 'No' as NVARCHAR(3)) as Child_Item  from dummy;


  ENDMETHOD.
ENDCLASS.
