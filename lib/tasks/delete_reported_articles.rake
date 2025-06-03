namespace :articles do
    desc "Delete articles with 6 or more reports"
    task remove_reported: :environment do
      flagged_articles = Article.where('reports_count >= ?', 6)
      count = flagged_articles.count
      flagged_articles.destroy_all
      puts "Removed #{count} reported article(s) at #{Time.current}"
    end
  end
  