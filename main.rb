require_relative 'inventory'

path = ARGV[0] || File.join(__dir__, 'data', 'products.json')

begin
  products = Inventory.load(path)
  total = Inventory.total(products)
  puts format('%d.%02d грн', total / 100, total % 100)
rescue Inventory::ReadError => e
  warn e.message
  exit 3
rescue Inventory::DataError => e
  warn e.message
  exit 2
end
