defmodule Sokoban.Undo do
  def new(max) do
    {[], [], 0, max}
  end

  def add({u, r, max, max}, item) do
    {[item | List.delete_at(u, -1)], r, max, max}
  end

  def add({u, r, count, max}, item) do
    {[item | u], r, count+1, max}
  end

  def undo({[], _, _, _}=state) do
    {nil, state}
  end

  def undo({[item | u], r, count, max}) do
    new_state = {u, [item | r], count, max}
    {item, new_state}
  end

  def redo({_u, [], _, _}=state) do
    {nil, state}
  end

  def redo({u, [item | r], count, max}) do
    new_state = {[item | u], r, count, max}
    {item, new_state}
  end
end
