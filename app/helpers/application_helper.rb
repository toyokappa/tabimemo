module ApplicationHelper
  def new_spot_field(f)
    new_object = f.object.spots.new
    id = "new_spot"
    plan_id = f.object.id
    fields = f.fields_for(:spots, new_object, child_index: id) do |builder|
      render "/users/plans/spot_fields", f: builder
    end
    { fields: fields.gsub("\n", ""), id: id, plan_id: plan_id }
  end

  def new_photo_field(f)
    new_object = f.object.photos.new
    id = "new_photo"
    fields = f.fields_for(:photos, new_object, child_index: id) do |builder|
      render "/users/plans/photo_fields", f: builder
    end
    { fields: fields.gsub("\n", ""), id: id }
  end
  
  def url_without_protocol(url)
    url_without_protocol = url.split("/").drop(2).join("/")
  end

  def default_meta_tags
    {
      site: t("app.title"),
      reverse: true,
      charset: "utf-8",
      keyword: "TABIMEMO, たびめも, 旅行, プラン, スポット, 観光",
      description: "旅行のプランをシェアするサービス。旅行の想い出をプランとして投稿したり、他のユーザーが登録したプランを検索できる。今度の休みはどこに行こう？と悩んだらプランを検索してみましょう。",
      icon: [
        { href: image_url("favicon.ico") },
        { href: image_url("icon.png"), rel: "apple-touch-icon", sizes: "180x180", type: "image/png" }
      ],
      og: {
        site_name: t("app.title"),
        description: "旅行のプランをシェアするサービス。旅行の想い出をプランとして投稿したり、他のユーザーが登録したプランを検索できる。今度の休みはどこに行こう？と悩んだらプランを検索してみましょう。",
        type: "website",
        url: request.original_url,
        locale: "ja_JP"
      },
      twitter: {
        card: "summary",
        title: t("app.title"),
        description: "旅行のプランをシェアするサービス。旅行の想い出をプランとして投稿したり、他のユーザーが登録したプランを検索できる。今度の休みはどこに行こう？と悩んだらプランを検索してみましょう。",
        site: "@toyokappa"
      }
    }
  end
end
