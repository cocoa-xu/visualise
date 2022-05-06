defmodule VisualiseTest do
  use ExUnit.Case
  doctest Visualise

  @confusion_matrix_specs %VegaLite{
    spec: %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "data" => %{
        "values" => [
          %{
            "count" => 0,
            "label for the x axis" => 2,
            "label for the y axis" => 2
          },
          %{
            "count" => 1,
            "label for the x axis" => 1,
            "label for the y axis" => 2
          },
          %{
            "count" => 0,
            "label for the x axis" => 0,
            "label for the y axis" => 2
          },
          %{
            "count" => 1,
            "label for the x axis" => 2,
            "label for the y axis" => 1
          },
          %{
            "count" => 0,
            "label for the x axis" => 1,
            "label for the y axis" => 1
          },
          %{
            "count" => 0,
            "label for the x axis" => 0,
            "label for the y axis" => 1
          },
          %{
            "count" => 0,
            "label for the x axis" => 2,
            "label for the y axis" => 0
          },
          %{
            "count" => 0,
            "label for the x axis" => 1,
            "label for the y axis" => 0
          },
          %{
            "count" => 1,
            "label for the x axis" => 0,
            "label for the y axis" => 0
          }
        ]
      },
      "encoding" => %{
        "color" => %{
          "field" => "count",
          "type" => "quantitative"
        },
        "x" => %{
          "field" => "label for the x axis",
          "type" => "nominal"
        },
        "y" => %{
          "field" => "label for the y axis",
          "type" => "nominal"
        }
      },
      "mark" => "rect",
      "title" => "test"
    }
  }
  test "confusion matrix" do
    assert @confusion_matrix_specs ==
             Visualise.confusion_matrix(
               Nx.tensor([0, 1, 2]),
               Nx.tensor([0, 2, 1]),
               title: "test",
               xlabel: "label for the x axis",
               ylabel: "label for the y axis",
               name: "count",
               num_classes: 3
             )
  end

  @confusion_matrix_specs %VegaLite{
    spec: %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "data" => %{
        "values" => [
          %{"pred" => 1, "true" => 1, "value" => 0},
          %{"pred" => 0, "true" => 1, "value" => 1},
          %{"pred" => 1, "true" => 0, "value" => 0},
          %{"pred" => 0, "true" => 0, "value" => 1}
        ]
      },
      "encoding" => %{
        "color" => %{
          "field" => "value",
          "type" => "quantitative"
        },
        "x" => %{"field" => "pred", "type" => "nominal"},
        "y" => %{"field" => "true", "type" => "nominal"}
      },
      "mark" => "rect",
      "title" => nil
    }
  }
  test "confusion matrix with all default values" do
    assert @confusion_matrix_specs ==
             Visualise.confusion_matrix(
               Nx.tensor([0, 1]),
               Nx.tensor([0, 0])
             )
  end
end
