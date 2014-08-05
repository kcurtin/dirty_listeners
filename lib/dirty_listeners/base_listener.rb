module DirtyListener
  class BaseListener
    attr_accessor :run_condition

    def self.listening_to(thing, &specification)
      define_method(thing) do
        instance_variable_get("@obj")
      end

      instance_eval(&specification)
    end

    def self.on(event, options = {}, &action)
      define_method(:"on_#{event}") do |old, new|
        return if options[:unless] && eval(options[:unless])

        instance_variable_get("@obj").instance_exec(old, new, &action)
      end
    end

    def self.order(*methods)
      define_method(:ordered_methods) do
        methods.uniq
      end
    end

    def perform(lifecycle_event, obj)
      return unless run_condition

      @obj = obj

      ordered_attributes.each do |attribute, _|
        next unless changes[attribute]

        old, new = changes[attribute]
        callback_meth = "on_#{attribute}_change"
        send(callback_meth, old, new) if respond_to? callback_meth, true
      end
    end

    private

    # Override me to prevent callbacks from running
    def run_condition
      true
    end

    def changes
      @obj.changes
    end

    def ordered_attributes
      specified_order.each_with_index do |attribute, position|
        callback_order[attribute] = position
      end

      changes.keys.reject { |attribute| callback_order[attribute] }.each do |attribute|
        callback_order[attribute] = callback_order.length
      end

      callback_order.sort_by &:last
    end

    def specified_order
      return [] unless defined?(ordered_methods)

      ordered_methods.flat_map do |m|
        m.to_s.split('_change')
      end
    end

    def callback_order
      @callback_order ||= {}
    end
  end
end
