module ApplicationHelper
  def default_meta_tags
    {
      site: "Memo Sprout", # サイト名
      title: title,
      reverse: true,
      charset: "utf-8",
      description: "一言入力で新たな思考の芽を生やすメモアプリ",
      canonical: request.original_url, # 優先されるurl
    separator: "|", # titleとdescriptionの間に入る記号
      icon: [
        { href: image_url("favicon.ico") },
        { href: image_url("apple-touch-icon.png"), rel: "apple-touch-icon", sizes: "180x180" } # スマホ用
      ],
      og: {
        site_name: "Memo Sprout",
        title: title,
        description: "一言入力で新たな思考の芽を生やすメモアプリ",
        type: "website", # websiteかarticle
        url: request.original_url,
        image: image_url("sample_ogp.png"), # OGP
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image", # OGPの種類
        site: "@t_kana_54b"
      }
    }
  end
end
