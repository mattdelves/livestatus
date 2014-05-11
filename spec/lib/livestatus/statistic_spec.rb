require 'spec_helper'
require 'livestatus/statistic'

describe Livestatus::Statistic do

  before :each do
    Timecop.freeze(Time.utc(2014, 3, 26, 12, 0, 0))
    @notification = {
      controller: "FoobarController",
      action: "home",
      params: {"controller" => "foobar", "action" => "home"},
      format: :html,
      path: "/",
      status: 200,
      view_runtime: 220.13,
      db_runtime: 12.0
    }
    @statistic = Livestatus::Statistic.new @notification

    @influxdb_double = double(write_point: "foo", query: [{point: "123"}])

    allow(::InfluxDB::Client).to receive(:new).and_return(@influxdb_double)
  end

  after :each do
    Timecop.return
  end

  it "formats from notifications hash" do
    expect(@statistic.controller).to eql "FoobarController"
  end

  it "formats the object as json" do
    expect(@statistic.to_json).to eql "{\"controller\":\"FoobarController\",\"action\":\"home\",\"view_runtime\":220.13,\"db_runtime\":12.0,\"format\":\"html\",\"method\":null,\"path\":\"/\",\"params\":{\"controller\":\"foobar\",\"action\":\"home\"}}"
  end

#  it "saves to redis with the key as the timestamp" do
#    @statistic.save
#  end

  it "saves data creating a new object" do
    expect(Livestatus::Statistic.save_notification @notification).not_to be_nil
  end

  it "show recent stats" do
    200.times do
      Livestatus::Statistic.save_notification @notification
    end
    json_results = JSON.parse(File.read('spec/fixtures/query_results.json'))
    key = "#{@notification[:controller]}_#{@notification[:action]}_#{@notification[:status]}_view_runtime".downcase
    expect(@influxdb_double).to receive(:query).and_return(json_results)
    expect((Livestatus::Statistic.recent key).size).to eql 100
  end

  it "gets all of the available keys" do
    json_results = {"foobar_home_200_view_runtime"=>[], "foobar_home_db_runtime"=>[]}
    expect(@influxdb_double).to receive(:query).and_return(json_results)
    expect((Livestatus::Statistic.series).size).to eql 2
  end

end
