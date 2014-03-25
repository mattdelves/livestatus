Livestatus::Engine.routes.draw do
  get "/" => "dashboard#index"
  get "/stream" => "dashboard#stream"
end
