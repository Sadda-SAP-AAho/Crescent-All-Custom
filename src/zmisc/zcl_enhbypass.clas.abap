CLASS zcl_enhbypass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS: enhcheck_bypass
      IMPORTING ev_enhid      TYPE char10
      RETURNING VALUE(result) TYPE char1 .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ENHBYPASS IMPLEMENTATION.


  METHOD enhcheck_bypass.
    CLEAR:result.
    CHECK ev_enhid IS NOT INITIAL .

    SELECT SINGLE * FROM zdt_enhcheck
                    WHERE enhid = @ev_enhid INTO @DATA(ls_enhcheck).
    IF sy-subrc EQ 0.
      result = 1 .
    ENDIF.

  ENDMETHOD.
ENDCLASS.
