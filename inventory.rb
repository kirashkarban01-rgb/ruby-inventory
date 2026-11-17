require 'json'

module Inventory
  class Error < StandardError; end
  class ReadError < Error; end
  class DataError < Error; end

  def self.load(path)
    products = JSON.parse(File.read(path, encoding: 'UTF-8'))

    unless products.is_a?(Array)
      raise DataError, 'Корінь JSON має бути масивом'
    end

    products.each_with_index do |product, index|
      number = index + 1

      unless product.is_a?(Hash)
        raise DataError, "Запис №#{number}: має бути об’єктом"
      end

      unless product['name'].is_a?(String) && !product['name'].strip.empty?
        raise DataError, "Запис №#{number}: name має бути непорожнім рядком"
      end

      ['price_in_kopecks', 'quantity'].each do |field|
        value = product[field]
        unless value.is_a?(Integer) && value >= 0
          raise DataError, "Запис №#{number}: #{field} має бути невід’ємним Integer"
        end
      end
    end

    products
  rescue Errno::ENOENT
    raise ReadError, "Файл не знайдено: #{path}"
  rescue JSON::ParserError => e
    raise DataError, "Некоректний JSON: #{e.message}"
  end

  def self.total(products)
    products.sum do |product|
      product['price_in_kopecks'] * product['quantity']
    end
  end
end
