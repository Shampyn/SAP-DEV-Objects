CLASS zyb_cl_srvb__cust DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZYB_CL_SRVB__CUST IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: ls_srvb TYPE zyb_srvb_cust,
          lt_srvb TYPE TABLE OF zyb_srvb_cust.

    IF io_request->is_data_requested( ).


      DATA(lt_range_table) = io_request->get_filter( )->get_as_ranges(  ).

      DATA(range) = lt_range_table[ name = 'SERVICEBINDING' ]-range.

      SELECT abapobject
      FROM i_custabapobjdirectoryentry
      WHERE abapobjecttype = 'SRVB'
      AND abapobjectisdeleted <>'X'
      AND abapobject IN @range
      INTO TABLE @DATA(lt_srvd_object).

      LOOP AT lt_srvd_object ASSIGNING FIELD-SYMBOL(<lfs_srvd_object>).

        ls_srvb-ServiceBinding = <lfs_srvd_object>-abapobject.
        DATA(lo_srvb) = xco_cp_abap_repository=>object->srvb->for( CONV #( <lfs_srvd_object>-abapobject ) ).

        ls_srvb-Type =  lo_srvb->content(  )->get(  )-binding_type->value-bind_type.
        ls_srvb-Category =  lo_srvb->content(  )->get(  )-binding_type->value-bind_type_category.
        ls_srvb-Version =  lo_srvb->content(  )->get(  )-binding_type->value-bind_type_version.

        APPEND ls_srvb TO lt_srvb.
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
                                      THEN 'SERVICEBINDING'
                                      ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).

      DATA(lt_req_elements) = io_request->get_requested_elements( ).
      DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = `, ` ).


      DATA lt_srvb_response TYPE STANDARD TABLE OF zyb_srvb_cust.

      SELECT (lv_req_elements) FROM @lt_srvb AS object
"               WHERE (lv_sql_filter)
               ORDER BY (lv_sort_string)
               INTO CORRESPONDING FIELDS OF TABLE @lt_srvb_response
               OFFSET @lv_offset UP TO @lv_max_rows ROWS.

      io_response->set_data( lt_srvb_response ).

    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).

      SELECT COUNT( * ) FROM @lt_srvb AS response
                        INTO @DATA(lv_srvd_count).

      io_response->set_total_number_of_records( lv_srvd_count ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
