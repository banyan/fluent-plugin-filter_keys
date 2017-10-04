# coding: utf-8

module Fluent
  class FilterKeysOutput < Output
    include Fluent::HandleTagNameMixin

    # Define `router` method of v0.12 to support v0.10 or earlier
    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    Fluent::Plugin.register_output('filter_keys', self)

    config_param :ensure_keys, :string, :default => nil
    config_param :denied_keys, :string, :default => nil
    config_param :add_tag_and_reemit, :bool, :default => false

    DISCARD_TAG = 'discarded'

    def configure(conf)
      super

      if (ensure_keys && denied_keys) || (ensure_keys.nil? && denied_keys.nil?)
        raise ConfigError, "filter_keys: Either ensure_keys or denied_keys are required to be set."
      end

      @ensure_keys = ensure_keys && ensure_keys.split(/\s*,\s*/)
      @denied_keys = denied_keys && denied_keys.split(/\s*,\s*/)

    end

    def emit(tag, es, chain)
      es.each { |time, record|
        t = tag.dup
        filter_record(t, time, record)
        if ensure_keys_in?(record) || denied_keys_not_in?(record)
          router.emit(t, time, record)
        else
          router.emit("#{DISCARD_TAG}.#{t}", time, record) if @add_tag_and_reemit
        end
      }

      chain.next
    end

    def filter_record(tag, time, record)
      super(tag, time, record)
    end

    private
    def ensure_keys_in?(record)
      @ensure_keys && @ensure_keys.all? { |key| record.include? key }
    end

    def denied_keys_not_in?(record)
      @denied_keys && !@denied_keys.any? { |key| record.include? key }
    end
  end
end
