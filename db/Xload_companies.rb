
# load_companies.rb -- load companies tables
# Companies and People
# First one is licensee, this admittedly fragile rule, is/was? used next to determine this status.
# Two methods here, names list and completely specified attributes.
companies_list = [
  "Roster365", 
  'Projects-r-us',
  'Trucks-r-us',
  "American Debris Box Service Inc."
]
companies_list.each do |name|
  Company.create!( name: name)
end

=begin

This fully specified approach works, but in practice is tedious and to fit all the 
associated information in is difficult.  It does serve as a store of a limited number
of richly specified Company associations.  These are seed'ed so preserved.

Company.create!(:name                        => 'American Debris Box Service Inc.',
                :active                      => false,
                :credit_terms                => 'no', 
                :bookeeping_number                 => '00000', 
                :PO_required                 => false,
                :addresses_attributes        => [
                           :addressable_type => 'Company', 
                           :state            => 'CA', 
                           :street_address   => 'PO Box 3187', 
                           :city             => 'Half Moon Bay', 
                           :post_code        => '94019', 
                           :map_reference    => nil
                                                ],
                :identifiers_attributes      => [
                          :identifiable_type => 'Company', 
                          :name              => 'Office', 
                          :rank              => 1, 
                          :value             => '(650) 712-8229'
                                                ],
                :certs_attributes            => []
              )
=end