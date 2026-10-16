CLASS zcl_expense DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS commit_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EXPENSE IMPLEMENTATION.


  METHOD commit_data .

    "-- Commit and get the SES number
    COMMIT ENTITIES
    BEGIN RESPONSE OF i_serviceentrysheettp_2
    REPORTED DATA(reported_late)
    FAILED DATA(failed_late).

*    LOOP AT ls_mapped_crt-serviceentrysheet ASSIGNING FIELD-SYMBOL(<mapped>).
*      CONVERT KEY OF i_serviceentrysheettp_2 FROM <mapped>-%pid TO DATA(lv_ses).
*      <mapped>-serviceentrysheet = lv_ses.
*    ENDLOOP.

    COMMIT ENTITIES END.


  ENDMETHOD.
ENDCLASS.
