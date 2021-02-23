CLASS zyb_cl_msag_cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZYB_CL_MSAG_CUST IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: ls_msag TYPE zyb_msag_cust,
          lt_msag TYPE TABLE OF zyb_msag_cust.

    IF io_request->is_data_requested( ).


      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).

      DATA(range) = lt_range_table[ name = 'CLASSNAME' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'MSAG'
      AND abapobjectisdeleted <>'X'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_msag_object).

      LOOP AT lt_msag_object ASSIGNING FIELD-SYMBOL(<lfs_msag_object>).

        ls_msag-classname = <lfs_msag_object>-abapobject.
        DATA(lo_message_class) = xco_cp_abap_repository=>object->msag->for( CONV #( <lfs_msag_object>-abapobject ) ).
        DATA(lt_message) =  lo_message_class->messages->all->get(  ).

        LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<lfs_message>).
          ls_msag-message = <lfs_message>->content(  )->get(  )-short_text.
          ls_msag-msgnumber = <lfs_message>->number.

          APPEND ls_msag TO lt_msag.
        ENDLOOP.
      ENDLOOP.

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
                                      THEN 'MSGNUMBER'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_msag_response TYPE STANDARD TABLE OF zyb_msag_cust.

      SELECT (lv_req_elements) FROM @lt_msag AS object
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_msag_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_msag_response ).

    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_msag AS response
                        INTO @DATA(lv_msag_count).

      io_response->set_total_number_of_records( lv_msag_count ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
