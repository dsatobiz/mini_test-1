require "bundler/inline"
require "active_record"
require "minitest/autorun"

gemfile do
  source "https://rubygems.org"
  gem "activerecord"
  gem "sqlite3"
  gem "minitest"
end

class Resource < ActiveRecord::Base
  # TODO: Implement HERE
end

class Setting < ActiveRecord::Base
  # TODO: Implement HERE
end

class ResourceTest < Minitest::Test
  def setup
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define do
      create_table :resources do |t|
        t.string  :name,  null: false
        t.integer :status,  null: false
      end
      create_table :settings do |t|
        t.integer :source_id
        t.string  :source_type
        t.boolean :prepayable,  null: false
      end
    end

    1.upto(10) do |i|
      resource = Resource.new(name: "Resource #{i}", status: i.odd? ? :published : :draft)
      resource.build_setting(prepayable: i % 3 == 0 ? true : false)
      resource.save
    end
  end

  def test_published_prepayable_resources
    assert_equal Resource.published.prepayable.count, 2
    Resource.all.destroy_all
    assert_equal Setting.count, 0
  end
end
