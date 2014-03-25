require 'spec_helper'
require 'livestatus/statistic'

describe Livestatus::Statistic do

  before :each do
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
    REDIS.flushall
  end

  after :each do

  end

  it "formats from notifications hash" do
    expect(@statistic.controller).to eql "FoobarController"
  end

  it "formats the object as json" do
    expect(@statistic.to_json).to eql "{\"controller\":\"FoobarController\",\"action\":\"home\",\"view_runtime\":220.13,\"db_runtime\":12.0,\"format\":\"html\",\"method\":null,\"path\":\"/\",\"params\":{\"controller\":\"foobar\",\"action\":\"home\"}}"
  end

  it "saves to redis with the key as the timestamp" do
    @statistic.save
  end

  it "saves data without creating a new object" do
    expect(Livestatus::Statistic.save_notification @notification).not_to be_nil
  end

  it "show recent stats" do
    REDIS.flushall
    200.times do
      Livestatus::Statistic.save_notification @notification
    end

    expect((Livestatus::Statistic.recent @notification[:controller], @notification[:action], @notification[:status]).size).to eql 100
  end

end
