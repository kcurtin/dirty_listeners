module DirtyListener
  module Subscriptions
    extend ActiveSupport::Concern

    included do
      define_lifecycle_notifiers

      def subscribe(listener, options)
        lifecycle_event = options.fetch(:to)
        listeners[lifecycle_event] ||= []

        listeners[lifecycle_event] << listener
      end

      def notify(lifecycle_event)
        listeners[lifecycle_event] ||= []

        listeners[lifecycle_event].each do |listener|
          listener.perform(lifecycle_event, self)
        end
      end

      def listeners
        @listeners ||= {}
      end
    end

    module ClassMethods
      def define_lifecycle_notifiers
        klass = Object.const_get to_s

        %i(before_create after_create before_save after_save before_update after_update).each do |callback|
          callback_meth = :"_notify_listeners_#{callback}"
          lifecycle_event = callback

          klass.send(:define_method, callback_meth) do |&block|
            send(:notify, lifecycle_event)
          end

          klass.send(callback, callback_meth)
        end
      end
    end
  end
end
