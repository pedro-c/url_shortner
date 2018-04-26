defmodule UrlShortener.Cache.UrlCacheSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(url) do
    Supervisor.start_child(__MODULE__, [url])
  end

  def init([]) do
    children = [
      worker(UrlShortener.Cache.UrlCache, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
