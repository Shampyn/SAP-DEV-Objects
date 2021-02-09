@EndUserText.label: 'service definition custom'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_SRVD_CUST'
define custom entity ZYB_SRVD_CUST
{
  key ServiceDefinition : zyb_srvd_name;
      @UI               : { lineItem:       [ { position: 10, importance: #HIGH, label:'Data Definition' }] ,
                            identification: [ { position: 10, label:'Data Definition' } ] }
  key entity            : zyb_entity_name;
      @UI               : { lineItem:       [ { position: 20, importance: #HIGH, label:'Alias' }] ,
                            identification: [ { position: 20, label:'Alias' } ] }
      AliasName         : zyb_alias_name;

}
