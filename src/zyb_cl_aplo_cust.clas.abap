CLASS zyb_cl_aplo_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zyb_cl_aplo_cust IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: ls_subobj TYPE zyb_aplo_cust,
          lt_subobj TYPE TABLE OF zyb_aplo_cust.

    IF io_request->is_data_requested( ).


      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).


      DATA(range) = lt_range_table[ name = 'OBJECT' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'APLO'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_aplo).

      DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).

      LOOP AT lt_aplo ASSIGNING FIELD-SYMBOL(<lfs_aplo>).
        ls_subobj-object = <lfs_aplo>-abapobject.

        TRY.
            lo_log_object->read_object( EXPORTING iv_object = CONV #( <lfs_aplo>-abapobject )
                                        IMPORTING et_subobjects = DATA(lt_subobjects) ).

            LOOP AT lt_subobjects ASSIGNING FIELD-SYMBOL(<lfs_aplo_subobject>).
              ls_subobj-subobject = <lfs_aplo_subobject>-subobject.
              ls_subobj-subobjecttext = <lfs_aplo_subobject>-subobject_text.

              APPEND ls_subobj TO lt_subobj.

            ENDLOOP.
          CATCH cx_bali_objects.

        ENDTRY.

      ENDLOOP.

      IF lt_subobj IS NOT INITIAL.

        DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
        DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
                                    ELSE lv_page_size ).

        DATA(sort_elements) = io_request->get_sort_elements( ).
        DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN sort_elements
                                                   ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                          THEN ` descending`
                                                                                          ELSE ` ascending` ) ) ).
        DATA(lv_sort_string)  = COND #( WHEN lt_sort_criteria IS INITIAL
                                        THEN 'subObject'
                                        ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

        DATA(lt_req_elements) = io_request->get_requested_elements( ).
        DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


        DATA lt_aplo_response TYPE STANDARD TABLE OF zyb_aplo_cust.

        SELECT (lv_req_elements) FROM @lt_subobj AS subobject
                 ORDER BY (lv_sort_string)
                 INTO CORRESPONDING FIELDS OF TABLE @lt_aplo_response
                 OFFSET @lv_offset UP TO @lv_max_rows ROWS.

        io_response->set_data( lt_aplo_response ).
      ELSE.
        io_response->set_data( lt_subobj ).
      ENDIF.
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_subobj AS response
                        INTO @DATA(lv_aplo_count).

      io_response->set_total_number_of_records( lv_aplo_count ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
