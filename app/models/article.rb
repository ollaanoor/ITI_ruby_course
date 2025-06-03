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

class Article < ApplicationRecord
    belongs_to :user
    has_one_attached :image
    has_many :reports

    # after_update :check_reports_threshold
    before_save :check_reports_threshold

    private

    def check_reports_threshold
        if (reports_count || 0) >= 3 && !archived?
            update_column(:archived, true)
        end
    end
end
