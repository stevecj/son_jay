require_relative('../../lib/son_jay')

module SonJayFeatureSupport
  def context_data
    @context_data ||= {}
  end

  def context_module
    @context_module ||= Module.new
  end
end

World(SonJayFeatureSupport)
