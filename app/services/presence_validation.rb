class PresenceValidation < ApplicationService

  def initialize(args = {})
    args.each do |key, value|
      instance_variable_set("@#{key}", value)
      self.class.send(:attr_reader, key.to_sym)
    end
  end

  def call
    # Return an array with boolean values true if not nil / false if nil
    presence = instance_variables.map { |inst| instance_variable_get(inst).nil? }
    !presence.include?(true)
  end
end