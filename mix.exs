defmodule Visualise.MixProject do
  use Mix.Project

  def project do
    [
      app: :visualise,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nx, "~> 0.2"},
      {:scholar, "~> 0.1.0", github: "elixir-nx/scholar"},
      {:vega_lite, "~> 0.1.4"},
      {:kino_vega_lite, "~> 0.1.1"}
    ]
  end
end
