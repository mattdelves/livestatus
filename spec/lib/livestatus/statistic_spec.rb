require 'spec_helper'
require 'livestatus/statistic'

describe Livestatus::Statistic do

  before :each do
#    REDIS.flush
  end

  after :each do

  end

  it "formats from notifications hash" do
    notifications = {
                     controller: "FoobarController",
                     action: "home",
                     params: {"controller" => "foobar", "action" => "home"},
                     format: :html,
                     path: "/",
                     status: 200,
                     view_runtime: 220.13,
                     db_runtime: 12.0
                    }
    statistic = Livestatus::Statistic.new notifications
    expect(statistic.controller).to eql "FoobarController"
  end

end
