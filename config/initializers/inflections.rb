# Be sure to REBOOT the SERVER when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
 ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
   inflect.uncountable %w( equipment )
   inflect.plural   /^(equipment)$/i, '\1s'
   inflect.singular /^(equipment)/i, '\1'
   inflect.plural   /^(addresses)$/i, '\1es'
   inflect.singular /^(address)es/i, '\1'
 end
