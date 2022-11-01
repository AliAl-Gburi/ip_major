defmodule AuctionHouse.ImageContext do
  @moduledoc """
  The ImageContext context.
  """

  import Ecto.Query, warn: false
  alias AuctionHouse.Repo

  alias AuctionHouse.ImageContext.Image
  alias AuctionHouse.ItemContext.Item

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images do
    Repo.all(Image)
  end

  def deleteAllImagesOfItem(id) do
    from(i in Image, where: i.item_id == ^id)
    |> Repo.delete_all()
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id)

  def getImageByItem!(id) do
    from(i in Image, where: i.item_id == ^id)
      |> Repo.all()
  end

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}, %Item{} = item) do


    %Image{}
    |> Image.changeset(attrs)
    |> Image.addAssoc(item)
    |> Repo.insert()
  end

  @spec create_image2(
          %{
            :content_type => any,
            :filename => any,
            :path =>
              binary
              | maybe_improper_list(
                  binary | maybe_improper_list(any, binary | []) | char,
                  binary | []
                ),
            optional(any) => any
          },
          atom | %{:id => any, optional(any) => any}
        ) :: any
  def create_image2(%{filename: _, path: tmp_path, content_type: _} = upload, item) do

    hash = File.stream!(tmp_path, [], 2048) |> Image.sha256()
    with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
         data_merged <- Map.from_struct(upload) |> Map.merge(%{size: size, hash: hash}),
         {:ok, upload_cs} <- %Image{} |> Image.changeset(data_merged) |> Image.addAssoc(item) |> Repo.insert(),
         :ok <- tmp_path |> File.cp("./apps/auction_house/priv/repo/uploads/#{upload_cs.id}-#{upload_cs.filename}") do

      {:ok, upload_cs}
    else
      {:error, reason} -> IO.inspect(reason)
    end
  end

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{data: %Image{}}

  """
  def change_image(%Image{} = image, attrs \\ %{}) do
    Image.changeset(image, attrs)
  end
end
