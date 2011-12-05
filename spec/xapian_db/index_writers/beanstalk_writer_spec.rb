# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/xapian_db/index_writers/beanstalk_writer')

describe XapianDb::IndexWriters::BeanstalkWriter do

  before :each do
    XapianDb.setup do |config|
      config.adapter  :active_record
      config.database "/tmp/xapian_test"
      config.writer   :beanstalk
    end
    XapianDb::DocumentBlueprint.setup(ActiveRecordObject) do |blueprint|
      blueprint.attribute :id
      blueprint.attribute :name
    end
    @obj = ActiveRecordObject.new(1, "Gernot")
    @obj.save
    XapianDb.database.delete_docs_of_class @obj.class
    XapianDb.database.commit
  end

  after :each do
    FileUtils.rm_rf "/tmp/xapian_test"
  end

  describe ".index(obj)" do
    it "adds an object to the index" do
      XapianDb.database.size.should == 0
      XapianDb::IndexWriters::BeanstalkWriter.index @obj
      XapianDb.database.size.should == 1
    end
  end

  describe ".delete_doc_with(xapian_id)" do
    it "removes a document from the index" do
      XapianDb.database.size.should == 0
      XapianDb::IndexWriters::BeanstalkWriter.index @obj
      XapianDb.database.size.should == 1
      XapianDb::IndexWriters::BeanstalkWriter.delete_doc_with @obj.xapian_id
      XapianDb.database.size.should == 0
    end
  end

  describe ".reindex(klass)" do

    it "adds all instances of a class to the index" do
      XapianDb.database.size.should == 0
      XapianDb::IndexWriters::BeanstalkWriter.reindex_class ActiveRecordObject
      XapianDb.database.size.should == 1
    end

  end
end
