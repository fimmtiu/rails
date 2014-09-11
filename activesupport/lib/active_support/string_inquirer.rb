module ActiveSupport
  # Wrapping a string in this class gives you a prettier way to test
  # for equality. The value returned by <tt>Rails.env</tt> is wrapped
  # in a StringInquirer object so instead of calling this:
  #
  #   Rails.env == 'production'
  #
  # you can call this:
  #
  #   Rails.env.production?
  #
  # If there's only a limited range of values that you want to respond to,
  # you can supply an array of them as a second argument to the
  # initializer, like so:
  #
  #   env = ActiveSupport::StringInquirer.new("production", %w(development test production))
  #   env.production?    # true
  #   env.blargh?        # raises NoMethodError

  class StringInquirer < String
    attr_accessor :permitted_values

    def initialize(contents, permitted_values = nil)
      if permitted_values
        permitted_values << contents
        @permitted_values = permitted_values.select(&:present?).uniq
      end
      super(contents)
    end

    private

      def respond_to_missing?(method_name, include_private = false)
        method_name[-1] == '?' && (permitted_values.nil? || permitted_values.include?(method_name[0..-2]))
      end

      def method_missing(method_name, *arguments)
        if respond_to_missing?(method_name)
          self == method_name[0..-2]
        else
          super
        end
      end
  end
end
