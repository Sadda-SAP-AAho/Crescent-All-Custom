CLASS zcl_tmgdelete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TMGDELETE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
     DELETE FROM zdt_exp_costc.
     out->write( 'Hello from ADT Class Run! Table Deleted' ).
  ENDMETHOD.
ENDCLASS.
