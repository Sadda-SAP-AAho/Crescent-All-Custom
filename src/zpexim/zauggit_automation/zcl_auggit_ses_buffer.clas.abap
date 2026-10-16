*CLASS zcl_auggit_ses_buffer DEFINITION
*  PUBLIC
*  FINAL
*  CREATE PUBLIC .
*
*  PUBLIC SECTION.
*  PROTECTED SECTION.
*  PRIVATE SECTION.
*ENDCLASS.
*
*
*
*CLASS zcl_auggit_ses_buffer IMPLEMENTATION.
*ENDCLASS.

CLASS zcl_auggit_ses_buffer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_ses,
        expenseid TYPE vbeln,
        pid       TYPE sysuuid_x16,
      END OF ty_ses.

    CLASS-DATA gt_ses TYPE STANDARD TABLE OF ty_ses.

ENDCLASS.

CLASS zcl_auggit_ses_buffer IMPLEMENTATION.
ENDCLASS.
