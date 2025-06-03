# == Schema Information
#
# Table name: articles
#
#  id            :integer          not null, primary key
#  body          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#  reports_count :integer
#  archived      :boolean
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#

require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
