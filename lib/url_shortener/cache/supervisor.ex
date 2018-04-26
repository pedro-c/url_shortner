defmodule UrlShortener.Cache.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(UrlShortener.Cache.Mapper, []),
      supervisor(UrlShortener.Cache.UrlCacheSupervisor, [])
    ]

    supervise(children, strategy: :rest_for_one)
  end
end
