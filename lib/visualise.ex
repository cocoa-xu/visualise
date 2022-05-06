defmodule Visualise do
  @moduledoc """
  Documentation for `Visualise`.
  """

  alias VegaLite, as: Vl

  @doc """
  Plot confusion matrix given rank-1 tensors which represent
  the expected (`y_true`) and predicted (`y_pred`) classes.

  ## Options
    * `:title` - optional. Set the title of the plot.
      Defaults to `nil`.
    * `:xlabel` - optional. Set x label text.
      Defaults to `:pred`.
    * `:ylabel` - optional. Set y label text.
      Defaults to `true`.
    * `:name` - optional. Name shown in the legend.
      Defaults to `:value`.
    * `:num_classes` - optional. Number of classes contained in the input tensor.
      Default value: `1 + Nx.take(y_true, Nx.argmax(y_true))`

  ## Examples

      iex> y_true = Nx.tensor([0, 1, 2])
      iex> y_pred = Nx.tensor([0, 2, 1])
      iex> Visualise.confusion_matrix(y_true, y_pred, num_classes: 3)

  """
  def confusion_matrix(y_true, y_pred, opts \\ []) do
    title = opts[:title] || nil
    xlabel = opts[:xlabel] || "pred"
    ylabel = opts[:ylabel] || "true"
    name = opts[:name] || "value"

    num_classes =
      opts[:num_classes] ||
        (Nx.take(y_true, Nx.argmax(y_true) |> Nx.reshape({1}))
         |> Nx.to_flat_list()
         |> hd()) + 1

    # compute confusion matrix
    zeros = Nx.broadcast(0, {num_classes, num_classes})
    indices = Nx.concatenate([Nx.new_axis(y_true, 1), Nx.new_axis(y_pred, 1)], axis: 1)
    updates = Nx.broadcast(1, {Nx.size(y_true)})
    cm = Nx.indexed_add(zeros, indices, updates)

    # generate data for VegaLite
    data =
      for true_label <- Enum.to_list(0..(num_classes - 1)), reduce: [] do
        row ->
          row_val = Nx.take(cm, Nx.tensor(true_label))

          for pred_label <- Enum.to_list(0..(num_classes - 1)), reduce: row do
            acc ->
              val = Nx.take(row_val, Nx.tensor([pred_label])) |> Nx.sum() |> Nx.to_number()
              [%{xlabel => pred_label, ylabel => true_label, name => val} | acc]
          end
      end

    Vl.new(title: title)
    |> Vl.mark(:rect)
    |> Vl.data_from_values(data)
    |> Vl.encode_field(:x, xlabel, type: :nominal)
    |> Vl.encode_field(:y, ylabel, type: :nominal)
    |> Vl.encode_field(:color, name, type: :quantitative)
  end
end
