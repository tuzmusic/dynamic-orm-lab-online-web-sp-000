require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    info = DB[:conn].execute("pragma table_info(#{self.table_name})")
    info.map { |col| col['name'] }.compact
  end

  def initialize(hash={})
    hash.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    self.class.column_names.map { |name| "#{name}" }
    .delete_if {|n| n == 'id'}
    .join(", ")
  end

  def values_for_insert
    self.class.column_names.map do |col|
      self.send("'#{col}'")
    end
  end

end
