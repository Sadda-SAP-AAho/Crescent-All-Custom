CLASS lhc_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR hdr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR hdr RESULT result.
    METHODS getchild FOR VALIDATE ON SAVE
      IMPORTING keys FOR hdr~getchild.





ENDCLASS.

CLASS lhc_hdr IMPLEMENTATION.

  METHOD get_instance_features.


  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

  METHOD getChild.


  READ ENTITIES OF Z_I_Mother_Child in local mode
  ENTITY hdr FIELDS ( Mother_child_catagory )
  with CORRESPONDING  #( keys )
  RESULT data(lt_child).



    loop at lt_child ASSIGNING FIELD-SYMBOL(<ls_check>).



  check <ls_check>-Mother_child_catagory is NOT INITIAL.

select single Mother_child_catagory from zmthr_chld_ctgry where mother_child_catagory = @<ls_check>-Mother_child_catagory into @data(ls_child).
  if sy-subrc = 0.

   APPEND VALUE #( %tky = <ls_check>-%tky ) to failed-hdr.

  APPEND VALUE #( %tky = <ls_check>-%tky
                  %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text = 'Mother/Child Catagory Cannot be Repeated'
                   ) ) to reported-hdr.


  endif.



  endloop.




  ENDMETHOD.







ENDCLASS.
