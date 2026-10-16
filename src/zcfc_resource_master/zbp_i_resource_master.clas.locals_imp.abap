CLASS lhc_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR hdr RESULT result.
    METHODS getplant FOR VALIDATE ON SAVE
      IMPORTING keys FOR hdr~getplant.



ENDCLASS.

CLASS lhc_hdr IMPLEMENTATION.

  METHOD get_instance_features.


  ENDMETHOD.

  METHOD get_instance_authorizations.


  ENDMETHOD.




  METHOD getPlant.


  READ ENTITIES OF Z_I_Resource_Master in local mode
  ENTITY hdr FIELDS ( Resource_code Plant )
  with CORRESPONDING  #( keys )
  RESULT data(lt_plant).



    loop at lt_plant ASSIGNING FIELD-SYMBOL(<ls_check>).

  check <ls_check>-Resource_code is NOT INITIAL and <ls_check>-Plant is NOT INITIAL.

  select single Requestuuid,Resource_code,Plant from zrsrc_mastr_head where Resource_code = @<ls_check>-Resource_code and Plant = @<ls_check>-Plant
  into @data(ls).
  if sy-subrc = 0.
*if ls-requestuuid = <ls_check>-%tky-Requestuuid.

   APPEND VALUE #( %tky = <ls_check>-%tky ) to failed-hdr.

  APPEND VALUE #( %tky = <ls_check>-%tky
                  %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Resource Code & Plant Cannot be Repeated'
                   ) ) to reported-hdr.


  endif.



  endloop.
  ENDMETHOD.

ENDCLASS.
