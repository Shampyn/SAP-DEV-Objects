@EndUserText.label: 'service binding custom'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_SRVB__CUST'
define custom entity ZYB_SRVB_CUST
{
  key ServiceBinding : zyb_srvb_name;
      @UI            : { identification: [ { position: 10, label:'Binding Type' } ] }
      Type           : zyb_sb_type;
      @UI            : { identification: [ { position: 20, label:'Binding Category' } ] }
      Category       : zyb_category;
      @UI            : { identification: [ { position: 30, label:'Binding Version' } ] }
      Version        : zyb_version;
}
