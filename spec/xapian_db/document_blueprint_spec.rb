# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe XapianDb::DocumentBlueprint do

  describe ".default_adapter= (singleton)" do
    it "sets the default adapter for all indexed classes" do
      XapianDb::DocumentBlueprint.default_adapter = DemoAdapter
    end
  end

  describe ".setup (singleton)" do
    it "stores a blueprint for a given class" do
      XapianDb::DocumentBlueprint.setup(IndexedObject)
      XapianDb::DocumentBlueprint.blueprint_for(IndexedObject).should be_a_kind_of(XapianDb::DocumentBlueprint)
    end

    it "adds an indexer to the blueprint" do
      XapianDb::DocumentBlueprint.setup(IndexedObject)
      XapianDb::DocumentBlueprint.blueprint_for(IndexedObject).indexer.should be_a_kind_of(XapianDb::Indexer)
    end
  end
  
  describe ".adapter=" do
    it "sets the adpater for the configured class" do
      XapianDb::DocumentBlueprint.setup(IndexedObject) do |blueprint|
        blueprint.adapter = DemoAdapter
      end
      XapianDb::DocumentBlueprint.blueprint_for(IndexedObject).adapter.should == DemoAdapter
    end
  end
  
  describe ".field" do
    it "adds a field to the blueprint" do
      XapianDb::DocumentBlueprint.setup(IndexedObject) do |blueprint|
        blueprint.field :id
      end
      XapianDb::DocumentBlueprint.blueprint_for(IndexedObject).fields.should include(:id)
    end

  end

  describe ".text" do
    it "adds an indexed value to the blueprint" do
      XapianDb::DocumentBlueprint.setup(IndexedObject) do |blueprint|
        blueprint.text :id
      end
      XapianDb::DocumentBlueprint.blueprint_for(IndexedObject).indexed_values[:id].should be
    end

    it "accepts weight as an option" do
      XapianDb::DocumentBlueprint.setup(IndexedObject) do |blueprint|
        blueprint.text :id, :weight => 10
      end
      XapianDb::DocumentBlueprint.blueprint_for(IndexedObject).indexed_values[:id].weight.should == 10
    end

  end
  
end