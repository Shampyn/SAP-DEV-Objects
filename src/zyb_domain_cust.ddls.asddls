@EndUserText.label: 'domain custom cds'
@ObjectModel.query.implementedBy: 'ABAP:ZYB_CL_DOMAIN_CUST'
define custom entity ZYB_DOMAIN_CUST
{
  key DomainObj   : zyb_doma_name;
      @UI         : { lineItem:       [ { position: 10, importance: #HIGH, label:'Fixed Value' }] ,
                        identification: [ { position: 10, label:'Fixed Value' } ] }
  key fixedValue  : zyb_fixed_value;
      @UI         : { lineItem:       [ { position: 20, importance: #HIGH, label:'Description' }] ,
                        identification: [ { position: 20, label:'Description' } ] }
      description : zyb_doma_description;
}
