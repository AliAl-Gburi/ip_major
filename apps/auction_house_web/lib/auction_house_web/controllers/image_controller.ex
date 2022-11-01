defmodule AuctionHouseWeb.ImageController do
  use AuctionHouseWeb, :controller

  alias AuctionHouse.ImageContext
  alias AuctionHouse.ItemContext

  def index(conn, _params) do
    images = ImageContext.list_images()
    render(conn, "index.html", images: images)
  end



  def create(conn, %{"image" => image_params, "aid" => aid, "iid" => iid}) do
    item_id = iid
    if upload = image_params["image"] do
      extension = Path.extname(upload.filename)
      images = ImageContext.getImageByItem!(iid)
      attrs = %{link: "#{item_id}-imgnr#{Enum.count(images) + 1}#{extension}"}
      item = ItemContext.get_item!(item_id)
      ImageContext.create_image(attrs, item)

      File.cp(upload.path, Path.relative("./apps/auction_house_web/priv/static/images/#{item_id}-imgnr#{Enum.count(images) + 1}#{extension}"))
      redirect(conn ,to: Routes.item_path(conn, :showItem, aid, iid))
    end


  end

  def create2(conn, %{"upload" => uploads, "aid" => aid, "iid" => iid}) do
    item = ItemContext.get_item!(iid)
    Enum.each(uploads, fn up -> IO.inspect(up); up |> ImageContext.create_image2(item) end)
    redirect(conn ,to: Routes.item_path(conn, :showItem, aid, iid))
  end



  def display(conn, %{"aid" => _id, "iid" => _iid, "imid" => imid}) do
    image = ImageContext.get_image!(imid)


    conn
    |> send_file(200, "./apps/auction_house/priv/repo/uploads/#{imid}-#{image.filename}")
  end






end
