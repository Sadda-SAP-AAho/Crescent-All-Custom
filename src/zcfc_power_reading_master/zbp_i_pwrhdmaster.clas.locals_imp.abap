CLASS lhc_zi_pwrhdmaster DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_pwrhdmaster RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_pwrhdmaster RESULT result.

    METHODS checksubhdcod FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pwrhdmaster~checksubhdcod.

ENDCLASS.

CLASS lhc_zi_pwrhdmaster IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD checksubhdcod.
    READ ENTITIES OF zi_pwrhdmaster IN LOCAL MODE
           ENTITY zi_pwrhdmaster
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE subheadcd FROM zi_pwrhdmaster
    WHERE subheadcd = @gfs_header-subheadcd INTO @DATA(ls_subhdcd).
    IF ls_subhdcd IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_pwrhdmaster WHERE subheadcd = @gfs_header-subheadcd
      INTO @DATA(ls_subhead1).
      IF ls_subhead1 IS NOT INITIAL.
        DATA(lv_msg1) = |Sub Head Code is already used|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_pwrhdmaster.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_pwrhdmaster.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
