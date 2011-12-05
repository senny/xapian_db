module XapianDb
  module IndexAware
    def inherited(clazz)
      super
      begin
        blueprint = XapianDb::DocumentBlueprint.blueprint_for(clazz)
        adapter = blueprint._adapter || XapianDb::Config.adapter || Adapters::GenericAdapter
        adapter.add_class_helper_methods_to clazz
      rescue => e
        # Blueprint is not defined
      end
    end
  end
end

Object.extend XapianDb::IndexAware
