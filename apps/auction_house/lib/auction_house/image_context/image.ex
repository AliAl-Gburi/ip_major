defmodule AuctionHouse.ImageContext.Image do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias AuctionHouse.ItemContext.Item



  #schema "images" do
  #  field :link, :string
  #  belongs_to :item, Item
  #end

  #def changeset(image, attrs) do
  #  image
  #  |> cast(attrs, [:link])
  #  |> validate_required([:link])
  #end



  schema "images" do
  field :filename, :string
  field :content_type, :string
  field :hash, :string
  field :size, :integer
  belongs_to :item, Item

  end

  @doc false
  def changeset(image, attrs) do
  image
  |> cast(attrs, [:filename,
  :content_type,
  :hash,
  :size])
  |> validate_required([:filename,
  :content_type,
  :hash,
  :size])
  |> validate_number(:size, greater_than: 0)
  |> validate_length(:hash, is: 64)
  end

  def sha256(chunks_enum) do
  chunks_enum
  |> Enum.reduce(
  :crypto.hash_init(:sha256),
  &:crypto.hash_update(&2, &1)
  )
  |> :crypto.hash_final()
  |> Base.encode16()
  |> String.downcase()
  end



  def addAssoc(image, %Item{} = item) do
    image
    |> put_assoc(:item, item)
  end
end
