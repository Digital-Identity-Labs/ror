defimpl String.Chars, for: ROR.Admin do
  @moduledoc false
  def to_string(s), do: Enum.join([s.created_at ,s.updated_at], ", ")
end

defimpl String.Chars, for: ROR.ExternalID do
  @moduledoc false
  def to_string(s), do: s.preferred || List.first(s.all || [])
end

defimpl String.Chars, for: ROR.Link do
  @moduledoc false
  def to_string(s), do: s.value
end

defimpl String.Chars, for: ROR.Location do
  @moduledoc false
  def to_string(s), do: s.name
end

defimpl String.Chars, for: ROR.Name do
  @moduledoc false
  def to_string(s), do: s.value
end

defimpl String.Chars, for: ROR.Organization do
  @moduledoc false
  def to_string(s), do: s.id
end

defimpl String.Chars, for: ROR.Relationship do
  @moduledoc false
  def to_string(s), do: s.id
end
