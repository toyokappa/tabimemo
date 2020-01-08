SitemapGenerator::Sitemap.default_host = "https://tabimemo.xyz"

SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new
SitemapGenerator::Sitemap.create do
  Plan.published.find_each do |plan|
    add plan_path(plan), priority: 1.0, lastmod: plan.updated_at, changefreq: "always"
  end
end
