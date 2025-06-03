class AddReportsCountToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :reports_count, :integer
  end
end
