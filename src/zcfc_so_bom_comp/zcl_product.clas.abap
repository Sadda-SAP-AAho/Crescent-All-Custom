CLASS zcl_product DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PRODUCT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*  data:it_product type table of zproductgroupmap.
*
**  *fill internal table (it_product)
*    it_product = VALUE #(
*                          ( client = '100' productgroup = 'Z010' producttype = 'ZPAK' )
*                          ( client = '100' productgroup = 'Z011' producttype = 'ZPAK' )
*                          ( client = '100' productgroup = 'Z012' producttype = 'ZPAK' )
*                          ( client = '100' productgroup = 'Z013' producttype = 'ZPAK' )
*                          ( client = '100' productgroup = 'Z020' producttype = 'ZSFG' )
*                          ( client = '100' productgroup = 'Z030' producttype = 'ZSPR' )
*                          ( client = '100' productgroup = 'Z031' producttype = 'ZSPR' )
*                          ( client = '100' productgroup = 'Z032' producttype = 'ZSPR' )
*                          ( client = '100' productgroup = 'Z034' producttype = 'ZSFG' )
*                          ( client = '100' productgroup = 'Z036' producttype = 'ZTRD' )
*                          ( client = '100' productgroup = 'Z039' producttype = 'ZRAW' )
*                          ( client = '100' productgroup = 'Z041' producttype = 'ZSFG' )
*                          ( client = '100' productgroup = 'Z042' producttype = 'ZSFG' )
*    ).
**Delete the possible entries in the database table - in case it was already filled
*    DELETE FROM zproductgroupmap.
**insert the new table entries
*    INSERT zproductgroupmap FROM TABLE @it_product.
*
**   check the result
*SELECT * FROM zproductgroupmap INTO TABLE @it_product.
*    out->write( sy-dbcnt ).
*    out->write( EXPORTING data = it_product ).
*    out->write( 'data inserted successfully!' ).
  ENDMETHOD.
ENDCLASS.
