# coding: utf-8

module Fluent
  class FilterKeysOutput < Output
    include Fluent::HandleTagNameMixin

    Fluent::Plugin.register_output('filter_keys', self)

    config_param :ensure_keys, :string, :default => nil
    config_param :denied_keys, :string, :default => nil
    config_param :discard_tag, :string, :default => nil

    def configure(conf)
      super

      if (ensure_keys && denied_keys) || (ensure_keys.nil? && denied_keys.nil?)
        raise ConfigError, "filter_keys: Either ensure_keys or denied_keys are required to be set."
      end

      @ensure_keys = ensure_keys && ensure_keys.split(/\s*,\s*/)
      @denied_keys = denied_keys && denied_keys.split(/\s*,\s*/)
      @discard_tag = discard_tag
    end

    def emit(tag, es, chain)
      es.each { |time, record|
        t = tag.dup
        filter_record(t, time, record)
        if ensure_keys_in?(record) || denied_keys_not_in?(record)
          Engine.emit(t, time, record)
        else
          if @discard_tag != nil
            t = @discard_tag << '.' << t
            Engine.emit(t, time, record)
          end
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
